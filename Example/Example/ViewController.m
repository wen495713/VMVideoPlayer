//
//  ViewController.m
//  Example
//
//  Created by Vincent.Wen on 14-3-20.
//  Copyright (c) 2014年 Vincent.Man. All rights reserved.
//

#import "ViewController.h"
#import "VMVideoPlayer.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet VMVideoPlayer *videoplayer;
@property (assign, nonatomic) CGRect originalRect;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.originalRect = self.videoplayer.frame;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    self.videoplayer.resourcePath = @"http://encode1.hk1.tvb.com/hls/bigman-iv-e/bigman.m3u8";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         [self.videoplayer setFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
//                     }
//                     completion:^(BOOL finished) {
//                         NSLog(@"completion");
//                     }];
    

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIDeviceOrientationIsPortrait(orientation)) {
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.videoplayer setFrame:self.originalRect];
                         }
                         completion:^(BOOL finished) {
                             NSLog(@"completion");
                         }];
    }else if (UIDeviceOrientationIsLandscape(orientation)){
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.videoplayer setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
                         }
                         completion:^(BOOL finished) {
                             NSLog(@"completion");
                         }];
    }else{
        NSLog(@"Invaild Orientation");
    }
    
    

}
@end
