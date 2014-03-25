//
//  VMPlayerView.h
//  Example
//
//  Created by Vincent.Wen on 14-3-21.
//  Copyright (c) 2014年 Vincent.Man. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef enum{
    VMPlayerInitial     = 0,
    VMPlayerStop        = 1,
    VMPlayerReady       = 2,
    VMPlayerPlaying     = 3,
    VMPlayerPause       = 4,
    VMPlayerBuffring    = 5,
    VMPlayerFailture    = 6
}VMPlayerStatus;

@interface VMPlayerView : UIView

@property (nonatomic, assign) VMPlayerStatus status;
@property (nonatomic, copy) NSString *resourcePath;

- (void)ready;
- (void)play;
- (void)pause;
- (void)stop;
- (void)seek;
@end
