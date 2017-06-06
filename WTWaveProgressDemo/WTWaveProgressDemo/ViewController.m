//
//  ViewController.m
//  WTWaveProgressDemo
//
//  Created by shoule on 2017/5/26.
//  Copyright © 2017年 SaiDicaprio. All rights reserved.
//

#import "ViewController.h"
#import "WTWaveProgress.h"

@interface ViewController ()

@property(nonatomic,strong)WTWaveProgress *waveProgress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn=[UIButton new];
    btn.frame=CGRectMake(self.view.bounds.size.width/2-100, 50, 200, 50);
    [btn setTitle:@"CreateView" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UISlider *slider=[[UISlider alloc]init];
    slider.frame=CGRectMake(self.view.bounds.size.width/2-100, 350, 200, 50);
    slider.minimumValue=0.0f;
    slider.maximumValue=1.0f;
    slider.value=0.0f;
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
}

-(void)btnClick:(UIButton *)btn
{
    self.waveProgress=[[WTWaveProgress alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 110, 200, 200) AndProgress:0.0f AndWaterColor:[UIColor blueColor]];
    [self.waveProgress setRangeValue:5.0f];
    [self.waveProgress setSpeedValue:1.0f];
    [self.waveProgress setWaterColor:[UIColor cyanColor]];
    [self.waveProgress setBordColor:[UIColor redColor]];
    [self.view addSubview:self.waveProgress];
    
}

-(void)sliderChange:(UISlider *)slider
{
    [self.waveProgress setProgress:slider.value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
