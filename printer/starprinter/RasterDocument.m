//
//  RasterDocument.m
//  IOS_SDK
//
//  Created by Tzvi on 8/17/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "RasterDocument.h"

@interface RasterDocument (hidden)

- (NSData*)topMarginCommand:(RasTopMargin)source;
- (NSData*)speedCommand:(RasSpeed)source;
- (NSData*)leftMarginCommand:(int)margin;
- (NSData*)rightMarginCommand:(int)margin;
- (NSData*)pageLengthCommand:(int)pLength;
- (NSData*)endPageModeCommandValue:(RasPageEndMode)mode;
- (NSData*)setEndOfPageModeCommand:(RasPageEndMode)mode;
- (NSData*)setEndOfDocModeCommand:(RasPageEndMode)mode;
    
@end

@implementation RasterDocument

- (id)init
{
    self = [super init];
    
    mTopMargin = RasTopMargin_Default;
    mSpeed = RasSpeed_Full;
    mFFmode = RasPageEndMode_Default;
    mEOTMode = RasPageEndMode_Default;
    mPageLength = 0;
    mLeftMargin = 0;
    mRightMargin = 0;
    
    return self;
}

- (id)initWithDefaults:(RasSpeed)speed endOfPageBehaviour:(RasPageEndMode)endOfPageBehaviour_m endOfDocumentBahaviour:(RasPageEndMode)endOfDocumentBehaviour_m topMargin:(RasTopMargin)topMargin_m pageLength:(int)pageLength_m leftMargin:(int)leftMargin_m rightMargin:(int)rightMargin_m
{
    self = [super init];
    
    mSpeed = speed;
    mEOTMode = endOfDocumentBehaviour_m;
    mFFmode = endOfPageBehaviour_m;
    mTopMargin = topMargin_m;
    mPageLength = pageLength_m;
    mLeftMargin = leftMargin_m;
    mRightMargin = rightMargin_m;
    
    
    return self;
}

- (NSData*)topMarginCommand:(RasTopMargin)source
{
    uint8_t cmd[] = {0x1b, '*', 'r', 'T', '0', 0};
    switch (source)
    {
        case RasTopMargin_Default:
            cmd[4] = '0';
            break;
        case RasTopMargin_Small:
            cmd[4] = '1';
            break;
        case RasTopMargin_Standard:
            cmd[4] = '2';
            break;
    }
    NSData *data = [NSData dataWithBytes:cmd length:6];
    return data;
}

- (NSData*)speedCommand:(RasSpeed)source
{
    uint8_t cmd[] = {0x1b, '*', 'r', 'Q', '0', 0};
    switch (source) {
        case RasSpeed_Full:
            cmd[4] = '0';
            break;
        case RasSpeed_Medium:
            cmd[4] = '1';
            break;
        case RasSpeed_Low:
            cmd[4] = '2';
            break;
    }
    NSData *data = [NSData dataWithBytes:cmd length:6];
    return data;
}

- (NSData*)leftMarginCommand:(int)margin
{
    uint8_t cmd[] = {0x1b, '*', 'r', 'm', 'l'};
    NSMutableData *data = [NSMutableData dataWithBytes:cmd length:5];
    NSString *description = [NSString stringWithFormat:@"%i", margin];
    NSData *desData = [description dataUsingEncoding:NSWindowsCP1252StringEncoding];
    [data appendData:desData];
    unsigned char endCommand = 0;
    [data appendBytes:&endCommand length:1];
    return data;
}

- (NSData*)rightMarginCommand:(int)margin
{
    uint8_t cmd[] = {0x1b, '*', 'r', 'm', 'r'};
    NSMutableData *data = [NSMutableData dataWithBytes:cmd length:5];
    
    NSString *description = [NSString stringWithFormat:@"%i", margin];
    NSData *desData = [description dataUsingEncoding:NSWindowsCP1252StringEncoding];
    [data appendData:desData];
    unsigned char endCommand = 0;
    [data appendBytes:&endCommand length:1];
    return data;
}

- (NSData*)pageLengthCommand:(int)pLength
{
    uint8_t cmd[] = {0x1b, '*', 'r', 'P'};
    NSMutableData *data = [NSMutableData dataWithBytes:cmd length:4];
    
    NSString *description = [NSString stringWithFormat:@"%i", pLength];
    NSData *desData = [description dataUsingEncoding:NSWindowsCP1252StringEncoding];
    [data appendData:desData];
    unsigned char endCommand = 0;
    [data appendBytes:&endCommand length:1];
    return data;
}

- (NSData*)endPageModeCommandValue:(RasPageEndMode)mode
{
    NSMutableData *data = [NSMutableData data];
    switch (mode)
    {
        case RasPageEndMode_Default:
            {
                uint8_t command = '0';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_None:
            {
                uint8_t command = '1';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_FeedToCutter:
            {
                uint8_t command = '2';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_FeedToTearbar:
            {
                uint8_t command = '3';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_FullCut:
            {
                uint8_t command = '8';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_FeedAndFullCut:
            {
                uint8_t command = '9';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_PartialCut:
            {
                uint8_t command = '1';
                [data appendBytes:&command length:1];
                command = '2';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_FeedAndPartialCut:
            {
                uint8_t command = '1';
                [data appendBytes:&command length:1];
                command = '3';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_Eject:
            {
                uint8_t command = '3';
                [data appendBytes:&command length:1];
                command = '6';
                [data appendBytes:&command length:1];
            }
            break;
            
        case RasPageEndMode_FeedAndEject:
            {
                uint8_t command = '3';
                [data appendBytes:&command length:1];
                command = '7';
                [data appendBytes:&command length:1];
            }
            break;
    }
    return data;
}

- (NSData*)setEndOfPageModeCommand:(RasPageEndMode)mode
{
    uint8_t startEndPageModeCmd[] = {0x1b, '*', 'r', 'F'};
    NSMutableData *mutableData = [NSMutableData dataWithBytes:startEndPageModeCmd length:4];
    [mutableData appendData:[self endPageModeCommandValue:mode]];
    uint8_t endCmd = 0;
    [mutableData appendBytes:&endCmd length:1];
    return mutableData;
}

- (NSData*)setEndOfDocModeCommand:(RasPageEndMode)mode
{
    uint8_t startEndDocModeCmd[] = {0x1b, '*', 'r', 'E'};
    NSMutableData *mutableData = [NSMutableData dataWithBytes:startEndDocModeCmd length:4];
    [mutableData appendData:[self endPageModeCommandValue:mode]];
    uint8_t endCmd = 0;
    [mutableData appendBytes:&endCmd length:1];
    return mutableData;
}

- (NSData *)BeginDocumentCommandData
{
    NSMutableData *data = [NSMutableData data];
    uint8_t enterRasterMode[] = {0x1b, '*', 'r', 'A'};
    [data appendBytes:enterRasterMode length:4];
    
    NSData *topMarginCommand = [self topMarginCommand:mTopMargin];
    [data appendData:topMarginCommand];
    
    NSData *speedCmd = [self speedCommand:mSpeed];
    [data appendData:speedCmd];
    
    NSData *pageLengthCmd = [self pageLengthCommand:mPageLength];
    [data appendData:pageLengthCmd];
    
    NSData *leftMarginCmd = [self leftMarginCommand:mLeftMargin];
    [data appendData:leftMarginCmd];
    
    NSData *rightMarginCmd = [self rightMarginCommand:mRightMargin];
    [data appendData:rightMarginCmd];
    
    NSData *setEndOfPageModeCmd = [self setEndOfDocModeCommand:mEOTMode];
    [data appendData:setEndOfPageModeCmd];
    
    NSData *setEndOfDocModeCmd = [self setEndOfPageModeCommand:mFFmode];
    [data appendData:setEndOfDocModeCmd];
    
    return data;
}

- (NSData *)EndDocumentCommandData
{
    uint8_t endDocCmd[] = {0x1b, '*', 'r', 'B'};
    NSData *endDocData = [NSData dataWithBytes:endDocCmd length:4];
    
    return endDocData;
}

- (NSData *)PageBreakCommandData
{
    uint8_t pageBreakCmd[] = {0x1b, 0x0c, 0x00};
    NSData *pageBreakData = [NSData dataWithBytes:pageBreakCmd length:sizeof(pageBreakCmd)];
    
    return pageBreakData;
}

@end
