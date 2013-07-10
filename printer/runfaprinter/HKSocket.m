//
//  HKSocket.m
//  huoku_starprinter_arc
//
//  Created by akwei on 13-6-30.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKSocket.h"
#import "GCDAsyncSocket.h"

@implementation HKSocketConnectionException
@end

@implementation HKSocketException
@end

@interface HKSocket ()
@property(nonatomic,strong)GCDAsyncSocket* socket;
@property(nonatomic,assign)dispatch_queue_t queue;
@property(nonatomic,strong)NSCondition* cond;
@property(nonatomic,strong)NSCondition* con_cond;
@property(nonatomic,assign)BOOL done;
@property(nonatomic,strong)NSMutableData* receivedData;
@property(nonatomic,strong)NSError* error;
@property(nonatomic,assign)BOOL isReadTimeout;
@property(nonatomic,assign)BOOL isWriteTimeout;
@end

@implementation HKSocket

-(id)initWithHost:(NSString *)host port:(NSUInteger)port timeout:(NSTimeInterval)timeout{
    self = [super init];
    if (self) {
        self.host = host;
        self.port = port;
        self.timeout = timeout;
        NSString* queueName = [NSString stringWithFormat:@"HKSocket_queueName_%@",[self description]];
        self.queue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
        self.done = NO;
        self.cond = [[NSCondition alloc] init];
        self.con_cond = [[NSCondition alloc] init];
    }
    return self;
}

-(id)init{
    NSLog(@"Plase invoke -(id)initWithHost:(NSString *)host port:(NSUInteger)port");
    return nil;
}

-(void)workWithBlock:(void (^)(void))block{
    [self.cond lock];
    @try {
        self.error = nil;
        self.isWriteTimeout = NO;
        self.isReadTimeout = NO;
        self.done = NO;
        block();
        while (!self.done) {
            [self.cond wait];
        }
        [self checkException];
    }
    @finally {
        self.done = NO;
        [self.cond unlock];
    }
}

-(void)checkException{
    if (self.isReadTimeout) {
        @throw [HKSocketException exceptionWithName:@"timeout" reason:@"read timeout" userInfo:nil];
    }
    else if (self.isWriteTimeout) {
        @throw [HKSocketException exceptionWithName:@"timeout" reason:@"write timeout" userInfo:nil];
    }
}

-(void)writeData:(NSData*)data{
    HKSocket* me = self;
    [self workWithBlock:^{
        [me.socket writeData:data withTimeout:self.timeout tag:1];
    }];
}

-(NSData *)readData{
    HKSocket* me = self;
    me.receivedData = nil;
    me.receivedData = [[NSMutableData alloc] init];
    [me workWithBlock:^{
        [me.socket readDataWithTimeout:me.timeout buffer:me.receivedData bufferOffset:0 tag:2];
        
    }];
    return self.receivedData;
}

-(void)afterResponse{
    [self.cond lock];
    self.done = YES;
    [self.cond signal];
    [self.cond unlock];
}

#pragma mark - GCDAsyncSocket delegate

-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    NSLog(@"shouldTimeoutReadWithTag %lx",tag);
    return self.timeout;
}

-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    NSLog(@"shouldTimeoutWriteWithTag %lx",tag);
    return self.timeout;
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port{
#if HK_SOCKET_DEBUG
    NSLog(@"connect to %@:%i",host,port);
#endif
    [self.con_cond lock];
    self.done = YES;
    [self.con_cond signal];
    [self.con_cond unlock];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
#if HK_SOCKET_DEBUG
    NSLog(@"data for tag %llu sent",(unsigned long long)tag);
#endif
    [self afterResponse];
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag{
#if HK_SOCKET_DEBUG
    NSLog(@"data for tag %llu didRead",(unsigned long long)tag);
#endif
    [self afterResponse];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    [self.con_cond lock];
#if HK_SOCKET_DEBUG
    if (err) {
        NSLog(@"socket disconnect err:%@",[err description]);
    }
    else{
        NSLog(@"socket disconnect ok");
    }
#endif
    self.done = YES;
    [self.con_cond signal];
    [self.con_cond unlock];
}

#pragma mark - open and close

-(void)open{
    if (!self.host || self.port<=0) {
        @throw [HKSocketConnectionException exceptionWithName:@"connect error" reason:@"must set host and port" userInfo:nil];
    }
    self.done = NO;
    [self.con_cond lock];
    if (self.socket) {
        self.socket = nil;
    }
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.queue];
    NSError *err = nil;
    NSException* ex;
    @try {
        if (![self.socket connectToHost:self.host onPort:self.port error:&err]) // Asynchronous!
        {
            // If there was an error, it's likely something like "already connected" or "no delegate set"
            ex = [HKSocketConnectionException exceptionWithName:@"connect error" reason:[err description] userInfo:nil];
            @throw ex;
        }
        while (!self.done) {
            [self.con_cond wait];
        }
    }
    @catch (NSException* exception) {
        self.socket = nil;
        @throw exception;
    }
    @finally {
        self.done = NO;
        [self.con_cond unlock];
    }
}

-(void)close{
    [self.con_cond lock];
    self.done = NO;
    if (self.socket) {
        [self.socket disconnect];
        while (!self.done) {
            [self.con_cond wait];
        }
    }
    self.done = NO;
    self.socket = nil;
    [self.con_cond unlock];
}

-(void)dealloc{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
    dispatch_release(_queue);
#endif
}

@end
