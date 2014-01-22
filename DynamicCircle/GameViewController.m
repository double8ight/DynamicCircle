//
//  GameViewController.m
//  DynamicCircle
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "GameViewController.h"
#import "EndViewController.h"

#define WIDTH 100
#define HEIGHT 100

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *circleCount;

@end

@implementation GameViewController
{
    NSMutableArray *circle;
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
    
    
    // 처음 시작시 원이 역동적으로 움직이는 애니메이션이 동작한다.
    [UIView animateWithDuration:(float)circle.count / 5 delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        for(NSInteger i=0; i < circle.count; i++)
        {
            UIImageView *currentImageView;
            currentImageView = circle[i];
            currentImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }
        
    }
        completion:nil];
    
    
    // 원의 개수를 라벨에 표시해준다.
    self.circleCount.text = [NSString stringWithFormat:@"%d", [circle count]];
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
                
                
                // 게임 끝날 시
                if(circle.count == 0)
                {
                    UIStoryboard *storyboard = self.storyboard;
                    // 스토리 보드에서 뷰 컨트롤러 얻어오기
                    EndViewController *endVC = [storyboard instantiateViewControllerWithIdentifier:@"endVC"];
                    
                    // 뷰 컨트롤러 전환
                    [self presentViewController:endVC animated:YES completion:nil];
                    
                    return;
                }
                
                //UIImageView *currentImageView;
                //currentImageView = circle[arc4random() % circle.count];
                //currentImageView.transform = CGAffineTransformMakeTranslation((arc4random() % ((int)self.view.frame.size.width - WIDTH*2)),  (arc4random() % ((int)self.view.frame.size.height - HEIGHT*2)));
            }
        }
        
        
    }];
    
}

@end
