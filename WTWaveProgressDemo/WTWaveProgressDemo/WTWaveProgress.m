//
//  WTWaveProgress.m
//  WTWaveProgressDemo
//
//  Created by shoule on 2017/5/26.
//  Copyright © 2017年 SaiDicaprio. All rights reserved.
//

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

#define DEFAULT_WATERCOLOR [UIColor colorWithRed:0 green:0 blue:255.0f alpha:1.0f]
#define DEFAULT_SELFHEIGHT 100.0f
#define DEFAULT_FREAM CGRectMake(0.0f, 0.0f, DEFAULT_SELFHEIGHT, DEFAULT_SELFHEIGHT)

#import "WTWaveProgress.h"

@interface WTWaveProgress ()

@property(nonatomic,assign)float selfWidth;
@property(nonatomic,assign)float selfHeight;
@property(nonatomic,assign)float waveViewWidth;
@property(nonatomic,strong)CAShapeLayer *arcLayer;
@property(nonatomic,strong)UILabel *progressLab;
@property(nonatomic,strong)UIView *waveView;

@property(nonatomic,strong)CAShapeLayer *waterLayer;
@property(nonatomic,strong)CADisplayLink *waveDisplayLink;
@property(nonatomic,assign)float offset;

@end

@implementation WTWaveProgress

-(instancetype)init
{
    return [self initWithFrame:DEFAULT_FREAM AndProgress:_progress AndWaterColor:DEFAULT_WATERCOLOR];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame AndProgress:_progress AndWaterColor:DEFAULT_WATERCOLOR];
}

-(instancetype)initWithFrame:(CGRect)frame AndProgress:(float)progress AndWaterColor:(UIColor *)waterColor
{
    if(frame.size.height != frame.size.width  || frame.size.width<DEFAULT_SELFHEIGHT)frame=DEFAULT_FREAM;
    self=[super initWithFrame:frame];
    
    if(self){
        [self createView];
        self.progress=progress;
        self.waterColor=waterColor;
        [self startAnimation];
    }
    
    return self;
}

/**
 创建视图
 */
-(void)createView
{

    UIBezierPath *arcPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.selfWidth/2, self.selfHeight/2) radius:self.selfHeight/2-10 startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.arcLayer=[[CAShapeLayer alloc]init];
    self.arcLayer.lineWidth=3.0f;
    self.arcLayer.lineCap=kCALineCapRound;
    self.arcLayer.lineJoin=kCALineJoinRound;
    self.arcLayer.strokeColor=self.bordColor.CGColor;
    self.arcLayer.strokeEnd=1.0f;
    self.arcLayer.strokeStart=0.0f;
    self.arcLayer.path=arcPath.CGPath;
    self.arcLayer.fillColor=[UIColor clearColor].CGColor;
    [self.layer addSublayer:self.arcLayer];
    
    self.progressLab=[UILabel new];
    self.progressLab.center=CGPointMake(self.selfWidth/2, self.selfHeight/2);
    self.progressLab.bounds=CGRectMake(0, 0, self.selfWidth-20, self.selfHeight-20);
    self.progressLab.text=@"0%";
    self.progressLab.textAlignment=NSTextAlignmentCenter;
    self.progressLab.textColor=[UIColor blackColor];
    self.progressLab.font=[UIFont boldSystemFontOfSize:[self adaptiveTextSize]];
    [self addSubview:self.progressLab];
    
    self.waveView=[UIView new];
    self.waveView.center=CGPointMake(self.selfWidth/2, self.selfHeight/2);
    self.waveView.bounds=CGRectMake(0, 0, self.selfWidth-20, self.selfHeight-20);
    self.waveView.backgroundColor=self.backgroundColor;
    self.waveView.layer.cornerRadius=(self.selfWidth-20)/2;
    self.waveView.layer.masksToBounds=YES;
    [self addSubview:self.waveView];
    
    [self bringSubviewToFront:self.progressLab];
    [self sendSubviewToBack:self.waveView];
}

-(void)setBordColor:(UIColor *)bordColor
{
    if(bordColor==nil || ![bordColor isKindOfClass:[UIColor class]])return;
    self.arcLayer.strokeColor=(_bordColor=bordColor).CGColor;
}

-(void)setProgress:(float)progress
{
    if(progress<0.0f || progress>1.0f)progress=0.0f;
    _progress=progress;
    [self stopAnimation];
    [self startAnimation];
    [self setTextForLab];
}

/**
 开始动画
 */
-(void)startAnimation
{
    [self.waveView.subviews	makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setRunData)];
    [_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

/**
 停止动画
 */
-(void)stopAnimation
{
    [_waveDisplayLink invalidate];
    _waveDisplayLink=nil;
}

/**
 设置波浪
 */
-(void)setRunData
{
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 50.0f);
    
    self.offset+=self.speedValue;
    if(self.offset>=self.waveViewWidth)self.offset-=self.waveViewWidth;
    
    float resolveProgrees=self.progress;
    if(resolveProgrees>0.95f)resolveProgrees=0.95f;
    if(resolveProgrees<0.05f)resolveProgrees=0.05f;
    
    float progreesHeight=(1-resolveProgrees)*self.waveViewWidth;

    for(NSInteger x= 0 ; x<= self.waveViewWidth ; x++){

        float y=self.rangeValue*sinf(2*M_PI/self.waveViewWidth*x+2*M_PI/self.waveViewWidth*self.offset)+progreesHeight;
        CGPathAddLineToPoint(path, nil, x, y);
        
    }
    
    CGPathAddLineToPoint(path, nil, self.waveViewWidth, self.waveViewWidth);
    CGPathAddLineToPoint(path, nil, 0, self.waveViewWidth);
    CGPathAddLineToPoint(path, nil, 0, progreesHeight);
    CGPathCloseSubpath(path);
    self.waterLayer.path=path;
    [self.waveView.layer addSublayer:self.waterLayer];
    CGPathRelease(path);
}


/**
 设置文本
 */
-(void)setTextForLab
{
    self.progressLab.textColor=[UIColor colorWithWhite:_progress alpha:0.7];
    NSInteger progressInteger=_progress*100;
    self.progressLab.text=[NSString stringWithFormat:@"%@%%",@(progressInteger)];
}

/**
 适配文字大小
 */
-(float)adaptiveTextSize
{
    NSInteger pulsValue=(self.selfWidth-DEFAULT_SELFHEIGHT)/10.0f;
    return 15.0f+pulsValue;
}


#pragma mark Lazy Load

-(UIColor *)waterColor
{
    if(_waterColor==nil) return _waterColor=DEFAULT_WATERCOLOR;
    return _waterColor;
}

-(float)selfWidth
{
    if(self.bounds.size.width<DEFAULT_SELFHEIGHT) return _selfWidth=DEFAULT_SELFHEIGHT;
    return _selfWidth=self.bounds.size.width;
}

-(float)selfHeight
{
    if(self.bounds.size.height<DEFAULT_SELFHEIGHT) return _selfHeight=DEFAULT_SELFHEIGHT;
    return _selfHeight=self.bounds.size.height;
}

-(float)waveViewWidth
{
    if(_waveViewWidth==0.0f) return _waveViewWidth=self.selfHeight-20.0f;
    return _waveViewWidth;
}

-(float)rangeValue
{
    if(_rangeValue<=0.0f || _rangeValue>10.0f) return _rangeValue=5.0f;
    return _rangeValue;
}

-(float)speedValue
{
    if(_speedValue<=0.0f || _speedValue>3.0f) return _speedValue=1.0f;
    return _speedValue;
}

-(CAShapeLayer *)waterLayer
{
    if(!_waterLayer){
        _waterLayer=[CAShapeLayer layer];
        _waterLayer.frame=self.waveView.bounds;
        _waterLayer.fillColor=_waterColor.CGColor;
        _waterLayer.strokeColor=[UIColor clearColor].CGColor;
        _waterLayer.lineWidth=0.01f;
        
    }
    
    return _waterLayer;
}


@end
