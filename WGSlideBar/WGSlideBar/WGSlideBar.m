//
//  WGSlideBar.m
//  test
//
//  Created by Admin on 17/2/22.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGSlideBar.h"

@interface WGSlideBar ()
{
    CGFloat width;
    UIView *_bar;
    UIView *_shown;
    NSInteger _items;
    NSInteger _part;
}

@end

@implementation WGSlideBar

- (instancetype)initWithFrame:(CGRect)frame andStyle:(WGSlideBarStyle)aStyle itemCount:(NSInteger)items partItem:(NSInteger)part
{
    if ((aStyle == WGSlideBarStyleVertical && (frame.size.height <= frame.size.width)) || (aStyle == WGSlideBarStyleHorizontal && (frame.size.height >= frame.size.width)) || (items < part)) {
        return nil;
    }
        
    self = [super initWithFrame:frame];
    if (self) {
        _style = aStyle;
        _items = items;
        _part = part;
        _continuous = NO;
        
        CGRect barRect = CGRectZero;
        if (aStyle == WGSlideBarStyleVertical) {
            float length = ((float)part / items) * frame.size.height;
            if (length < frame.size.width)
                length = frame.size.width;

            barRect.size.width = frame.size.width;
            barRect.size.height = length;
            width = frame.size.width;
        } else {
            float length = ((float)part / items) * frame.size.width;
            if (length < frame.size.height)
                length = frame.size.height;
            
            barRect.size.width = frame.size.height;
            barRect.size.height = length;
            width = frame.size.height;
        }
        
        _shown = [[UIView alloc] initWithFrame:barRect];
        _shown.backgroundColor = [UIColor lightGrayColor];
        [self maskToBounds:_shown];
        [self addSubview:_shown];
        
        _bar = [[UIView alloc] initWithFrame:barRect];
        _bar.backgroundColor = [UIColor greenColor];
        [self maskToBounds:_bar];
        [self addSubview:_bar];
        [self maskToBounds:self];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [_bar addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)maskToBounds:(UIView *)view
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = width / 2;
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setBarBackgroundColor:(UIColor *)color
{
    if (color) {
        _bar.backgroundColor = color;
    }
}

- (void)setShownViewBackGroundColor:(UIColor *)color
{
    if (color) {
        _shown.backgroundColor = color;
    }
}

- (NSRange)getItemIndex
{
    CGFloat offset = 0;
    CGFloat range = 0;
    if (_style == WGSlideBarStyleVertical) {
        offset = _bar.frame.origin.y;
        range = self.frame.size.height - _bar.frame.size.height;
    } else {
        offset = _bar.frame.origin.x;
        range = self.frame.size.width - _bar.frame.size.width;
    }
    
    CGFloat index = offset / range * (_items - _part);
    
    return NSMakeRange(index, _part);
}

- (void)setBarPositionWithItemIndex:(NSInteger)index andAnimation:(BOOL)animation
{
    if (index > _items)
        index = _items;
    
    CGFloat range = _style == WGSlideBarStyleVertical ? (self.frame.size.height - _bar.frame.size.height) : (self.frame.size.width - _bar.frame.size.width);
    CGFloat pos = ((float)index / (_items - _part)) * range;
    [self setBarPosition:pos andAnimation:animation];
}

- (void)setBarPosition:(CGFloat)pos andAnimation:(BOOL)animation
{
    CGRect barRect = _bar.frame;
    CGRect shownRect = _shown.frame;
    
    if (_style == WGSlideBarStyleVertical) {
        if (pos > self.frame.size.height - barRect.size.height)
            pos = self.frame.size.height - barRect.size.height;
        else if (pos < 0)
            pos = 0;

        barRect.origin.y = pos;
        shownRect.size.height = pos + barRect.size.height / 2;
    } else {
        if (pos > self.frame.size.width - barRect.size.width)
            pos = self.frame.size.width - barRect.size.width;
        else if (pos < 0)
            pos = 0;

        barRect.origin.x = pos;
        shownRect.size.width = pos + barRect.size.width / 2;
    }
    
    if (animation) {
        [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            _bar.frame = barRect;
            _shown.frame = shownRect;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        _bar.frame = barRect;
        _shown.frame = shownRect;
    }
}

- (CGFloat)getBarOffset:(UIPanGestureRecognizer *)pan
{
    CGPoint translatedPoint = [pan translationInView:self];
    //printf("translatedPoint:%s \n",NSStringFromCGPoint(translatedPoint).UTF8String);
    CGFloat offset = 0;
    if (_style == WGSlideBarStyleVertical) {
        offset = translatedPoint.y + _bar.frame.origin.y;
    } else {
        offset = translatedPoint.x + _bar.frame.origin.x;
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    
    return offset;
}

#pragma mark UIGestureRecognizer Method

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    CGFloat offset = [self getBarOffset:pan];
    [self setBarPosition:offset andAnimation:NO];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        //printf("Begin. \n");
        
        if ([_delegate respondsToSelector:@selector(slideBarDidBeginSlide:)]) {
            [_delegate slideBarDidBeginSlide:self];
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        //printf("Change. \n");
        
        if (_continuous) {
            if ([_delegate respondsToSelector:@selector(slideBarDidSlide:)]) {
                [_delegate slideBarDidSlide:self];
            }
        }
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        //printf("End. \n");
        
        if (!_continuous) {
            if ([_delegate respondsToSelector:@selector(slideBarDidSlide:)]) {
                [_delegate slideBarDidSlide:self];
            }
        }
        
        if ([_delegate respondsToSelector:@selector(slideBarDidEndSlide:)]) {
            [_delegate slideBarDidEndSlide:self];
        }
    }
}

- (void)onTap:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self];
    //printf("tapPoint:%s \n",NSStringFromCGPoint(tapPoint).UTF8String);
    
    CGFloat offset = 0;
    if (_style == WGSlideBarStyleVertical) {
        offset = tapPoint.y - _bar.frame.size.height / 2;
    } else {
        offset = tapPoint.x - _bar.frame.size.width / 2;
    }
    
    [self setBarPosition:offset andAnimation:YES];
    
    if ([_delegate respondsToSelector:@selector(slideBarDidSlide:)]) {
        [_delegate slideBarDidSlide:self];
    }
}




@end
