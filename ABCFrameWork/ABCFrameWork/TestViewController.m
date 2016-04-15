//
//  TestViewController.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "TestViewController.h"
#import "ABCVidepPlayerController.h"
#import "ABCMosiacDataModel.h"
#import "ABCMosiacView.h"
#import "ABCCarouselView.h"
#import "ABCScaleImagesViewController.h"
#import "ABCNetRequest.h"
#import "TestTableViewController.h"
#import "LCActionSheet.h"
#import "AFNetworking.h"
#import "LCProgressHUD.h"
#import "HSDownloadManager.h"
#import "UIView+Loading.h"
#import "ABCRoundImageView.h"
#import "TestNetOperation.h"
#import <AVFoundation/AVFoundation.h>

@interface TestViewController ()

@property (nonatomic, strong) ABCVidepPlayerController *videoController;

@end

@implementation TestViewController

- (void)viewDidLoad {
    UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [pauseBtn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    pauseBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:pauseBtn];
    
    ABCRoundImageView *imageView = [ABCRoundImageView roundImageViewWithImage:[UIImage imageNamed:@"001"]];
    imageView.frame = CGRectMake(150, 150, 100, 50);
//    [imageView sizeToFit];
    [self.view addSubview:imageView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self testRequest];
    [self testVidio];
//    [self testScaleImage];
//    [self testTableView];
//    [self testActionSheet];
//    [self testDownLoad];
//    [self testHud];
//    [self testLoading];
//    [self testReachability];
}

- (void)testRequest {
    [TestNetOperation operationWithCallBack:^(id result, NSError *error) {
        NSLog(@"%@, %@",result, error);
    }];
    
    [TestNetOperation operationCacheWithBlock:^(NSDictionary *result, NSError *error) {
        NSLog(@"%@, %@", result, error);
    }];
}

- (void)testScaleImage {
    ABCScaleImagesViewController *vc = [[ABCScaleImagesViewController alloc] init];
    vc.imagePaths = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"];
    vc.currentImagePath = @"2";
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)testVidio {
    NSURL *videoURL = [NSURL URLWithString:@"https://player.vimeo.com/video/143506410"];
    [self playVideoWithURL:videoURL];
    
//    NSDictionary *opts = @{AVURLAssetPreferPreciseDurationAndTimingKey: [NSNumber numberWithBool:NO]};
//    
//    AVURLAsset *urlAssert = [AVURLAsset URLAssetWithURL:videoURL options:opts];
//    
//    //视频长度
//    float second = urlAssert.duration.value/urlAssert.duration.timescale;
//    
//    NSLog(@"%f",second);
//    
//    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAssert];
//    
//    NSError *error = nil;
//    CMTime time = CMTimeMake(10,10);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
//    CMTime actucalTime; //缩略图实际生成的时间
//    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
//    if (error) {
//        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
//    }
//    CMTimeShow(actucalTime);
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    UIImageWriteToSavedPhotosAlbum(image,nil, nil,nil);
//    CGImageRelease(cgImage);
    
//    NSLog(@"视频截取成功");
}

- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        self.videoController = [[ABCVidepPlayerController alloc] initWithFrame:CGRectMake(0, 0, ABC_SCREEN_WIDTH, ABC_SCREEN_WIDTH*(9.0/16.0))title:@"12121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212"];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
    self.videoController.startTime = 8.71794891;
    [self.videoController startPlay];
}

- (void)testTableView {
    TestTableViewController *tableVC = [[TestTableViewController alloc] init];
    [self.navigationController pushViewController:tableVC animated:YES];
}

- (void)testActionSheet {
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"hello" buttonTitles:@[@"1", @"2"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
        
    }];
    [sheet show];
}

- (void)testDownLoad {
    NSString *url = @"https://codeload.github.com/Urinx/WriteTyper/zip/master";
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        DDLogInfo(@"%f", progress);
    } state:^(DownloadState state) {
        
    }];
}

- (void)pause {
    
}

- (void)testHud {
    [LCProgressHUD showSuccess:@"123"];
}

- (void)testLoading {
    if (self.view.isLoading) {
        [self.view endLoading];
    }else {
        [self.view beginLoading];
    }
}

- (void)testReachability {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
