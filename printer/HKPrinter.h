//
//  HKPrinter.h
//  huoku_starprinter_arc
//
//  Created by akwei on 13-7-8.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKTableText.h"

typedef enum
{
    HKCutType_FULL_CUT = 0,
    HKCutType_PARCIAL_CUT = 1,
    HKCutType_FULL_CUT_FEED = 2,
    HKCutType_PARTIAL_CUT_FEED = 3
} HKCutType;

typedef enum{
    HKPrinterTextAlignmentLeft = 0,
    HKPrinterTextAlignmentCenter = 1,
    HKPrinterTextAlignmentRight = 2
}HKPrinterTextAlignment;

@interface HKPrinterConnectionException : NSException
@end

@interface HKPrinterException : NSException
@end

@interface HKPrinter : NSObject
@property(nonatomic,strong,readonly)NSMutableData* commandData;
@property(nonatomic,assign)NSInteger timeoutMillis;//超时时间，单位:毫秒

+(NSArray*)searchPrinters;
//打印机当前是否可以打印
-(BOOL)canPrint;

//添加命令
-(void)addCommand:(NSData*)data;

//添加命令
- (void)addBytesCommand:(const void *)bytes length:(NSUInteger)length;

//添加切纸命令
-(void)addCut:(HKCutType)cutType;

//添加开启钱箱命令
-(void)addOpenCashDrawer;

//添加文本打印命令
-(void)addTextCommand:(NSString*)text
                width:(NSUInteger)width
               height:(NSUInteger)height
           leftMargin:(NSUInteger)leftMargin
                align:(HKPrinterTextAlignment)align;

//进行打印
-(void)execute;

//打印图片
-(void)printImage:(UIImage*)imageToPrint
         maxWidth:(int)maxWidth
       leftMargin:(NSUInteger)leftMargin;

//打印表格式文本
-(void)printTableTextCommand:(HKTableText*)tableText leftMargin:(NSUInteger)leftMargin;

@end
