//
//  ViewController.m
//  BGGiftDemo
//
//  Created by apple on 8/28/16.
//  Copyright © 2016 bingo. All rights reserved.
//

#import "ViewController.h"
#import "DMHeartFlyView.h"
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *heart;
@property (nonatomic, assign) CGFloat heartSize;

@property (nonatomic, strong) NSArray *fireworksArray;

@property (nonatomic, weak) CALayer *fireworksL;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)playButton:(UIButton *)sender {
    _heartSize = 36;
    
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(_heartSize + _heartSize/2.0, self.view.bounds.size.height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];
    
    // button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [sender.layer addAnimation:btnAnimation forKey:@"SHOW"];
}
- (IBAction)giftButton:(UIButton *)sender {
    CGFloat durTime = 3.0;
    
    UIImageView *porsche918 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"porsche"]];
    
    //设置汽车初始位置
    porsche918.frame = CGRectMake(0, 0, 0, 0);
    [self.view addSubview:porsche918];
    
    //给汽车添加动画
    [UIView animateWithDuration:durTime animations:^{
        
        porsche918.frame = CGRectMake(XJScreenW * 0.5 - 100, XJScreenH * 0.5 - 100 * 0.5, 240, 120);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        [UIView animateWithDuration:0.5 animations:^{
            porsche918.alpha = 0;
        } completion:^(BOOL finished) {
            [porsche918 removeFromSuperview];
        }];
    });
    
    
    
    //烟花
    
    CALayer *fireworksL = [CALayer layer];
    fireworksL.frame = CGRectMake((XJScreenW - 250) * 0.5, 100, 250, 50);
    fireworksL.contents = (id)[UIImage imageNamed:@"gift_fireworks_0"].CGImage;
    [self.view.layer addSublayer:fireworksL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            //没找到设置透明度的方法，有创意可以自己写
            //            fireworksL.alpha = 0;
        } completion:^(BOOL finished) {
            [fireworksL removeFromSuperlayer];
        }];
    });
    _fireworksL = fireworksL;
    
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int i = 1; i < 3; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gift_fireworks_%d",i]];
        [tempArray addObject:image];
    }
    _fireworksArray = tempArray;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update) userInfo:nil repeats:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}


static int _fishIndex = 0;

- (void)update {
    NSLog(@"..");
    _fishIndex++;
    
    if (_fishIndex > 1) {
        _fishIndex = 0;
    }
    UIImage *image = self.fireworksArray[_fishIndex];
    _fireworksL.contents = (id)image.CGImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
