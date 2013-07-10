//
//  Bitmap.h
//  IOPhoneTest
//
//  Created by sdtpig on 8/25/09.
//  Copyright 2009 starmicronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGBA 4
#define RGBA_8_BIT 8

typedef struct ARGBPixel {
	unsigned char alpha;
	unsigned char red;
	unsigned char green;
	unsigned char blue;
} ARGBPixel;

@interface StarBitmap : NSObject {
	UIImage *m_image;
	NSData *imageData;
	bool ditheringSupported;
}

- (id)initWithUIImage:(UIImage *)image :(int)maxWidth :(bool)dithering;
- (NSData *)getImageDataForPrinting:(BOOL)compressionEnable;
- (NSData *)getImageMiniDataForPrinting:(BOOL)compressionEnable pageModeEnable:(BOOL)pageModeEnable;
- (NSData *)getImageImpactPrinterForPrinting;

@end
