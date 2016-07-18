//
//  PQCalculatePosition.m
//  PQPileUpView
//
//  Created by PQ on 16/7/17.
//  Copyright © 2016年 PQ. All rights reserved.
//

#import "PQCalculatePosition.h"

@implementation PQCalculatePosition

+ (CGRect)pq_calculatePositionWithMaxSize:(CGSize)maxSize lastFrame:(CGRect)lastFrame selfSize:(CGSize)selfSize{
    CGRect newFrame = CGRectMake(CGRectGetMaxX(lastFrame) + 5, lastFrame.origin.y, selfSize.width, selfSize.height);
    
    if ((newFrame.size.width + newFrame.origin.x) > maxSize.width) {
        newFrame.origin.y += selfSize.height + 5;
        newFrame.origin.x = 5;
    }
    
    return newFrame;
}

@end
