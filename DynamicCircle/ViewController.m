//
//  ViewController.m
//  DynamicCircle
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface ViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *gamestartButton;
@property (weak, nonatomic) IBOutlet UILabel *gamestartLabel;
- (IBAction)buttonSound:(id)sender;


@end

@implementation ViewController
{
    AVAudioPlayer *player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 게임시작 버튼에 애니메이션 적용
    [self blinkAnimation:@"blinkAnimation" finished:YES target:self.gamestartLabel];
    
    
    // 배경음악 재생
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"midnight-ride" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite
    player.delegate = self;
    if([player prepareToPlay])
    {
        [player play];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 게임시작 버튼이 깜박거리는 이펙트 애니메이션 함수
- (void)blinkAnimation:(NSString *)animationID finished:(BOOL)finished target:(UIView *)target
{
    NSString *selectedSpeed = [[NSUserDefaults standardUserDefaults] stringForKey:@"EffectSpeed"];
    float speedFloat = (1.00 - [selectedSpeed floatValue]);
    
    [UIView beginAnimations:animationID context:(__bridge void *)(target)];
    [UIView setAnimationDuration:speedFloat];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(blinkAnimation:finished:target:)];
    
    if([target alpha] == 1.0f)
        [target setAlpha:0.0f];
    else
        [target setAlpha:1.0f];
    [UIView commitAnimations];
}


// 게임시작 버튼 누를 시 button-7 사운드 재생하고, 게임 시작화면으로 넘어감
- (IBAction)buttonSound:(id)sender {
    
    // 음악 중지시키고 다음으로 넘어감
    if([player isPlaying])
    {
        [player stop];
    }
    
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"button-7" ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end
