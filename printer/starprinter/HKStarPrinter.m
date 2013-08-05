//
//  HKStarPrinter.m
//  huoku_starprinter_arc
//
//  Created by akwei on 13-6-26.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKStarPrinter.h"
#import "RasterDocument.h"
#import "StarBitmap.h"
#import <sys/time.h>


@interface HKStarPrinter ()
@property(nonatomic,strong)SMPort *starPort;


-(void)open;
-(void)close;
-(void)sendCommand:(NSData *)commandsToPrint;
@end

@implementation HKStarPrinter

-(id)init{
    self = [super init];
    if (self) {
        self.timeoutMillis = 10000;
    }
    return self;
}

+(NSArray *)searchPrinters{
    return [SMPort searchPrinter];
}

-(void)open{
    if (!self.portName && !self.ip) {
        NSLog(@"star printer must set portName or ip");
    }
    if (!self.portName) {
        self.portName = [NSString stringWithFormat:@"TCP:%@",self.ip];
    }
    else{
        self.ip = [self.portName substringFromIndex:4];
    }
    self.starPort = nil;
    NSException* ex ;
    @try
    {
        self.starPort = [SMPort getPort:self.portName :@"" :self.timeoutMillis];
        if (self.starPort == nil){
            NSString* reason = [NSString stringWithFormat:@"fail to open in ip:%@",self.ip];
            ex = [HKPrinterConnectionException exceptionWithName:@"Error" reason:reason userInfo:nil];
            @throw ex;
        }
    }
    @finally{
        
    }
}

-(void)close{
    [SMPort releasePort:self.starPort];
    usleep(1000 * 1000);
    self.starPort = nil;
}

-(void)sendCommand:(NSData *)commandsToPrint{
    int commandSize = [commandsToPrint length];
    unsigned char *dataToSentToPrinter = (unsigned char *)malloc(commandSize);
    [commandsToPrint getBytes:dataToSentToPrinter];
    NSException* ex;
    @try{
        [self open];
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 30;
        int totalAmountWritten = 0;
        while (totalAmountWritten < commandSize){
            int remaining = commandSize - totalAmountWritten;
            int amountWritten = [self.starPort writePort:dataToSentToPrinter :totalAmountWritten :remaining];
            totalAmountWritten += amountWritten;
            struct timeval now;
            gettimeofday(&now, NULL);
            if (now.tv_sec > endTime.tv_sec){
                break;
            }
        }
        if (totalAmountWritten < commandSize){
            ex = [HKPrinterException exceptionWithName:@"Printer Error" reason:@"Write port timed out" userInfo:nil];
        }
        if (ex) {
            @throw ex;
        }
    }
    @finally{
        free(dataToSentToPrinter);
        [self close];
    }
}

-(BOOL)canPrint{
    StarPrinterStatus_2 status = [self checkStatus];
    if (status.offline == SM_TRUE) {
        return NO;
    }
    return YES;
}

-(StarPrinterStatus_2)checkStatus{
    NSException* ex;
    @try{
        [self open];
        usleep(1000 * 1000);
        StarPrinterStatus_2 status;
        [self.starPort getParsedStatus:&status :2];
        return status;
    }
    @catch (PortException *exception){
        ex = [HKPrinterException exceptionWithName:exception.name reason:exception.reason userInfo:nil];
        @throw ex;
    }
    @finally{
        [self close];
    }
}

-(void)addCut:(HKCutType)cutType{
    unsigned char autocutCommand[] = {0x1b, 0x64, 0x00};
    switch (cutType)
    {
        case HKCutType_FULL_CUT:
            autocutCommand[2] = 48;
            break;
        case HKCutType_PARCIAL_CUT:
            autocutCommand[2] = 49;
            break;
        case HKCutType_FULL_CUT_FEED:
            autocutCommand[2] = 50;
            break;
        case HKCutType_PARTIAL_CUT_FEED:
            autocutCommand[2] = 51;
            break;
    }
    int commandSize = 3;
    [self addBytesCommand:autocutCommand length:commandSize];
}

-(void)printImage:(UIImage *)imageToPrint maxWidth:(int)maxWidth leftMargin:(NSUInteger)leftMargin{
    RasterDocument *rasterDoc = [[RasterDocument alloc] initWithDefaults:RasSpeed_Medium endOfPageBehaviour:RasPageEndMode_FeedAndFullCut endOfDocumentBahaviour:RasPageEndMode_FeedAndFullCut topMargin:RasTopMargin_Standard pageLength:0 leftMargin:leftMargin + 3 rightMargin:0];
    StarBitmap *starbitmap = [[StarBitmap alloc] initWithUIImage:imageToPrint :maxWidth :false];
    NSMutableData *commandsToPrint = [[NSMutableData alloc] init];
    NSData *shortcommand = [rasterDoc BeginDocumentCommandData];
    [commandsToPrint appendData:shortcommand];
    shortcommand = [starbitmap getImageDataForPrinting:YES];
    [commandsToPrint appendData:shortcommand];
    shortcommand = [rasterDoc EndDocumentCommandData];
    [commandsToPrint appendData:shortcommand];
    [self addCommand:commandsToPrint];
    @try {
        [self open];
        [self sendCommand:self.commandData];
    }
    @finally {
        rasterDoc = nil;
        starbitmap = nil;
        commandsToPrint = nil;
        [self close];
    }
}

-(void)printTableTextCommand:(HKTableText *)tableText leftMargin:(NSUInteger)leftMargin{
    UIImage* image = [tableText drawToImage];
    [self printImage:image maxWidth:tableText.width leftMargin:leftMargin];
}

-(void)addOpenCashDrawer{
    unsigned char cmd[] = {27,7,10,50,7};
    int length = 5;
    [self addBytesCommand:cmd length:length];
}

-(void)addTextCommand:(NSString *)text
                width:(NSUInteger)width
               height:(NSUInteger)height
           leftMargin:(NSUInteger)leftMargin
                align:(HKPrinterTextAlignment)align{
    unsigned char characterExpansion[] = {0x1b, 0x69, 0x00, 0x00};
    characterExpansion[2] = height + '0';
    characterExpansion[3] = width + '0';
    [self addBytesCommand:characterExpansion length:4];
    
    unsigned char leftMarginCommand[] = {0x1b, 0x6c, 0x00};
    leftMarginCommand[2] = leftMargin;
    [self addBytesCommand:leftMarginCommand length:3];
    
    unsigned char alignmentCommand[] = {0x1b, 0x1d, 0x61, 0x00};
    switch (align){
        case HKPrinterTextAlignmentLeft:
            alignmentCommand[3] = 48;
            break;
        case HKPrinterTextAlignmentCenter:
            alignmentCommand[3] = 49;
            break;
        case HKPrinterTextAlignmentRight:
            alignmentCommand[3] = 50;
            break;
    }
    [self addBytesCommand:alignmentCommand length:4];
    
    NSStringEncoding gbk=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *textNSData = [text dataUsingEncoding:gbk];
    unsigned char *textData = (unsigned char *)malloc([textNSData length]);
    [textNSData getBytes:textData];
    NSInteger textDataSize=[textNSData length];
    [self addBytesCommand:textData length:textDataSize];
    free(textData);
}

-(void)execute{
    [self sendCommand:self.commandData];
}

@end
