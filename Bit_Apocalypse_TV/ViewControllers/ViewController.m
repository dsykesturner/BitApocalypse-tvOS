//
//  ViewController.m
//  Bit_Apocalypse_TV
//
//  Created by Daniel Sykes-Turner on 18/09/2015.
//  Copyright © 2015 UniverseApps. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "TransitionManager.h"

#import <GameKit/GameKit.h>

@interface ViewController () <GKGameCenterControllerDelegate, AVAudioPlayerDelegate>

@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString * leaderboardIdentifier;

@property (nonatomic, weak) IBOutlet UIImageView *musicOnOff;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) NSTimer *trmCreateMeteors;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //auto login to game center
    [self authenticatePlayer];
    
    [TransitionManager lightenScreenWithView:nil forViewController:self completion:^(BOOL finished) {}];
    
    self.trmCreateMeteors = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(createMeteor) userInfo:nil repeats:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"notPlayingMusic"])
        [self.musicOnOff setImage:[UIImage imageNamed:@"music_off"]];
    else
        [self.musicOnOff setImage:[UIImage imageNamed:@"music_on"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createMeteor
{
    int screenWidth = self.view.frame.size.width+20;
    
    int rand = arc4random() % screenWidth - 20;
    int size = 20;
    
    UIImageView *meteor = [[UIImageView alloc] initWithFrame:CGRectMake(rand, -20, size, size)];
    [meteor setImage:[UIImage imageNamed:[NSString stringWithFormat:@"meteor%ia", (arc4random()) % 5 + 1]]];
    [self.backgroundView addSubview:meteor];
    
    
    [UIView animateWithDuration:30 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        meteor.center = CGPointMake(meteor.center.x, self.view.frame.size.height+20);
        
    } completion:^(BOOL finished) {
        
        //also completed when screen is no longer in use
        [meteor removeFromSuperview];
    }];
}


-(IBAction)startGame:(id)sender
{
    [self.trmCreateMeteors invalidate];
    
    [TransitionManager darkenScreenWithView:nil forViewController:self completion:^(BOOL finished) {
        [app_delegate moveToGameScreen];
    }];
}
-(IBAction)playStory:(id)sender
{
    [self.trmCreateMeteors invalidate];
    
    [TransitionManager darkenScreenWithView:nil forViewController:self completion:^(BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"notFirstRun"];
        [app_delegate moveToStoryScreen];
    }];
}

-(IBAction)startStopMusic:(id)sender
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"notPlayingMusic"])
    {
        [app_delegate.audioPlayer stop];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"notPlayingMusic"];
        [self.musicOnOff setImage:[UIImage imageNamed:@"music_off"]];
    }
    else
    {
        [app_delegate chooseRandomSong];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"notPlayingMusic"];
        [self.musicOnOff setImage:[UIImage imageNamed:@"music_on"]];
    }
}




//game center delegate
-(void)authenticatePlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated)
            {
                self.gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier. do i need this though?
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil)
                        NSLog(@"%@", [error localizedDescription]);
                    else
                        self.leaderboardIdentifier = leaderboardIdentifier;
                }];
            }
            else
            {
                self.gameCenterEnabled = NO;
            }
        }
    };
}

-(IBAction)openGameCentre:(id)sender
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    gameCenterController.gameCenterDelegate = self;
    [self presentViewController:gameCenterController animated:YES completion:nil];
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*) gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
