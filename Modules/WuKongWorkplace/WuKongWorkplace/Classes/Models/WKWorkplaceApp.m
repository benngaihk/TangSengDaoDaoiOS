//
//  WKWorkplaceApp.m
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import "WKWorkplaceApp.h"

@implementation WKWorkplaceApp

+ (WKModel *)fromMap:(NSDictionary *)dictory type:(ModelMapType)type {
    WKWorkplaceApp *app = [WKWorkplaceApp new];
    if (dictory) {
        app.appId = dictory[@"app_id"] ?: @"";
        app.sortNum = [dictory[@"sort_num"] integerValue];
        app.icon = dictory[@"icon"] ?: @"";
        app.name = dictory[@"name"] ?: @"";
        app.appDescription = dictory[@"description"] ?: @"";
        app.appCategory = dictory[@"app_category"] ?: @"";
        app.status = [dictory[@"status"] integerValue];
        app.jumpType = [dictory[@"jump_type"] integerValue];
        app.appRoute = dictory[@"app_route"] ?: @"";
        app.webRoute = dictory[@"web_route"] ?: @"";
        app.isPaidApp = [dictory[@"is_paid_app"] integerValue];
        app.isAdded = [dictory[@"is_added"] integerValue];
    }
    return app;
}

- (NSDictionary *)toMap:(ModelMapType)type {
    return @{
        @"app_id": self.appId ?: @"",
        @"sort_num": @(self.sortNum),
        @"icon": self.icon ?: @"",
        @"name": self.name ?: @"",
        @"description": self.appDescription ?: @"",
        @"app_category": self.appCategory ?: @"",
        @"status": @(self.status),
        @"jump_type": @(self.jumpType),
        @"app_route": self.appRoute ?: @"",
        @"web_route": self.webRoute ?: @"",
        @"is_paid_app": @(self.isPaidApp),
        @"is_added": @(self.isAdded)
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<WKWorkplaceApp: %p> {appId: %@, name: %@, sortNum: %ld}",
            self, self.appId, self.name, (long)self.sortNum];
}

@end 