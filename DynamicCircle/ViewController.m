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
        UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake( (arc4random() % (320-WIDTH)),  (arc4random() % (640-HEIGHT)), WIDTH, HEIGHT)];
        [currentImageView setImage:[UIImage imageNamed:@"circle.png"]];
        [circle addObject:currentImageView];
        [self.view addSubview:circle[i]];
    }
    

    
    [UIView animateWithDuration:2.0 animations:^{
        for(NSInteger i=0; i < 10; i++)
        {
            UIImageView *currentImageView;
            currentImageView = circle[i];
            currentImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }
    }
        completion:^(BOOL finished){
                [UIView animateWithDuration:2.0 animations:^{
                    for(NSInteger i=0; i < 10; i++)
                    {
                     UIImageView *currentImageView;
                     currentImageView = circle[i];
                     currentImageView.transform = CGAffineTransformMakeScale(1, 1);
                 }
        }];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
