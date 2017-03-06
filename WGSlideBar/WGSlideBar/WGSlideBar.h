//
//  WGSlideBar.h
//  test
//
//  Created by Admin on 17/2/22.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WGSlideBarStyleVertical,
    WGSlideBarStyleHorizontal,
} WGSlideBarStyle;

@class WGSlideBar;

@protocol WGSlideBarDelegate <NSObject>

@optional
- (void)slideBarDidBeginSlide:(WGSlideBar *)bar;
- (void)slideBarDidSlide:(WGSlideBar *)bar;
- (void)slideBarDidEndSlide:(WGSlideBar *)bar;

@end

@interface WGSlideBar : UIView

@property (nonatomic, assign, readonly) WGSlideBarStyle style;
@property (nonatomic, weak) id <WGSlideBarDelegate> delegate;
@property (nonatomic, assign) BOOL continuous;

- (instancetype)initWithFrame:(CGRect)frame andStyle:(WGSlideBarStyle)aStyle itemCount:(NSInteger)items partItem:(NSInteger)part;
- (void)setBarPositionWithItemIndex:(NSInteger)index andAnimation:(BOOL)animation;
- (NSRange)getItemIndex;
- (void)setBarBackgroundColor:(UIColor *)color;
- (void)setShownViewBackGroundColor:(UIColor *)color;


@end
