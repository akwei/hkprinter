//
//  HKPOSTable.m
//  hkprinter
//
//  Created by akwei on 13-8-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKPOSTable.h"

#pragma mark - HKPOSColumn

@interface HKPOSColumn ()
/*
 最终输出文本
 */
@property(nonatomic,strong)NSMutableArray* textList;
@end

@implementation HKPOSColumn

-(id)init{
    self = [super init];
    if (self) {
        self.textList = [[NSMutableArray alloc] init];
        self.alignment = HKPOSAlignmentLeft;
        self.maxWordCount = 0;
    }
    return self;
}

-(void)build{
    int chCount=0;
    int max = self.maxWordCount * 2;
    NSMutableString* buf = [[NSMutableString alloc] init];
    for (int i=0; i<[self.text length]; i++) {
        if (chCount >= max) {
            NSString* s = [buf copy];
            [self.textList addObject:s];
            [buf deleteCharactersInRange:NSMakeRange(0, [buf length])];
            chCount = 0;
            s = nil;
        }
        if (chCount < max){
            unichar ch= [self.text characterAtIndex:i];
            if (isascii(ch)) {
                chCount = chCount + 1;
                [buf appendFormat:@"%c",ch];
            }
            else{
                chCount = chCount + 2;
                [buf appendFormat:@"%C",ch];
            }
        }
        if (i == [self.text length] - 1) {
            NSString* s = [buf copy];
            NSUInteger spaceLen = max - chCount;
            NSMutableString* buff = [[NSMutableString alloc] init];
            if (self.alignment == HKPOSAlignmentLeft) {
                [buff appendString:s];
            }
            for (int i=0; i<spaceLen; i++) {
                [buff appendString:@" "];
            }
            if (self.alignment == HKPOSAlignmentRight) {
                [buff appendString:s];
            }
            [self.textList addObject:buff];
            [buf deleteCharactersInRange:NSMakeRange(0, [buf length])];
            chCount = 0;
            s = nil;
            buff = nil;
        }
    }
}

-(NSString *)getEmptyString{
    NSMutableString* buf = [[NSMutableString alloc] init];
    for (int i=0; i<self.maxWordCount; i++) {
        [buf appendString:@"  "];
    }
    return buf;
}

-(NSString*)getTextWithIndex:(NSUInteger)index{
    if ((index < [self.textList count]) && ([self.textList count] > 0)) {
        return [self.textList objectAtIndex:index];
    }
    return [self getEmptyString];
}

@end

#pragma mark - HKPOSRow

@interface HKPOSRow ()
@property(nonatomic,strong)NSMutableArray* columnList;
@property(nonatomic,assign)NSUInteger maxCount;
@end


@implementation HKPOSRow

-(id)init{
    self = [super init];
    if (self) {
        self.columnList = [[NSMutableArray alloc] init];
        self.maxCount = 0;
    }
    return self;
}

-(void)addColumn:(HKPOSColumn *)col{
    [col build];
    [self.columnList addObject:col];
    if ([col.textList count] > self.maxCount) {
        self.maxCount = [col.textList count];
    }
}

-(NSString *)getText{
    NSMutableString* buf = [[NSMutableString alloc] init];
    for (int i=0; i<self.maxCount; i++) {
        for (HKPOSColumn* col in self.columnList) {
            [buf appendString:[col getTextWithIndex:i]];
        }
        [buf appendString:@"\n"];
    }
    return buf;
}

@end

#pragma mark - HKPOSTable

@interface HKPOSTable ()
@property(nonatomic,strong)NSMutableArray* rowList;
@end

@implementation HKPOSTable

-(id)init{
    self = [super init];
    if (self) {
        self.rowList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addRow:(HKPOSRow *)row{
    [self.rowList addObject:row];
}

-(NSString *)getText{
    NSMutableString* buf = [[NSMutableString alloc] init];
    for (HKPOSRow* row in self.rowList) {
        [buf appendString:[row getText]];
    }
    return buf;
}

@end


