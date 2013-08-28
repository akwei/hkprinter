//
//  HKPOSTable.h
//  hkprinter
//  专为消费小票制作的表格文本打印，能实现行列对齐的功能
//  Created by akwei on 13-8-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <Foundation/Foundation.h>

enum HKPOSAlignment {
    HKPOSAlignmentLeft = 0,
    HKPOSAlignmentRight = 1
    };

/*
 列数据
 */
@interface HKPOSColumn : NSObject

/*
 最大字符数量
 */
@property(nonatomic,assign)NSInteger maxWordCount;
/*
 文字对齐方式
 */
@property(nonatomic,assign)enum HKPOSAlignment alignment;
/*
 原始文本
 */
@property(nonatomic,copy)NSString* text;

@end

/*
 行数据
 */
@interface HKPOSRow : NSObject

/*
 添加列
 */
-(void)addColumn:(HKPOSColumn*)col;

@end

/*
 文本表格
 */
@interface HKPOSTable : NSObject

-(void)addRow:(HKPOSRow*)row;

/*
 文本数据
 */
-(NSString*)getText;
@end
