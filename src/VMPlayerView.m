//
//  VMPlayerView.m
//  Example
//
//  Created by Vincent.Wen on 14-3-21.
//  Copyright (c) 2014年 Vincent.Man. All rights reserved.
//

#import "VMPlayerView.h"

static void *VMPlayerTimedMetadataObserverContext   = &VMPlayerTimedMetadataObserverContext;
static void *VMPlayerRateObservationContext         = &VMPlayerRateObservationContext;
static void *VMPlayerCurrentItemObservationContext  = &VMPlayerCurrentItemObservationContext;
static void *VMPlayerItemStatusObserverContext      = &VMPlayerItemStatusObserverContext;
static void *VMPlayerItemLoadedTimeRangeContext     = &VMPlayerItemLoadedTimeRangeContext;
static void *VMPlayerItemSeekTimeRangeContext       = &VMPlayerItemSeekTimeRangeContext;

//for player
NSString *kTracksKey            = @"tracks";
NSString *kRateKey              = @"rate";
NSString *kPlayableKey          = @"playable";
NSString *kCurrentItemKey       = @"currentItem";
NSString *kTimedMetadataKey     = @"currentItem.timedMetadata";

//for item
NSString *kStatusKey            = @"status";
NSString *kLoadedTimeRanges     = @"loadedTimeRanges";
NSString *kSeekableTimeRanges   = @"seekableTimeRanges";

@interface VMPlayerView()
@property (nonatomic, strong) AVPlayerItem  *item;
@property (nonatomic, strong) AVURLAsset    *asset;
@property (nonatomic, strong) AVPlayer      *player;
@property (nonatomic, strong) AVPlayerLayer *layer;
@end

@implementation VMPlayerView

+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (void)ready{
    if (self.resourcePath.length > 0) {
        NSURL *url = [NSURL URLWithString:self.resourcePath];
        
        if ([url scheme]) {
            self.asset = [AVURLAsset URLAssetWithURL:url options:Nil];
            NSArray *requestKeys = @[kTracksKey, kPlayableKey];
            
            [self.asset loadValuesAsynchronouslyForKeys:requestKeys
                                      completionHandler:^{
#if DEBUG
                                          NSLog(@"asset load values success!");
#endif
                                          self.status = VMPlayerInitial;
                                          [self prepareToPlayAsset:self.asset withKeys:requestKeys];
                                      }];
        }
    }
}

- (void)play{
    self.status = VMPlayerPlaying;
    [self.player play];
}

- (void)pause{
    self.status = VMPlayerPause;
    [self.player pause];
}

- (void)stop{
    
}

- (void)seek{
    
}

- (void)prepareToPlayAsset:(AVAsset *)asset withKeys:(NSArray *)keys{
    
    for (NSString *_key in keys) {
        NSError *error = Nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:_key error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
#if DEBUG
            NSLog(@"key value status failed!");
#endif
            return;
        }
    }
    
    if (!asset.playable) {
#if DEBUG
        NSLog(@"assest unplayable!");
#endif
        return;
    }
    
    self.item = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.item addObserver:self
                forKeyPath:kStatusKey
                   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                   context:VMPlayerItemStatusObserverContext];
    
    [self.item addObserver:self
                forKeyPath:kLoadedTimeRanges
                   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                   context:VMPlayerItemLoadedTimeRangeContext];
    
    [self.item addObserver:self
                forKeyPath:kSeekableTimeRanges
                   options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                   context:VMPlayerItemSeekTimeRangeContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.item];
    
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.item];
        
        [self.player addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:VMPlayerCurrentItemObservationContext];
        
        [self.player addObserver:self
                      forKeyPath:kTimedMetadataKey
                         options:0
                         context:VMPlayerTimedMetadataObserverContext];
        
        [self.player addObserver:self
                      forKeyPath:kRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:VMPlayerRateObservationContext];
        
        if (self.player.currentItem != self.item) {
            [self.player replaceCurrentItemWithPlayerItem:self.item];
        }
    }
}

- (void)playerItemDidReachEnd:(id)sender{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if (context == VMPlayerItemStatusObserverContext) {
        
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusUnknown:
                //cant play
                self.status = VMPlayerBuffring;
                break;
            case AVPlayerStatusReadyToPlay:
                //ready to play
                [(AVPlayerLayer *)self.layer setPlayer:self.player];
                self.status = VMPlayerReady;
                break;
            case AVPlayerStatusFailed:{
                //load fail
                self.status = VMPlayerFailture;
                AVPlayerItem *item = (AVPlayerItem *)object;
#if DEBUG
                NSLog(@"%@",item.error.debugDescription);
#endif
            }
                break;
        }
        
    }else if (context == VMPlayerRateObservationContext){
        //player stop or not
        
    }else if (context == VMPlayerCurrentItemObservationContext){
        
    }else if (context == VMPlayerTimedMetadataObserverContext){
        
    }else if (context == VMPlayerItemLoadedTimeRangeContext){
#if DEBUG
        NSLog(@"LoadedTimeRanges -> \n%@",self.player.currentItem.loadedTimeRanges);
#endif
    }else if (context == VMPlayerItemSeekTimeRangeContext){
#if DEBUG
        NSLog(@"SeekableTimeRanges -> \n%@",self.player.currentItem.seekableTimeRanges);
#endif
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    return;
}

@end
