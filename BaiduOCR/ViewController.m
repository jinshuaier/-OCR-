//
//  ViewController.m
//  BaiduOCR
//
//  Created by 牛新怀 on 2017/8/10.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ViewController.h"
#import "BaiduAIPictureIdentifyView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<PictureIdentifyDelegate,AipOcrDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) BaiduAIPictureIdentifyView * pictureIdentifyView;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *topArray;
@property (nonatomic, strong) NSMutableArray *widthArray;
@property (nonatomic, strong) NSMutableArray *wordsArray;
@property (nonatomic, strong) UIImageView *imageNet;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *songitem;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.heightArray = [NSMutableArray array];
    self.leftArray = [NSMutableArray array];
    self.topArray = [NSMutableArray array];
    self.widthArray = [NSMutableArray array];
    self.wordsArray = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    [self initWithView];
    
}
- (void)initWithView{
    
    //添加图片
    self.imageNet = [[UIImageView alloc] init];
    self.imageNet.frame = CGRectMake(30, 30, 600, 300);
    self.imageNet.contentMode = UIViewContentModeScaleAspectFit;
//    [self.imageNet setImageWithURL:[NSURL URLWithString:@"http://39.98.196.173:8081/tms/10/c4/10c47cdfcab30d2d7809169174aa2c41.png"] placeholder:nil];
    
    [self.imageNet setImageWithURL:[NSURL URLWithString:@"http://39.98.196.173:8081/tms/10/c4/10c47cdfcab30d2d7809169174aa2c41.png"] placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        NSLog(@"宽：%f, 高：%f", image.size.width, image.size.height);
    } ];
    
    
  
    


    [self.view addSubview:self.imageNet];
    
    
    UIButton *btnIamge = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnIamge.frame = CGRectMake(7,383 - 64, 50,50);
    btnIamge.backgroundColor = [UIColor redColor];
    [btnIamge addTarget:self action:@selector(btnImage:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnIamge];
    
    
    
//    UIImage *image = [NetWorkTool resizeImage:imageNet.image];
//
//    [self NetWithImage:image];
    
//    [self NetWithImage:imageNet.image]; //加载网络图片，精确到位置
}


#pragma mark -- 点击
- (void)btnImage:(UIButton *)sender {
    UIImage *images = [NetWorkTool resizeImage:self.imageNet.image];

    [self NetWithImage:images];
}

- (void)NetWithImage:(UIImage *)image {
    //这里是网络图片
//    [NetWorkTool postNetWorkWithImage:nil types:CardTypeCarCard withURL:@"http://39.98.196.173:8081/tms/10/c4/10c47cdfcab30d2d7809169174aa2c41.png" paramaters:nil success:^(id object) {
//        NSLog(@"---返回的图片信息%@",object);
//        NSArray *resultArray = object[@"words_result"];
//        for (int i = 0; i < resultArray.count; i ++) {
//            [self.heightArray addObject:resultArray[i][@"location"][@"height"]];
//            [self.leftArray addObject:resultArray[i][@"location"][@"left"]];
//            [self.topArray addObject:resultArray[i][@"location"][@"top"]];
//            [self.widthArray addObject:resultArray[i][@"location"][@"width"]];
//            [self.wordsArray addObject:resultArray[i][@"words"]];
//        }
//        NSLog(@"heightArray=%@,leftArray=%@,topArray=%@,widthArray=%@,wordsArray=%@",self.heightArray,self.leftArray,self.topArray,self.widthArray,self.wordsArray);
//
//        //添加手势按钮
//        for (int j = 0; j < self.wordsArray.count; j ++) {
//            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//            btn.frame = CGRectMake(7,383, 492,54);
//            btn.backgroundColor = [UIColor redColor];
//            [self.view addSubview:btn];
//        }
//
//
//    } failure:^(id failure) {
//
//        [self ocrOnFail:failure];
//    }];
    
    //这里是加载图片
    [NetWorkTool postNetWorkWithImage:image types:CardTypeCarCard withURL:nil paramaters:nil success:^(id object) {
        NSLog(@"%@",object);
        NSArray *resultArray = object[@"words_result"];
        for (int i = 0; i < resultArray.count; i ++) {
            [self.heightArray addObject:resultArray[i][@"location"][@"height"]];
            [self.leftArray addObject:resultArray[i][@"location"][@"left"]];
            [self.topArray addObject:resultArray[i][@"location"][@"top"]];
            [self.widthArray addObject:resultArray[i][@"location"][@"width"]];
            [self.wordsArray addObject:resultArray[i][@"words"]];
        }
        NSLog(@"heightArray=%@,leftArray=%@,topArray=%@,widthArray=%@,wordsArray=%@",self.heightArray,self.leftArray,self.topArray,self.widthArray,self.wordsArray);
        //添加手势按钮
        for (int j = 0; j < self.wordsArray.count; j ++) {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(([self.leftArray[j] floatValue] + self.imageNet.origin.x) , ([self.topArray[j] floatValue] + self.imageNet.origin.y), [self.widthArray[j] floatValue] ,[self.heightArray[j] floatValue]);
            btn.tag = j;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.backgroundColor = [UIColor yellowColor];
            [self.view addSubview:btn];
            NSLog(@"--- %@",btn);
        }
    } failure:^(id failure) {
        
        [self ocrOnFail:failure];
    }];
}

#pragma mark -- 点读
- (void)btnAction:(UIButton *)sender {
    
//    NSString *urlStr = self.wordsArray[sender.tag];
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@",@"hello"];
//    NSString*hString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
    AVSpeechSynthesizer *synth2 = [[AVSpeechSynthesizer alloc] init];

    AVSpeechUtterance *utterance1 = [AVSpeechUtterance speechUtteranceWithString:self.wordsArray[sender.tag]];//播放语

    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];//汉语

    utterance1.voice = voice;

    utterance1.rate = 0.3;//语速

    [synth2 speakUtterance:utterance1];//播放

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        //AVPlayerItemStatus *status = item.status;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            [self.player play];
            //对播放界面的一些操作，时间、进度等
        }
    }
}


@end
