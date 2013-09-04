//
//  HKRFPrinter.m
//  huoku_starprinter_arc
//
//  Created by akwei on 13-6-28.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKRFPrinter.h"
#import "HKSocket.h"
#import "HKPrinterBitmap.h"

@interface HKRFPrinter ()

@end

@implementation HKRFPrinter

-(id)init{
    self = [super init];
    if (self) {
        self.timeoutMillis = 5000;
    }
    return self;
}

-(void)execute{
    HKSocket* socket = [[HKSocket alloc] initWithHost:self.host port:self.port timeout:self.timeoutMillis];
    @try {
        [socket open];
        //        [socket writeData:self.commandData];
        [socket writeData:self.commandData blockSize:5];
    }
    @finally {
        [socket close];
        socket = nil;
    }
}

-(void)printText:(NSString *)text{
    const char cmd[] = {0x1b,0x40};
    [self addBytesCommand:cmd length:2];
    [self addTextCommand:text];
    [self execute];
}

-(void)printImage:(UIImage *)imageToPrint maxWidth:(int)maxWidth leftMargin:(NSUInteger)leftMargin{
    const char cmd[] = {0x1b,0x40};
    [self addBytesCommand:cmd length:2];
    HKPrinterBitmap* bm = [[HKPrinterBitmap alloc] initWithUIImage:imageToPrint maxWidth:maxWidth];
    NSData* data = [bm getDataForPrint];
    [self addCommand:data];
    [self execute];
}

-(void)addTextCommand:(NSString *)text{
    NSStringEncoding gbk=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [text dataUsingEncoding:gbk];
    [self addCommand:data];
}

@end
