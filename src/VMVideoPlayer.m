//
//  VMVideoPlayer.m
//  Example
//
//  Created by Vincent.Wen on 14-3-20.
//  Copyright (c) 2014年 Vincent.Man. All rights reserved.
//

#import "VMVideoPlayer.h"
#import "YDSlider.h"
#import "VMPlayerView.h"

#define CurrentOrientation [UIApplication sharedApplication].statusBarOrientation

#define UIHeight 36.0f
#define BoardOffset 10.0f
#define UIOffest 8.0f
#define SliderPending 10.0f
#define BoardPHeight 40.0f
#define BoardLHeight 69.0f

#define TimeLabelWeight 57.0f
#define TimeLabelHeight 21.0f

static void *PlayStatusObserverContext = &PlayStatusObserverContext;

@interface VMVideoPlayer()

@property (nonatomic, strong) VMPlayerView *playerview;

@property (nonatomic, assign) BOOL isUIHide;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

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
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UILabel *currentTimeLabel;

@end

@implementation VMVideoPlayer
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

#pragma mark -- Player Logic Part

- (void)load{
    if (self.resourcePath.length < 1) {
#if DEBUG
        NSLog(@"video path is nil!");
#endif
        return;
    }
    
    [self.playerview addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:PlayStatusObserverContext];
    
    self.playerview.resourcePath = self.resourcePath;
    [self.playerview ready];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if (context == PlayStatusObserverContext) {
        switch (self.playerview.status) {
            case VMPlayerReady:
                [self.spinner stopAnimating];
                [self.playerview play];
                [self setPlayBtnStatus:NO];
                
                break;
            case VMPlayerFailture:
#if DEBUG
                NSLog(@"player fail to play");
#endif
                break;
            default:
                break;
        }
    }
}

- (void)setPlayBtnStatus:(BOOL)isPlay{
    if (isPlay) {
        [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

#pragma mark -- UI Part

- (void)setUpUI{
    [self addSubview:self.playerview];
    [self addSubview:self.spinner];
    [self addSubview:self.headerControlBoard];
    [self addSubview:self.footerControlBoard];
    
    self.isUIHide = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer{
    if (self.isUIHide) {
        self.isUIHide = !self.isUIHide;
        [self.headerControlBoard setHidden:self.isUIHide];
        [self.footerControlBoard setHidden:self.isUIHide];
        
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            [self.headerControlBoard setHidden:YES];
        }
        
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

- (VMPlayerView *)playerview{
    if (!_playerview) {
        _playerview = [[VMPlayerView alloc] initWithFrame:self.bounds];
        _playerview.backgroundColor = [UIColor blackColor];
        _playerview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_playerview addGestureRecognizer:tap];
    }
    return _playerview;
}

- (UIActivityIndicatorView *)spinner{
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_spinner hidesWhenStopped];
        [_spinner stopAnimating];
#if DEBUG
        [_spinner setColor:[UIColor yellowColor]];
//        [_spinner startAnimating];
#endif
    }
    return _spinner;
}

- (UIView *)headerControlBoard{
    if (!_headerControlBoard) {
        _headerControlBoard = [[UIView alloc] initWithFrame:CGRectZero];
        [_headerControlBoard setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.46]];
        [_headerControlBoard addSubview:self.titleLabel];
        [_headerControlBoard addSubview:self.lockBtn];
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
        [_footerControlBoard setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.46]];
        [_footerControlBoard addSubview:self.slider];
        [_footerControlBoard addSubview:self.playBtn];
        [_footerControlBoard addSubview:self.fullScreenBtn];
        [_footerControlBoard addSubview:self.currentTimeLabel];
        [_footerControlBoard addSubview:self.totalTimeLabel];
        
        self.footerControlBoard.alpha = 0.0f;
        [_footerControlBoard setHidden:YES];
    }
    return _footerControlBoard;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 47, 280, 15)];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
#if DEBUG
        [_titleLabel setText:@"Vincent.Man -- VMVideoPlayer"];
#endif
        
    }
    return _titleLabel;
}

- (UIButton *)lockBtn{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setFrame:CGRectMake(512, 41, 21, 21)];
        [_lockBtn setImage:[UIImage imageNamed:@"lock_off"] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:@"lock_on"] forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
#if DEBUG
        [_lockBtn setSelected:YES];
#endif
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
        _slider.middleTrackTintColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        _slider.maximumTrackTintColor = [UIColor colorWithWhite:0.5 alpha:0.9];
        [_slider setThumbImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];

#if DEBUG
        [_slider setValue:0.0f];
        [_slider setMiddleValue:0.2f];
#endif
        
    }
    return _slider;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setFrame:CGRectMake(0, 0, UIHeight, UIHeight)];
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setFrame:CGRectMake(0, 0, UIHeight, UIHeight)];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"zoomout"] forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(zoomBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TimeLabelWeight, TimeLabelHeight)];
        [_currentTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [_currentTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_currentTimeLabel setTextColor:[UIColor lightTextColor]];
        [_currentTimeLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_currentTimeLabel setHidden:YES];
        
#if DEBUG
        [_currentTimeLabel setText:@"00:11:56"];
#endif
        
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TimeLabelWeight, TimeLabelHeight)];
        [_totalTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [_totalTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_totalTimeLabel setTextColor:[UIColor lightTextColor]];
        [_totalTimeLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_totalTimeLabel setHidden:YES];
        
#if DEBUG
        [_totalTimeLabel setText:@"01:12:43"];
#endif
        
    }
    return _totalTimeLabel;
}

- (void)layoutSubviews{
    
    CGRect viewFrame = self.frame;
    
    [self.spinner setCenter:CGPointMake(CGRectGetWidth(viewFrame)/2, CGRectGetHeight(viewFrame)/2)];
    
    UIInterfaceOrientation orientation = CurrentOrientation;
    
    if (UIDeviceOrientationIsPortrait(orientation)) {
        if (!self.isUIHide) {
            [self.headerControlBoard setHidden:YES];
        }
//        [self.headerControlBoard setFrame:CGRectMake(0, 0, CGRectGetWidth(viewFrame), UIHeight)];
        
        [self.footerControlBoard setFrame:CGRectMake(0, CGRectGetHeight(viewFrame)-(UIHeight), CGRectGetWidth(viewFrame), UIHeight)];
        
        [self.currentTimeLabel setHidden:YES];
        [self.totalTimeLabel setHidden:YES];
        
        [self.slider setFrame:CGRectMake(0, 0, CGRectGetWidth(self.footerControlBoard.frame) - BoardOffset/2 - CGRectGetWidth(self.playBtn.frame) - CGRectGetWidth(self.fullScreenBtn.frame) - UIOffest*2 - SliderPending*2, CGRectGetHeight(self.slider.frame))];
        [self.slider setCenter:CGPointMake(CGRectGetWidth(self.footerControlBoard.frame)/2 - SliderPending, CGRectGetHeight(self.footerControlBoard.frame)/2)];
        
    }else if (UIDeviceOrientationIsLandscape(orientation)){
        
        if (!self.isUIHide) {
            [self.headerControlBoard setHidden:NO];
        }
        
        [self.headerControlBoard setFrame:CGRectMake(0, 0, CGRectGetWidth(viewFrame), BoardLHeight)];
        
        [self.footerControlBoard setFrame:CGRectMake(0, CGRectGetHeight(viewFrame)-(UIHeight+BoardOffset), CGRectGetWidth(viewFrame), UIHeight+BoardOffset)];
        
        [self.currentTimeLabel setHidden:NO];
        [self.totalTimeLabel setHidden:NO];
        
        [self.currentTimeLabel setCenter:CGPointMake(BoardOffset/2+CGRectGetWidth(self.playBtn.frame)+UIOffest+CGRectGetWidth(self.currentTimeLabel.frame)/2, CGRectGetHeight(self.footerControlBoard.frame)/2)];
        
        [self.totalTimeLabel setCenter:CGPointMake(CGRectGetWidth(self.footerControlBoard.frame) - UIHeight - UIOffest - CGRectGetWidth(self.totalTimeLabel.frame)/2, CGRectGetHeight(self.footerControlBoard.frame)/2)];
        
        [self.slider setFrame:CGRectMake(0, 0,
                                         CGRectGetWidth(self.footerControlBoard.frame) - BoardOffset/2 - CGRectGetWidth(self.playBtn.frame) - CGRectGetWidth(self.fullScreenBtn.frame) - CGRectGetWidth(self.currentTimeLabel.frame)*2 - UIOffest*4 - SliderPending*2,
                                         CGRectGetHeight(self.slider.frame))];
        
        [self.slider setCenter:CGPointMake(CGRectGetWidth(self.footerControlBoard.frame)/2 - SliderPending,
                                           CGRectGetHeight(self.footerControlBoard.frame)/2)];
    }else{
        
    }
    
    CGRect footRect = self.footerControlBoard.frame;
    
    [self.playBtn setCenter:CGPointMake(CGRectGetWidth(self.playBtn.frame)/2+BoardOffset/2, CGRectGetHeight(footRect)/2)];
    [self.fullScreenBtn setCenter:CGPointMake(CGRectGetWidth(footRect) - CGRectGetWidth(self.playBtn.frame)/2, CGRectGetHeight(footRect)/2)];
    
    
}

- (void)playBtnTap:(id)sender{
    
    if (self.playerview.status == VMPlayerBuffring ||self.playerview.status == VMPlayerPlaying) {
        [self.playerview pause];
        [self setPlayBtnStatus:YES];
    }else if (self.playerview.status == VMPlayerReady | self.playerview.status == VMPlayerPause){
        [self.playerview play];
        [self setPlayBtnStatus:NO];
    }else{
        [self load];
        [self.spinner startAnimating];
    }
#if DEBUG
    NSLog(@"play button tap!");
#endif
}

- (void)zoomBtnTap:(id)sender{
#if DEBUG
    NSLog(@"zoom button tap!");
#endif
}

- (void)lockBtnTap:(id)sender{
#if DEBUG
    NSLog(@"lock button tap!");
#endif
}

@end
