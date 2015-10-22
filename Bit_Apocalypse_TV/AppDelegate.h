//
//  AppDelegate.h
//  Bit_Apocalypse_TV
//
//  Created by Daniel Sykes-Turner on 18/09/2015.
//  Copyright © 2015 UniverseApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVAudioPlayer.h"

#define app_delegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL playingFirstSong;

-(void)chooseRandomSong;

-(void)moveToGameScreen;
-(void)moveToHomeScreen;
-(void)moveToStoryScreen;

@end

