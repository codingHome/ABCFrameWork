//
//  TestViewController.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/9.
//  Copyright © 2015年 NationSky. All rights reserved.
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

@interface TestViewController ()

@property (nonatomic, strong) ABCVidepPlayerController *videoController;

@end

@implementation TestViewController

- (void)viewDidLoad {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testRequest];
//    [self testVidio];
//    [self testScaleImage];
//    [self testTableView];
//    [self testActionSheet];
    
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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

@end
