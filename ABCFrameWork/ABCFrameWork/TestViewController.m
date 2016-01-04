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
#import "TestRequestModel.h"
#import "ABCNetRequest.h"
#import "TestTableViewController.h"
#import "LCActionSheet.h"
#import "AFNetworking.h"
#import "ABCDownloadManager.h"

@interface TestViewController ()

@property (nonatomic, strong) ABCVidepPlayerController *videoController;

@property (nonatomic, strong) ABCDownloadManager *task;

@end

@implementation TestViewController

- (void)viewDidLoad {
    UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [pauseBtn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    pauseBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:pauseBtn];
    
    UIButton *resumeBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 50, 50)];
    [resumeBtn addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
    resumeBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:resumeBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self testRequest];
//    [self testVidio];
//    [self testScaleImage];
//    [self testTableView];
//    [self testActionSheet];
    [self testDownLoad];
}

- (void)testRequest {
    TestRequestModel *testModel = [[TestRequestModel alloc] init];
    testModel.city = @"beijing";
    testModel.key = @"ec1c681fdacfcc3d4dfc530981b86a82";
    
    [ABCNetOperation operationWithModel:testModel CallBack:^(id result, NSError *error) {
        
    }];
}

- (void)testScaleImage {
    ABCScaleImagesViewController *vc = [[ABCScaleImagesViewController alloc] init];
    vc.imagePaths = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"];
    vc.currentImagePath = @"2";
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)testVidio {
    NSURL *videoURL = [NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"];
    [self playVideoWithURL:videoURL];
}

- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        self.videoController = [[ABCVidepPlayerController alloc] initWithFrame:CGRectMake(0, 0, ABC_SCREEN_WIDTH, ABC_SCREEN_WIDTH*(9.0/16.0))];
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
    
    self.task = [[ABCDownloadManager alloc] init];
    [self.task downloadFileWithURLString:url cacheName:@"temp.zip" progress:^(CGFloat progress, CGFloat total) {
        DDLogDebug(@"%f,%f",progress, total);
    } success:^(AFURLSessionManager *operation, id responseObject) {
        DDLogDebug(@"%@,%@",operation, responseObject);
    } failure:^(AFURLSessionManager *operation, NSError *error) {
        DDLogDebug(@"%@,%@",operation, error);
    }];
}

- (void)pause {
    [self.task pause];
}

- (void)resume {
    NSString *url = @"https://codeload.github.com/Urinx/WriteTyper/zip/master";
    self.task = [[ABCDownloadManager alloc] init];
    
    [self.task resumeWithURLString:url Progress:^(CGFloat progress, CGFloat total) {
        DDLogDebug(@"%f,%f",progress, total);
    } success:^(AFURLSessionManager *operation, id responseObject) {
        DDLogDebug(@"%@,%@",operation, responseObject);
    } failure:^(AFURLSessionManager *operation, NSError *error) {
        DDLogDebug(@"%@,%@",operation, error);
    }];
}

@end
