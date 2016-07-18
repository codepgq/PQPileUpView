//
//  PQPileUpView.h
//  PQPileUpView
//
//  Created by PQ on 16/7/17.
//  Copyright © 2016年 PQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PQClickBlock)(UIButton * button,NSInteger tag);
typedef void(^PQClearBlock)(UIButton * button);

@interface PQPileUpView : UIView



+ (instancetype)pq_createPileUpWithFrame:(CGRect)frame maxH:(CGFloat)maxH titles:(NSArray*)titles titlesColor:(NSArray *)colors click:(PQClickBlock)clickBlock clear:(PQClearBlock)clearBlock;

@end
