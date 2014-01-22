//
//  ViewController.m
//  DynamicCircle
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#define WIDTH 100
#define HEIGHT 100

@interface ViewController ()


@end

@implementation ViewController
{
    NSMutableArray *circle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    circle = [[NSMutableArray alloc] init];
    for(NSInteger i=0; i < 10; i++)
    {
        UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake( (arc4random() % ((int)self.view.frame.size.width - WIDTH)),  (arc4random() % ((int)self.view.frame.size.height - HEIGHT)), WIDTH, HEIGHT)];
        [currentImageView setImage:[UIImage imageNamed:@"circle.png"]];
        [circle addObject:currentImageView];
        [self.view addSubview:circle[i]];
    }
    
    

    [UIView animateWithDuration:(float)circle.count / 5 delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAutoresizingFlexibleWidth animations:^{
        for(NSInteger i=0; i < circle.count; i++)
        {
            if(circle[i] != nil)
            {
                UIImageView *currentImageView;
                currentImageView = circle[i];
                currentImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            }
        }

    }
        completion:nil];
    
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
    
    
    
    
    [UIView animateWithDuration:(float)circle.count / 5 animations:^{
        
        for(NSInteger i=0; i < circle.count; i++)
        {
            UIImageView *currentImageView;
            currentImageView = circle[i];
            if(CGRectContainsPoint(currentImageView.frame, point))
            {
                [[circle objectAtIndex:i] removeFromSuperview];
                [circle removeObjectAtIndex:i];
                NSLog(@"%d", [circle count]);
                
                if(circle.count == 0)
                    return;
                
                //UIImageView *currentImageView;
                currentImageView = circle[arc4random() % circle.count];
                currentImageView.transform = CGAffineTransformMakeTranslation((arc4random() % ((int)self.view.frame.size.width - WIDTH*2)),  (arc4random() % ((int)self.view.frame.size.height - HEIGHT*2)));
            }
        }
        
        
    }];
    
    
    

}

@end
