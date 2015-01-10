//
//  ViewController.m
//  Babyface
//
//  Created by Marco Klingmann on 10.01.15.
//  Copyright (c) 2015 Marco Klingmann. All rights reserved.
//

#import "ViewController.h"
#import "MMWormhole.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController () {
    MMWormhole *_wormhole;
    MPMoviePlayerController *_moviePlayer;
    NSTimer *_timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.watchkit.babyface.sharedcontainer" optionalDirectory:nil];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Baby.mp4" withExtension:nil];
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [_moviePlayer play];
    
    [_moviePlayer.view setFrame:self.view.bounds];
    [_moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];

    [self.view addSubview:_moviePlayer.view];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    


    UIImage *image = [UIImage imageNamed:@"baby-red"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_wormhole passMessageObject:imageData identifier:@"UpdateImage"];
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    });
    
    
    
    
}

- (void)timerFireMethod:(NSTimer *)timer {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_moviePlayer.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
