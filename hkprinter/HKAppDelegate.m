//
//  HKAppDelegate.m
//  hkprinter
//
//  Created by akwei on 13-7-10.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKAppDelegate.h"
#import "HKViewController.h"
#import "HKPOSTable.h"
#import "HKSocket.h"

@implementation HKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.viewController = [[HKViewController alloc] initWithNibName:@"HKViewController" bundle:nil];
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
//    [self testHKPOSTable];
    [self testSocket];
    return YES;
}

-(void)testHKPOSTable{
    HKPOSTable* table = [[HKPOSTable alloc] init];
    HKPOSRow* row = [[HKPOSRow alloc] init];
    HKPOSColumn* col0 = [[HKPOSColumn alloc] init];
    col0.maxWordCount = 10;
    col0.alignment = HKPOSAlignmentLeft;
    col0.text = @"test my gdtest my gdtest my gdtest my gd";
    [row addColumn:col0];
    
    HKPOSColumn* spaceCol = [[HKPOSColumn alloc] init];
    spaceCol.maxWordCount=4;
    spaceCol.text = @"        ";
    [row addColumn:spaceCol];
    
    HKPOSColumn* col1 = [[HKPOSColumn alloc] init];
    col1.maxWordCount = 10;
    col1.alignment = HKPOSAlignmentRight;
    col1.text = @"wy test my 啊，哈哈哈哈，我来了，大家都来测试以下好玩不";
    [row addColumn:col1];
    [table addRow:row];
    NSString* text = [table getText];
    printf("%s",[text UTF8String]);
}

-(void)testSocket{
    HKSocket* socket = [[HKSocket alloc] initWithHost:@"192.168.1.104" port:9900 timeout:0];
    @try {
        [socket open];
        NSString* s= @"wy test my 啊，哈哈哈哈，我来了，大家都来测试以下好玩不";
        NSData* data = [s dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:data blockSize:2];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [socket close];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
