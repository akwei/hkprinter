//
//  HKSocket.h
//  huoku_starprinter_arc
//  使用CGDAsyncSocket，改变为同步方式工作
//  Created by akwei on 13-6-30.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#define HK_SOCKET_DEBUG 1

@interface HKSocketConnectionException : NSException
@end

@interface HKSocketException : NSException
@end

@interface HKSocket : NSObject<GCDAsyncSocketDelegate>
@property(nonatomic,copy)NSString* host;
@property(nonatomic,assign)NSUInteger port;
@property(nonatomic,assign)NSTimeInterval timeout;//超时时间，单位:秒

-(id)initWithHost:(NSString*)host port:(NSUInteger)port timeout:(NSTimeInterval)timeout;
-(void)open;
-(void)writeData:(NSData*)data;
-(NSData*)readData;
-(void)close;
@end
