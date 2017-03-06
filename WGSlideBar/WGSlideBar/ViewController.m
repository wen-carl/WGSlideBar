//
//  ViewController.m
//  WGSlideBar
//
//  Created by Admin on 17/3/6.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "ViewController.h"
#import "WGSlideBar.h"

@interface ViewController ()<WGSlideBarDelegate>
{
    UILabel *infoLabel;
    WGSlideBar *bar1;
    WGSlideBar *bar2;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = self.view.frame.size;
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width / 2 - 100, 100, 200, 30)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLabel];
    
    bar1 = [[WGSlideBar alloc] initWithFrame:CGRectMake(size.width * 2 / 3, 200, 15, size.height - 300) andStyle:WGSlideBarStyleVertical itemCount:500 partItem:80];
    bar1.continuous = YES;
    bar1.delegate = self;
    [self.view addSubview:bar1];
    
    bar2 = [[WGSlideBar alloc] initWithFrame:CGRectMake(size.width * 1 / 3, 200, 15, size.height - 300) andStyle:WGSlideBarStyleVertical itemCount:500 partItem:80];
    [self.view addSubview:bar2];
    [bar2 setBarBackgroundColor:[UIColor magentaColor]];
}

#pragma mark WGSlideBarDelegate

- (void)slideBarDidSlide:(WGSlideBar *)bar
{
    NSRange range = [bar getItemIndex];
    infoLabel.text = [NSString stringWithFormat:@"%d - %d",(int)range.location,(int)range.location + (int)range.length];
    [bar2 setBarPositionWithItemIndex:range.location andAnimation:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
