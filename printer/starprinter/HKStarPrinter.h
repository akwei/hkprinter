//
//  HKStarPrinter.h
//  huoku_starprinter_arc
//
//  Created by akwei on 13-6-26.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StarIO/SMPort.h"
#import "HKPrinter.h"


@interface HKStarPrinter : HKPrinter
@property(nonatomic,copy)NSString* ip;
@property(nonatomic,copy)NSString* portName;

//查看状态
-(StarPrinterStatus_2)checkStatus;
@end
