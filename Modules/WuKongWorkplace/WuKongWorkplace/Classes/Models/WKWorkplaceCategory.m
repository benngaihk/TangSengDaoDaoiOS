//
//  WKWorkplaceCategory.m
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import "WKWorkplaceCategory.h"

@implementation WKWorkplaceCategory

+ (WKModel *)fromMap:(NSDictionary *)dictory type:(ModelMapType)type {
    WKWorkplaceCategory *category = [WKWorkplaceCategory new];
    if (dictory) {
        category.categoryNo = dictory[@"category_no"] ?: @"";
        category.name = dictory[@"name"] ?: @"";
        category.sortNum = [dictory[@"sort_num"] integerValue];
    }
    return category;
}

- (NSDictionary *)toMap:(ModelMapType)type {
    return @{
        @"category_no": self.categoryNo ?: @"",
        @"name": self.name ?: @"",
        @"sort_num": @(self.sortNum)
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<WKWorkplaceCategory: %p> {categoryNo: %@, name: %@, sortNum: %ld}",
            self, self.categoryNo, self.name, (long)self.sortNum];
}

@end 