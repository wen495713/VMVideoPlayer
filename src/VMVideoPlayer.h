//
//  VMVideoPlayer.h
//  Example
//
//  Created by Vincent.Wen on 14-3-20.
//  Copyright (c) 2014年 Vincent.Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMVideoPlayer : UIView
@property (nonatomic, copy) NSString *resourcePath;
- (void)load;
@end
