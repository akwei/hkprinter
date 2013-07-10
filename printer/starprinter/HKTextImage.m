//
//  HKTextImage.m
//  huoku_starprinter_arc
//
//  Created by akwei on 12-10-23.
//  Copyright (c) 2012年 huoku. All rights reserved.
//

#import "HKTextImage.h"

@implementation HKTextImage

-(UIImage*)testWithWidth:(CGFloat)width{
    UIFont* font = [UIFont systemFontOfSize:34];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSString* text = @"测试文字输出到图片，一段很长的文字输出，有e问也有中文，,fsgasdlfpoasdhipgf阿斯蒂格萨的韩国还是哦德国 ksdgoisehgo哦上低功耗oisdgaodpsdgioapdsgioaoidhgoeho山东很高哦山东哦个哦三等功";
    CGSize realSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			UIGraphicsBeginImageContextWithOptions(realSize, NO, 1.0);
		} else {
			UIGraphicsBeginImageContext(realSize);
		}
	} else {
		UIGraphicsBeginImageContext(realSize);
	}
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor whiteColor];
    [color set];
    CGRect rect = CGRectMake(0, 0, realSize.width, realSize.height);
    CGContextFillRect(ctr, rect);
    color = [UIColor blackColor];
    [color set];
    [text drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap];
    
    UIImage *imageToPrint = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageToPrint;
}

@end
