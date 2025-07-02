//
//  WKWorkplaceBanner.m
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import "WKWorkplaceBanner.h"

@implementation WKWorkplaceBanner

+ (WKModel *)fromMap:(NSDictionary *)dictory type:(ModelMapType)type {
    WKWorkplaceBanner *banner = [WKWorkplaceBanner new];
    if (dictory) {
        banner.bannerNo = dictory[@"banner_no"] ?: @"";
        
        // 处理封面图URL，如果是相对路径则拼接完整URL
        NSString *coverPath = dictory[@"cover"] ?: @"";
        if (coverPath.length > 0 && ![coverPath hasPrefix:@"http"]) {
            // 相对路径，需要拼接baseURL
            banner.cover = [NSString stringWithFormat:@"%@%@", [WKApp shared].config.apiBaseUrl, coverPath];
        } else {
            banner.cover = coverPath;
        }
        
        banner.title = dictory[@"title"] ?: @"";
        banner.bannerDescription = dictory[@"description"] ?: @"";
        banner.jumpType = [dictory[@"jump_type"] integerValue];
        banner.route = dictory[@"route"] ?: @"";
        banner.sortNum = [dictory[@"sort_num"] integerValue];
        banner.createdAt = dictory[@"created_at"] ?: @"";
    }
    return banner;
}

- (NSDictionary *)toMap:(ModelMapType)type {
    return @{
        @"banner_no": self.bannerNo ?: @"",
        @"cover": self.cover ?: @"",
        @"title": self.title ?: @"",
        @"description": self.bannerDescription ?: @"",
        @"jump_type": @(self.jumpType),
        @"route": self.route ?: @"",
        @"sort_num": @(self.sortNum),
        @"created_at": self.createdAt ?: @""
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<WKWorkplaceBanner: %p> {bannerNo: %@, title: %@, sortNum: %ld}",
            self, self.bannerNo, self.title, (long)self.sortNum];
}

@end 