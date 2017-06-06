# WTWaveProgress
自定义波浪进度视图

//使用方法

#import "WTWaveProgress.h"

self.waveProgress=[[WTWaveProgress alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 110, 200, 200) AndProgress:0.0f AndWaterColor:[UIColor blueColor]];

[self.waveProgress setRangeValue:5.0f];

[self.waveProgress setSpeedValue:1.0f];

[self.waveProgress setWaterColor:[UIColor cyanColor]];

[self.waveProgress setBordColor:[UIColor redColor]];

[self.view addSubview:self.waveProgress];
