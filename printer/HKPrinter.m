//
//  HKPrinter.m
//  huoku_starprinter_arc
//
//  Created by akwei on 13-7-8.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKPrinter.h"

@implementation HKPrinterConnectionException
@end

@implementation HKPrinterException
@end

@implementation HKPrinter

-(id)init{
    self = [super init];
    if (self) {
        _commandData = [[NSMutableData alloc] init];
        self.timeoutMillis = 10000;
    }
    return self;
}

+(NSArray *)searchPrinters{
    return nil;
}

-(BOOL)canPrint{
    return NO;
}

-(void)addCommand:(NSData *)data{
    [self.commandData appendData:data];
}

-(void)addBytesCommand:(const void *)bytes length:(NSUInteger)length{
    [self.commandData appendBytes:bytes length:length];
}

-(void)addCut:(HKCutType)cutType{
    NSLog(@"HKPrinter : child can impl");
}

-(void)addOpenCashDrawer{
    NSLog(@"HKPrinter : child can impl");
}

-(void)addTextCommand:(NSString *)text
                width:(NSUInteger)width
               height:(NSUInteger)height
           leftMargin:(NSUInteger)leftMargin
                align:(HKPrinterTextAlignment)align{
    NSLog(@"HKPrinter : child can impl");
}

-(void)execute{
    NSLog(@"HKPrinter : child can impl");
}

-(void)printImage:(UIImage *)imageToPrint maxWidth:(int)maxWidth leftMargin:(NSUInteger)leftMargin{
    NSLog(@"HKPrinter : child can impl");
}

-(void)printTableTextCommand:(HKTableText *)tableText leftMargin:(NSUInteger)leftMargin{
    NSLog(@"HKPrinter : child can impl");
}

@end
