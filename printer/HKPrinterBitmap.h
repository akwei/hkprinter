//
//  HKPrinterBitmap.h
//  huoku_starprinter_arc
//
//  Created by akwei on 13-7-8.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGBA 4
#define RGBA_8_BIT 8

typedef struct ARGBPixel
{
	unsigned char alpha;
	unsigned char red;
	unsigned char green;
	unsigned char blue;
} ARGBPixel;

@interface HKBitmapImage : NSObject
@property(nonatomic,strong)NSData* bitmap;
@property(nonatomic,assign)NSInteger width;
@property(nonatomic,assign)NSInteger height;
@end

@interface HKPrinterBitmap : NSObject
{
    UIImage *m_image;
	NSData *imageData;
}

- (id)initWithUIImage:(UIImage *)image maxWidth:(int)maxWidth;
-(NSData*)getDataForPrint;

@end
