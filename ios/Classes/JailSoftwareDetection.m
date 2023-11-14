//
//  JailSoftwareDetection.m
//  jail_guard
//
//  Created by yulong mei on 2023/11/13.
//

#import "JailSoftwareDetection.h"

@implementation JailSoftwareDetection

+ (bool)start {
//    Class LSApplicationWorkspace_Class = NSClassFromString(@"LSApplicationWorkspace");
//    NSObject *workspace = [LSApplicationWorkspace_Class performSelector:NSSelectorFromString(@"defaultWorkspace")];
//    NSArray *appList = [workspace performSelector:NSSelectorFromString(@"allApplications")];
//    NSString *appStr = @"";
//    for (id app in appList) {
//        NSString *appId = [app performSelector:NSSelectorFromString(@"applicationIdentifier")];
//        if (appStr.length) {
//            appStr = [appStr stringByAppendingFormat:@"|%@", appId];
//        } else {
//            appStr = [appStr stringByAppendingString:appId];
//        }
//    }
//    NSArray *appIds = @[@"Cydia", @"Sileo", @"Zebra", @"AFC2", @"AppSync", @"LibertyLite", @"Liberty Lite", @"OTADisabler"];
//    for (NSString *tempStr in appIds) {
//        if ([appStr.uppercaseString containsString:tempStr.uppercaseString]) {
//            return YES;
//        }
//    }
    return false;
}

@end
