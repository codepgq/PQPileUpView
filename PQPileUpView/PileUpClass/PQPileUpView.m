//
//  PQPileUpView.m
//  PQPileUpView
//
//  Created by PQ on 16/7/17.
//  Copyright © 2016年 PQ. All rights reserved.
//

#import "PQPileUpView.h"
#import "PQCalculatePosition.h"
#define RANDOM_COLOR [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1]

@interface PQPileUpView ()

@property (nonatomic,strong) NSMutableArray * titles;
@property (nonatomic,strong) NSArray * colors;
@property (nonatomic,assign) CGFloat maxH;
@property (nonatomic,assign) CGSize maxSize;
@property (nonatomic,assign) CGFloat scrollMaxH;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIButton * clearBtn;
@property (nonatomic,copy)   PQClickBlock clickBlock;
@property (nonatomic,copy)   PQClearBlock clearBlock;
@property (nonatomic,assign) BOOL isSignleClick;
@end

@implementation PQPileUpView
#pragma mark - lazy
- (UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.25, self.scrollMaxH, self.bounds.size.width*0.5, 25)];
        [_clearBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clearBtn.layer.cornerRadius = 5;
        [_clearBtn addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

#pragma  mark - set

- (void)setMaxH:(CGFloat)maxH{
    if (maxH) {
        _maxH = maxH;
    }
}

// event
- (void)clearClick:(UIButton *)button{
    self.clearBlock(button);
}

- (void)selectClick:(UIButton *)button{
    self.isSignleClick = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isSignleClick == YES) {
            self.clickBlock(button,button.tag);
        }
    });
}

//tap event
- (void)delButton:(UITapGestureRecognizer *)tap{
    self.isSignleClick = NO;
    NSInteger index = tap.view.tag;
//
    [tap.view removeFromSuperview];
    [self reloadPosition:index-1];
    [self.titles removeObjectAtIndex:index];
}
// reload position
- (void)reloadPosition:(NSInteger)tag{
    
    NSInteger index;
    CGRect nowFrame ,lastFrame;
    
    if (tag<=0) {
        index = 0;
        lastFrame = CGRectMake(0, 0, 0.1, 0.1);
    }else{
        lastFrame = [self.scrollView.subviews[tag-1] frame];
        index = tag;
    }
    self.scrollMaxH = 0;
    
    for (NSInteger i = index; i < self.scrollView.subviews.count -1; i++) {
        //创建按钮
        UIButton * button = (UIButton *)self.scrollView.subviews[i] ;
        //计算frame
        nowFrame =  [PQCalculatePosition pq_calculatePositionWithMaxSize:self.maxSize lastFrame:lastFrame selfSize:button.frame.size];
        button.frame = nowFrame;
        lastFrame = nowFrame;
        
        //得到scroll可滑动的最高区域 30为 清除按钮的高度
        self.scrollMaxH = CGRectGetMaxY(nowFrame);
        //更新tag
        button.tag = i;
    }
    
    self.scrollView.contentSize = CGSizeMake(0, self.scrollMaxH+30);
    
    //更新清除按钮
    CGRect clearBtnFrame = self.clearBtn.frame;
    clearBtnFrame.origin.y = self.scrollMaxH;
    self.clearBtn.frame = clearBtnFrame;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxH = 30;
        self.scrollMaxH = 0;
    }
    return self;
}

- (void)setUp{
    CGRect nowFrame,lastFrame = CGRectMake(0, 0, 0.1, 0.1);
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        //判断颜色
        UIColor * color = RANDOM_COLOR;
        if (self.colors.count) {
            color = self.colors[((i)%self.colors.count)];
        }
        
        //创建按钮
        UIButton * button = [self getButtonWithText:self.titles[i] backgroundColor:color tag:i];
        //计算frame
        nowFrame =  [PQCalculatePosition pq_calculatePositionWithMaxSize:self.maxSize lastFrame:lastFrame selfSize:[self reallySizeWithButton:button]];
        button.frame = nowFrame;
        lastFrame = nowFrame;
        //添加到scrollView中
        [self.scrollView addSubview:button];
        //得到scroll可滑动的最高区域 30为 清除按钮的高度
        self.scrollMaxH = CGRectGetMaxY(nowFrame);
        
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //add double click removeforsubview
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delButton:)];
        tap.numberOfTapsRequired = 2;
        [button addGestureRecognizer:tap];
    }
    
//    判断是不是超出
    self.scrollView.contentSize = CGSizeMake(0, self.scrollMaxH+30);
    
    //添加清除按钮
    [self.scrollView addSubview:self.clearBtn];
    
    [self addSubview:self.scrollView];
}


- (UIButton *)getButtonWithText:(NSString *)text backgroundColor:(UIColor*)color tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.backgroundColor = color;
    button.layer.cornerRadius = 5;
    button.tag = tag;
    return button;
}
/*
 
 NSStringDrawingUsesLineFragmentOrigin = 1 << 0, // The specified origin is the line fragment origin, not the base line origin
 NSStringDrawingUsesFontLeading = 1 << 1, // Uses the font leading for calculating line heights
 NSStringDrawingUsesDeviceMetrics = 1 << 3, // Uses image glyph bounds instead of typographic bounds
 NSStringDrawingTruncatesLastVisibleLine NS_ENUM_AVAILABLE(10_5, 6_0) = 1 << 5, // Truncates and adds the ellipsis character to the last visible line if the text doesn't fit into the bounds specified. Ignored if NSStringDrawingUsesLineFragmentOrigin is not also set.
 */

- (CGSize)reallySizeWithButton:(UIButton *)button{
    CGSize backSize;
    NSDictionary * fontDic = @{@"NSFontAttrbuteFrame":button.titleLabel.font};
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, self.maxH);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        backSize = [button.titleLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:fontDic context:nil].size;
    }
    else{
        backSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font constrainedToSize:maxSize];
    }
    
    return CGSizeMake(backSize.width*1.3, self.maxH);
    
}

+ (instancetype)pq_createPileUpWithFrame:(CGRect)frame maxH:(CGFloat)maxH titles:(NSArray*)titles titlesColor:(NSArray *)colors click:(PQClickBlock)clickBlock clear:(PQClearBlock)clearBlock{
    PQPileUpView * pileUpView = [[PQPileUpView alloc]initWithFrame:frame];
    pileUpView.maxH = maxH;
    pileUpView.clickBlock = clickBlock;
    pileUpView.clearBlock = clearBlock;
    pileUpView.colors = colors;
    pileUpView.titles = [NSMutableArray arrayWithArray:titles];
    pileUpView.maxSize = CGSizeMake(pileUpView.frame.size.width, pileUpView.maxH);
    [pileUpView setUp];
    return pileUpView;
}

@end
