//
//  AppDelegate.m
//  Bit_Apocalypse_TV
//
//  Created by Daniel Sykes-Turner on 18/09/2015.
//  Copyright © 2015 UniverseApps. All rights reserved.
//

#import "AppDelegate.h"
#import "GameViewController.h"
#import "ViewController.h"
#import "StoryIntoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.audioPlayer stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"notPlayingMusic"])
        [self chooseRandomSong];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Navigation

-(void)moveToGameScreen
{
    GameViewController *gameVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GameViewController"];
    
    self.window.rootViewController = gameVC;
    [self.window makeKeyAndVisible];
}
-(void)moveToHomeScreen
{
    ViewController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    
    self.window.rootViewController = homeVC;
    [self.window makeKeyAndVisible];
}
-(void)moveToStoryScreen
{
    StoryIntoViewController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"StoryIntroViewController"];
    
    self.window.rootViewController = homeVC;
    [self.window makeKeyAndVisible];
}

#pragma mark - Audio Usage

-(void)chooseRandomSong
{
    float rand = arc4random() % 10;
    if (rand < 5)
        [self playFirstSong];
    else
        [self playSecondSong];
}
-(void)playFirstSong
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Operation_Catch_the_Bad_Guy_8_Bit" ofType:@"mp3"]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    
    self.playingFirstSong = true;
}
-(void)playSecondSong
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Pixelated_Cosmos" ofType:@"mp3"]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    
    self.playingFirstSong = false;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.playingFirstSong)
        [self playSecondSong];
    else
        [self playFirstSong];
}


@end
