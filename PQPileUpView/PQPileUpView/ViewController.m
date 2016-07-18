//
//  ViewController.m
//  PQPileUpView
//
//  Created by ios on 16/7/18.
//  Copyright © 2016年 PQ. All rights reserved.
//

#import "ViewController.h"
#import "PQPileUpView.h"
@interface ViewController ()
@property (nonatomic,strong) PQPileUpView * pileUpView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * array = @[@"公司",@"公司地方",@"公司东方闪电",@"3地方公司",@"公司是的发送到",@"公司",@"公司",@"公司地方",@"公司东方闪电",@"3地方公司",@"公司是的发送到",@"公司",@"公司",@"公司地方",@"公司东方闪电",@"3地方公司",@"公司是的发送到",@"公司",@"公司",@"公司地方",@"公司东方闪电",@"3地方公司",@"公司是的发送到",@"公司",@"公司",@"公司地方",@"公司东方闪电",@"3地方公司",@"公司是的发送到",@"公司",@"公司",@"公司地方",@"公司东方闪电",@"3地方公司",@"公司是的发送到",@"公司"];
    self.pileUpView = [PQPileUpView pq_createPileUpWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200) maxH:30 titles:array titlesColor:nil click:^(UIButton *button, NSInteger tag) {
        NSLog(@"%@ %d",button.titleLabel.text,(int)tag);
    } clear:^(UIButton *button) {
        NSLog(@"clear");
    }];
    [self.view addSubview:self.pileUpView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
