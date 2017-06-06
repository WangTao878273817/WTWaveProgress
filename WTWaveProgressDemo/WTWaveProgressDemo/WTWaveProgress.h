//
//  WTWaveProgress.h
//  WTWaveProgressDemo
//
//  Created by shoule on 2017/5/26.
//  Copyright © 2017年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTWaveProgress : UIView

/**
 进度：0-1 default0
 */
@property(nonatomic,assign)float progress;

/**
 波浪颜色 default blue color
 */
@property(nonatomic,strong)UIColor *waterColor;

/**
 边框颜色 default gray color
 */
@property(nonatomic,strong)UIColor *bordColor;

/**
 波浪幅度 0-10 default 5
 */
@property(nonatomic,assign)float rangeValue;

/**
 波浪运动速度 0-3 default 1
 */
@property(nonatomic,assign)float speedValue;


/**
 初始化 
 */
-(instancetype)init;
-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame AndProgress:(float)progress AndWaterColor:(UIColor *)waterColor;

@end
