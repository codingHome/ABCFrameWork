//
//  AppDelegate.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"
#import "TestModel.h"
#import "ABCDB.h"
#import "YYModel.h"
#import "ABCZipManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@",NSHomeDirectory());
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ABC_SCREEN_WIDTH, ABC_SCREEN_HEIGHT)];
    self.window.backgroundColor = [UIColor whiteColor];
    
    TestViewController *vc = [[TestViewController alloc] init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = navi;
    
    [self.window makeKeyAndVisible];
    
//    [self testDB];
//    [self testZip];
    
    return YES;
}

- (void)testDB {
    NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/data.db", NSHomeDirectory()];
    
    NSLog(@"%@",dbPath);
    
    [[ABCDB sharedDB] initDBPath:dbPath];
    [[ABCDB sharedDB] createTable:[TestModel class]];
    
    for (int i = 0; i < 4; i++) {
        dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_PRIORITY_DEFAULT);
        
        dispatch_async(queue, ^{
            NSDictionary *dic = @{@"name":@"robert",
                                  @"age":@"25",
                                  @"telNumber":@"110"};
            
            TestModel *dbModel = [TestModel yy_modelWithJSON:dic];
            
            [[ABCDB sharedDB] insertTable:[TestModel class] object:dbModel];
        });
    }
    
}

- (void)testZip {
//    NSString *filePath = @"/Users/yangqihui/Desktop/main.m";
//    [[ABCZipManager sharedZipManager] zipFile:filePath password:@"123" complete:^(BOOL result, NSString *errorMessage) {
//        NSLog(@"%d,%@",result, errorMessage);
//    }];

    NSString *zipFilePath = @"/Users/yangqihui/Desktop/main.zip";
    [[ABCZipManager sharedZipManager] unZIpFile:zipFilePath password:@"123" complete:^(BOOL result, NSString *errorMessage) {
        NSLog(@"%d,%@",result, errorMessage);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
