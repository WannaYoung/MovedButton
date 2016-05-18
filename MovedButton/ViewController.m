//
//  ViewController.m
//  MovedButton
//
//  Created by yang on 15/12/7.
//  Copyright © 2015年 yang. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+RandomColor.h"

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//图片间距
#define INSET 10
//每一行图片个数
#define COUNT 3
//每个图片宽高
#define ITEMWIDTH (ScreenWidth-(COUNT+1)*INSET)/COUNT

#define Duration 0.2


@interface ViewController ()
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
    
}

@property (strong , nonatomic) NSMutableArray *itemArray;
@property (strong , nonatomic) NSMutableArray *originArray;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemArray = [NSMutableArray array];
    self.originArray = [NSMutableArray array];
    
    for (int i = 0;i<15;i++)
    {
        int shang = i/COUNT;
        int yu = i%COUNT;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5.0;
        btn.backgroundColor = [UIColor randomColor];
        
        btn.frame = CGRectMake(INSET + (ITEMWIDTH+INSET)*yu, 20+INSET + (ITEMWIDTH+INSET)*shang, ITEMWIDTH, ITEMWIDTH);
        btn.tag = i;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [btn addGestureRecognizer:longGesture];
        [self.itemArray addObject:btn];
    }
    
    for (int i = 0;i<15;i++)
    {
        int shang = i/COUNT;
        int yu = i%COUNT;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(INSET + (ITEMWIDTH+INSET)*yu, 20+INSET + (ITEMWIDTH+INSET)*shang, ITEMWIDTH, ITEMWIDTH);
        btn.tag = i;
        [self.originArray addObject:btn];
    }
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    
    UIButton *btn = (UIButton *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        [UIView animateWithDuration:Duration animations:^{
            
            [self.view bringSubviewToFront:btn];
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.9;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        //NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            contain = NO;
        }
        else
        {
            [UIView animateWithDuration:Duration animations:^{
                
                CGPoint temp = CGPointZero;
                UIButton *button = _itemArray[index];
                temp = button.center;
                button.center = originPoint;
                btn.center = temp;
                originPoint = btn.center;
                contain = YES;
                
            }];
        }
        
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
                
            }
            
        } completion:^(BOOL finished)
        {
            NSMutableArray *orderArray = [NSMutableArray array];
            
            for (int i =0; i<self.originArray.count; i++)
            {
                
                UIButton *button = self.originArray[i];
                int index = [self originIndexOfPoint:button.frame.origin]+1;
                [orderArray addObject:[NSString stringWithFormat:@"%d",index]];
            }
            
            NSLog(@"%@",orderArray);
            
        }];
        
        
        
    }
    
    
}

- (int)originIndexOfPoint:(CGPoint)point
{
    int index = 0;
    
    for (int i = 0;i<self.itemArray.count;i++)
    {
        UIButton *button = self.itemArray[i];
        
        if (CGPointEqualToPoint(button.frame.origin, point))
        {
            index = (int)button.tag;
        }
    }
    return index;
}


- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<_itemArray.count;i++)
    {
        UIButton *button = _itemArray[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}



@end

