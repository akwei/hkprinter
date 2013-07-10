//
//  HKTableText.h
//  huoku_starprinter_arc
//
//  Created by akwei on 12-10-23.
//  Copyright (c) 2012年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKTableColumn : NSObject
@property(nonatomic,assign)CGFloat width;//param
@property(nonatomic,copy)NSString* text;//param
@property(nonatomic,strong)UIImage* image;//param not must
@property(nonatomic,assign)NSTextAlignment alignment;//param
@property(nonatomic,strong)UIFont* font;//param
//单元格真正的大小
@property(nonatomic,assign)CGRect rect;

-(id)initWithWidth:(CGFloat)_width_
              text:(NSString*)_text_
         alignment:(NSTextAlignment)_alignment_
              font:(UIFont*)_font_;

-(id)initWithWidth:(CGFloat)_width_
            height:(CGFloat)_height_
              image:(UIImage*)_image_;

@end

@interface HKTableRow : NSObject
@property(nonatomic,assign)CGFloat topMargin;
@property(nonatomic,assign)CGFloat bottomMargin;
@property(nonatomic,assign)CGPoint beginPoint;
//每行的最大高度
@property(nonatomic,assign)CGFloat height;
//HKTableColumn in
@property(nonatomic,strong)NSMutableArray* columns;

-(void)addColumn:(HKTableColumn*)column;
@end


@interface HKTableText : NSObject
@property(nonatomic,assign)CGFloat width;
//存储每一行的数据 HKTableRow in
@property(nonatomic,strong)NSMutableArray* rows;

-(void)addRow:(HKTableRow*)row;

/*
 row添加完成之后调用此消息可获得输出的图片
 */
-(UIImage*)drawToImage;
@end
