//
//  EndViewController.m
//  DynamicCircle
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "EndViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface EndViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end

@implementation EndViewController
{
    AVAudioPlayer *player;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 배경음악 재생
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"BGHappy" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite
    player.delegate = self;
    if([player prepareToPlay])
    {
        [player play];
    }
    
    
    if(self.gameEndTime == 0) // 게임시간이 다됐을 경우
    {
        self.endLabel.text = [NSString stringWithFormat:@"Game Over!\nYour circle count is %d", self.circleCount];
    }
    else if(self.circleCount == 0) // 원을 다 없앴을 경우 축하메시지
    {
        self.endLabel.text = [NSString stringWithFormat:@"Congratulations!!\nYour circle count is Zero!\nYour remain time is %d/%d!", self.gameEndTime, self.totalGameTime];
    }
    
    [self blinkAnimation:@"blinkAnimation" finished:YES target:self.endLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 깜박거리는 이펙트 애니메이션 함수
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

@end
