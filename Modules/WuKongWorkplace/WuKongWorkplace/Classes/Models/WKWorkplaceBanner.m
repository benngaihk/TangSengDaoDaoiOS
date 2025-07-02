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
        banner.cover = dictory[@"cover"] ?: @"";
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