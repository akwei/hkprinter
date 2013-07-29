//
//  HKRFPrinter.h
//  huoku_starprinter_arc
//  使用GCDAsyncSocket iOS 6以下需要 ExternalAccessory.framework CFNetwork.frame Security.framework
//
//  Created by akwei on 13-6-28.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKPrinter.h"

@interface HKRFPrinter : HKPrinter
@property(nonatomic,copy)NSString* host;
@property(nonatomic,assign)NSUInteger port;

-(void)printText:(NSString*)text;

@end
