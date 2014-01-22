//
//  GameViewController.m
//  DynamicCircle
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "GameViewController.h"
#import "EndViewController.h"
#import <AVFoundation/AVFoundation.h>

#define WIDTH 70 // 원 가로크기
#define HEIGHT 70 // 원 세로크기
#define GAME_TIME 20 // 게임 카운트 시간

@interface GameViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *circleCount;
@property (weak, nonatomic) IBOutlet UILabel *timeCount;

@end

@implementation GameViewController
{
    NSMutableArray *circle;
    AVAudioPlayer *player;
    NSTimer *timer;
    NSTimer *sizeTimer;
    NSInteger time;
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
    
    
    // 원을 생성해준다. (ImageView -> MutableArray에 넣어 저장한다.)
    circle = [[NSMutableArray alloc] init];
    for(NSInteger i=0; i < 10; i++)
    {
        UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake( (arc4random() % ((int)self.view.frame.size.width - WIDTH)),  (arc4random() % ((int)self.view.frame.size.height - HEIGHT)) + 35, WIDTH, HEIGHT)];
        [currentImageView setImage:[UIImage imageNamed:@"circle.png"]];
        [circle addObject:currentImageView];
        [self.view addSubview:circle[i]];
    }
    
    // 원의 개수를 라벨에 표시해준다.
    self.circleCount.text = [NSString stringWithFormat:@"%d", [circle count]];
    
    // 타이머 시작
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    sizeTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateCircle) userInfo:nil repeats:YES];
    time = GAME_TIME;
    self.timeCount.text = [NSString stringWithFormat:@"%d",time];
    
    // 배경음악 재생
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"jungle-run" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite
    player.delegate = self;
    if([player prepareToPlay])
    {
        [player play];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:(float)circle.count / 5 delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        
        UIImageView *currentImageView;
        currentImageView = circle[arc4random() % circle.count];
        currentImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
    }     completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(circle.count == 0)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    

    // 터치시에도 스레드가 돌아가며 어떤 것이 클릭되었는지 체크한다.
    [UIView animateWithDuration:(float)circle.count / 5 animations:^{
        
        for(NSInteger i=0; i < circle.count; i++)
        {
            UIImageView *currentImageView;
            currentImageView = circle[i];
            
            // 해당 이미지에 맞는 좌표값을 눌렀을 경우
            if(CGRectContainsPoint(currentImageView.frame, point))
            {
                [[circle objectAtIndex:i] removeFromSuperview];
                [circle removeObjectAtIndex:i];
                self.circleCount.text = [NSString stringWithFormat:@"%d", [circle count]];
                NSLog(@"%d", [circle count]);
                
                
                // 게임 끝날 시 (Game End)
                if(circle.count == 0)
                {
                    // 타이머 삭제
                    [timer invalidate];
                    
                    // 음악 중지시키고 다음으로 넘어감
                    if([player isPlaying])
                    {
                        [player stop];
                    }
                    
                    UIStoryboard *storyboard = self.storyboard;
                    // 스토리 보드에서 뷰 컨트롤러 얻어오기
                    EndViewController *endVC = [storyboard instantiateViewControllerWithIdentifier:@"endVC"];
                    
                    // 데이터 넘기기
                    endVC.circleCount = circle.count;
                    endVC.gameEndTime = time;
                    endVC.totalGameTime = GAME_TIME;
                    
                    // 뷰 컨트롤러 전환
                    [self presentViewController:endVC animated:YES completion:nil];
                    
                    return;
                }
                
                UIImageView *currentImageView;
                currentImageView = circle[arc4random() % circle.count];
                currentImageView.frame = CGRectMake( (arc4random() % ((int)self.view.frame.size.width - WIDTH)),  (arc4random() % ((int)self.view.frame.size.height - HEIGHT)) + 35, WIDTH, HEIGHT);
            }
        }
        
        
    }];
    
}

// 시간 라벨 업데이트
-(void)updateTime
{
    // 게임 끝날 시 (Game End)
    if (time == 0)
    {
        // 타이머 삭제
        [timer invalidate];
        
        
        // 음악 중지시키고 다음으로 넘어감
        if([player isPlaying])
        {
            [player stop];
        }
        
        UIStoryboard *storyboard = self.storyboard;
        // 스토리 보드에서 뷰 컨트롤러 얻어오기
        EndViewController *endVC = [storyboard instantiateViewControllerWithIdentifier:@"endVC"];
        
        // 데이터 넘기기
        endVC.circleCount = circle.count;
        endVC.gameEndTime = time;
        endVC.totalGameTime = GAME_TIME;
        
        // 뷰 컨트롤러 전환
        [self presentViewController:endVC animated:YES completion:nil];
        
        return;
    }
    else
    {
        time = time - 1;
        self.timeCount.text = [NSString stringWithFormat:@"%d",time];
        
        if(time % 2 == 0)
        {
            UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake( (arc4random() % ((int)self.view.frame.size.width - WIDTH)),  (arc4random() % ((int)self.view.frame.size.height - HEIGHT)) + 35, WIDTH, HEIGHT)];
            [currentImageView setImage:[UIImage imageNamed:@"circle.png"]];
            [circle addObject:currentImageView];
            [self.view addSubview:currentImageView];
            self.circleCount.text = [NSString stringWithFormat:@"%d", [circle count]];
        }
    }
}

-(void)updateCircle
{
    if(circle.count == 0)
        return;
    
    
    [UIView animateWithDuration:(float)circle.count / 5 delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        
        UIImageView *currentImageView;
        currentImageView = circle[arc4random() % circle.count];
        currentImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
    }     completion:nil];
}

@end
