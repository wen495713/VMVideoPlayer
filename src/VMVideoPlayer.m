//
//  VMVideoPlayer.m
//  Example
//
//  Created by Vincent.Wen on 14-3-20.
//  Copyright (c) 2014年 Vincent.Man. All rights reserved.
//

#import "VMVideoPlayer.h"
#import "YDSlider.h"

#define CurrentOrientation [UIApplication sharedApplication].statusBarOrientation

#define UIHeight 34.0f
#define BoardOffset 10.0f

#define BoardPHeight 40.0f
#define BoardLHeight 60.0f
@interface VMVideoPlayer()

@property (nonatomic, assign) BOOL isUIHide;

#pragma -- footer control board
@property (nonatomic, strong) UIView *headerControlBoard;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *lockBtn;
@property (nonatomic, strong) UIButton *other1Btn;//for other use
@property (nonatomic, strong) UIButton *other2Btn;//for other use

#pragma -- footer control board
@property (nonatomic, strong) UIView *footerControlBoard;

@property (nonatomic, strong) YDSlider *slider;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *fullScreenBtn;

@end

@implementation VMVideoPlayer
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self addSubview:self.headerControlBoard];
    [self addSubview:self.footerControlBoard];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    self.isUIHide = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer{
    if (self.isUIHide) {
        self.isUIHide = !self.isUIHide;
        [self.headerControlBoard setHidden:self.isUIHide];
        [self.footerControlBoard setHidden:self.isUIHide];
        [UIView animateWithDuration:0.25 animations:^{
            self.headerControlBoard.alpha = 1.0f;
            self.footerControlBoard.alpha = 1.0f;
        }];
    }else{
        self.isUIHide = !self.isUIHide;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.headerControlBoard.alpha = 0.0f;
                             self.footerControlBoard.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [self.headerControlBoard setHidden:self.isUIHide];
                             [self.footerControlBoard setHidden:self.isUIHide];
                         }];
    }
    
}

- (UIView *)headerControlBoard{
    if (!_headerControlBoard) {
        _headerControlBoard = [[UIView alloc] initWithFrame:CGRectZero];
        [_headerControlBoard setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
//        [_headerControlBoard addSubview:self.titleLabel];
//        [_headerControlBoard addSubview:self.lockBtn];
//        [_headerControlBoard addSubview:self.other1Btn];
//        [_headerControlBoard addSubview:self.other2Btn];
        self.headerControlBoard.alpha = 0.0f;
        [_headerControlBoard setHidden:YES];
    }
    return _headerControlBoard;
}

- (UIView *)footerControlBoard{
    if (!_footerControlBoard) {
        _footerControlBoard = [[UIView alloc] initWithFrame:CGRectZero];
        [_footerControlBoard setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
//        [_footerControlBoard addSubview:self.slider];
        [_footerControlBoard addSubview:self.playBtn];
        [_footerControlBoard addSubview:self.fullScreenBtn];
        self.footerControlBoard.alpha = 0.0f;
        [_footerControlBoard setHidden:YES];
    }
    return _footerControlBoard;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _titleLabel;
}

- (UIButton *)lockBtn{
    if (_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _lockBtn;
}

- (UIButton *)other1Btn{
    if (!_other1Btn) {
        _other1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _other1Btn;
}

- (UIButton *)other2Btn{
    if (!_other2Btn) {
        _other2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _other2Btn;
}

- (YDSlider *)slider{
    if (!_slider) {
        _slider = [[YDSlider alloc] initWithFrame:CGRectMake(0, 0, 0, UIHeight)];
        _slider.minimumTrackTintColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        _slider.middleTrackTintColor = [UIColor colorWithWhite:0.1 alpha:0.9];
        _slider.maximumTrackTintColor = [UIColor colorWithWhite:0.5 alpha:0.9];
    }
    return _slider;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setBackgroundColor:[UIColor whiteColor]];
        [_playBtn setFrame:CGRectMake(0, 0, UIHeight, UIHeight)];
    }
    return _playBtn;
}

- (UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setBackgroundColor:[UIColor whiteColor]];
        [_fullScreenBtn setFrame:CGRectMake(0, 0, UIHeight, UIHeight)];
    }
    return _fullScreenBtn;
}

- (void)layoutSubviews{
    
    CGRect viewFrame = self.frame;
    UIInterfaceOrientation orientation = CurrentOrientation;
    
    if (UIDeviceOrientationIsPortrait(orientation)) {
        [self.headerControlBoard setFrame:CGRectMake(0, 0, CGRectGetWidth(viewFrame), UIHeight)];
        
        [self.footerControlBoard setFrame:CGRectMake(0, CGRectGetHeight(viewFrame)-(UIHeight), CGRectGetWidth(viewFrame), UIHeight)];
        
    }else if (UIDeviceOrientationIsLandscape(orientation)){
        [self.headerControlBoard setFrame:CGRectMake(0, 0, CGRectGetWidth(viewFrame), BoardLHeight)];
        
        [self.footerControlBoard setFrame:CGRectMake(0, CGRectGetHeight(viewFrame)-(UIHeight+BoardOffset), CGRectGetWidth(viewFrame), UIHeight+BoardOffset)];
        
        
    }else{
        
    }
    
    CGRect footRect = self.footerControlBoard.frame;
    
    [self.playBtn setCenter:CGPointMake(CGRectGetWidth(self.playBtn.frame)/2, CGRectGetHeight(footRect)/2)];
    [self.fullScreenBtn setCenter:CGPointMake(CGRectGetWidth(footRect) - CGRectGetWidth(self.playBtn.frame)/2, CGRectGetHeight(footRect)/2)];
    CGRect sliderFrame = self.slider.frame;
    
    
}

@end
