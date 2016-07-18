//
//  PQCalculatePosition.h
//  PQPileUpView
//
//  Created by PQ on 16/7/17.
//  Copyright © 2016年 PQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PQCalculatePosition : UIView

+ (CGRect)pq_calculatePositionWithMaxSize:(CGSize)maxSize lastFrame:(CGRect)lastFrame selfSize:(CGSize)selfSize;

@end
