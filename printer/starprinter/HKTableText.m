//
//  HKTableText.m
//  huoku_starprinter_arc
//
//  Created by akwei on 12-10-23.
//  Copyright (c) 2012年 huoku. All rights reserved.
//

#import "HKTableText.h"

@implementation HKTableColumn

-(id)init{
    return nil;
}

-(id)initWithWidth:(CGFloat)_width_ height:(CGFloat)_height_ text:(NSString *)_text_ alignment:(NSTextAlignment)_alignment_ font:(UIFont *)_font_ image:(UIImage *)_image_{
    self = [super init];
    if (self) {
        self.width = _width_;
        self.text = _text_;
        self.alignment = _alignment_;
        self.font = _font_;
        self.image = _image_;
        if (self.text) {
            CGSize size = CGSizeMake(self.width, CGFLOAT_MAX);
            CGSize realSize = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            self.rect = CGRectMake(0, 0, self.width, realSize.height);
        }
        else{
            self.rect = CGRectMake(0, 0, self.width, _height_);
        }
        return self;
    }
    return nil;
}

-(id)initWithWidth:(CGFloat)_width_ height:(CGFloat)_height_ image:(UIImage *)_image_{
    return [self initWithWidth:_width_ height:_height_ text:nil alignment:NSTextAlignmentLeft font:nil image:_image_];
}

-(id)initWithWidth:(CGFloat)_width_ text:(NSString *)_text_ alignment:(NSTextAlignment)_alignment_ font:(UIFont *)_font_{
    return [self initWithWidth:_width_ height:0 text:_text_ alignment:_alignment_ font:_font_ image:nil];
}

-(void)draw{
    if (self.image) {
        [self.image drawInRect:self.rect];
    }
    [self.text drawInRect:self.rect withFont:self.font lineBreakMode:NSLineBreakByWordWrapping alignment:self.alignment];
}

-(CGPoint)getLeftBottomPoint{
    return CGPointMake(self.rect.origin.x, self.rect.origin.y + self.rect.size.height);
}

-(CGPoint)getRightBottomPoint{
    return CGPointMake(self.rect.origin.x + self.rect.size.width, self.rect.origin.y + self.rect.size.height);
}

-(CGPoint)getRightTopPoint{
    return CGPointMake(self.rect.origin.x + self.rect.size.width, self.rect.origin.y);
}
@end

@implementation HKTableRow

-(id)init{
    self = [super init];
    if (self) {
        self.height = 0;
        self.columns = [[NSMutableArray alloc] init];
        self.beginPoint = CGPointZero;
        self.topMargin = 0;
        self.bottomMargin = 0;
        return self;
    }
    return nil;
}

-(void)addColumn:(HKTableColumn *)column{
    if (column.rect.size.height > self.height) {
        self.height = column.rect.size.height;
    }
    HKTableColumn* lastColumn = [self.columns lastObject];
    if (lastColumn) {
        CGRect rect = column.rect;
        CGPoint lastColumn_rightTopPoint = [lastColumn getRightTopPoint];
        rect.origin.x = lastColumn_rightTopPoint.x;
        rect.origin.y = lastColumn_rightTopPoint.y;
        column.rect = rect;
    }
    else{
        CGRect rect = column.rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        column.rect = rect;
    }
    [self.columns addObject:column];
}

-(void)buildColumnsPoint{
    for (HKTableColumn* col in self.columns) {
        CGRect colRect = col.rect;
        colRect.origin.y = self.beginPoint.y;
        col.rect = colRect;
    }
}

-(void)buildBeginPointWithLastRow:(HKTableRow*)row{
    CGFloat lastBottomMargin=0;
    CGFloat lastHeight = 0;
    CGPoint p = CGPointZero;
    if (row) {
        lastBottomMargin = row.bottomMargin;
        lastHeight = row.height;
        p = row.beginPoint;
    }
    self.beginPoint = CGPointMake(p.x, p.y + lastHeight + lastBottomMargin + self.topMargin);
    [self buildColumnsPoint];
}

@end

@implementation HKTableText{
    CGFloat height;
}

-(id)init{
    self = [super init];
    if (self) {
        self.rows = [[NSMutableArray alloc] init];
        height = 0;
        return self;
    }
    return nil;
}

-(void)addRow:(HKTableRow *)row{
    HKTableRow* lastRow = [self.rows lastObject];
    [row buildBeginPointWithLastRow:lastRow];
    height = height + row.height + row.topMargin + row.bottomMargin;
    [self.rows addObject:row];
}

-(UIImage *)drawToImage{
    CGSize size = CGSizeMake(self.width, height);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
		} else {
			UIGraphicsBeginImageContext(size);
		}
	} else {
		UIGraphicsBeginImageContext(size);
	}
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor whiteColor];
    [color set];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(ctr, rect);
    color = [UIColor blackColor];
    [color set];
    for (HKTableRow* row in self.rows) {
        for (HKTableColumn* col in row.columns) {
            [col draw];
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
