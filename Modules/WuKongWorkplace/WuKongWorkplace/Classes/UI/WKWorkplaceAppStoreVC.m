//
//  WKWorkplaceAppStoreVC.m
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import "WKWorkplaceAppStoreVC.h"
#import "WKWorkplaceAPI.h"
#import "WKWorkplaceManager.h"
#import "WKWorkplaceApp.h"
#import "WKWorkplaceCategory.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface WKWorkplaceAppStoreVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISegmentedControl *categorySegment;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<WKWorkplaceCategory *> *categories;
@property (nonatomic, strong) NSArray<WKWorkplaceApp *> *apps;
@property (nonatomic, assign) NSInteger selectedCategoryIndex;

@end

@implementation WKWorkplaceAppStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadCategories];
}

#pragma mark - UI Setup

- (void)setupUI {
    // 使用系统背景色支持深色模式
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    self.title = @"应用商店";
    
    // 分类选择器容器
    UIView *segmentContainer = [[UIView alloc] init];
    if (@available(iOS 13.0, *)) {
        segmentContainer.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    } else {
        segmentContainer.backgroundColor = [UIColor whiteColor];
    }
    segmentContainer.layer.cornerRadius = 12;
    segmentContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    segmentContainer.layer.shadowOffset = CGSizeMake(0, 2);
    segmentContainer.layer.shadowRadius = 4;
    segmentContainer.layer.shadowOpacity = 0.1;
    [self.view addSubview:segmentContainer];
    
    // 分类选择器
    self.categorySegment = [[UISegmentedControl alloc] init];
    if (@available(iOS 13.0, *)) {
        self.categorySegment.selectedSegmentTintColor = [UIColor systemBlueColor];
        self.categorySegment.backgroundColor = [UIColor clearColor];
        [self.categorySegment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor labelColor]} forState:UIControlStateNormal];
        [self.categorySegment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    } else {
        self.categorySegment.tintColor = [UIColor systemBlueColor];
    }
    [self.categorySegment addTarget:self action:@selector(categoryChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentContainer addSubview:self.categorySegment];
    
    [segmentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(16);
        } else {
            make.top.equalTo(self.view).offset(80); // 导航栏高度 + 间距
        }
        make.left.right.equalTo(self.view).inset(16);
    }];
    
    [self.categorySegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(segmentContainer).inset(12);
        make.height.mas_equalTo(32);
    }];
    
    // 应用列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (@available(iOS 13.0, *)) {
        self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    } else {
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 67, 0, 0); // 对齐图标
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AppCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentContainer.mas_bottom).offset(16);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Data Loading

- (void)loadCategories {
    [[WKWorkplaceAPI sharedInstance] getCategories].then(^(NSArray<WKWorkplaceCategory *> *categories) {
        self.categories = categories ?: @[];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCategorySegment];
            if (self.categories.count > 0) {
                [self loadAppsForCategory:0];
            }
        });
        return categories;
    }).catch(^(NSError *error) {
        NSLog(@"加载分类失败: %@", error.localizedDescription);
    });
}

- (void)updateCategorySegment {
    [self.categorySegment removeAllSegments];
    
    for (NSInteger i = 0; i < self.categories.count; i++) {
        WKWorkplaceCategory *category = self.categories[i];
        [self.categorySegment insertSegmentWithTitle:category.name atIndex:i animated:NO];
    }
    
    if (self.categories.count > 0) {
        self.categorySegment.selectedSegmentIndex = 0;
        self.selectedCategoryIndex = 0;
    }
}

- (void)loadAppsForCategory:(NSInteger)categoryIndex {
    if (categoryIndex >= self.categories.count) return;
    
    WKWorkplaceCategory *category = self.categories[categoryIndex];
    [[WKWorkplaceAPI sharedInstance] getAppsInCategory:category.categoryNo].then(^(NSArray<WKWorkplaceApp *> *apps) {
        self.apps = apps ?: @[];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return apps;
    }).catch(^(NSError *error) {
        NSLog(@"加载应用失败: %@", error.localizedDescription);
    });
}

#pragma mark - Actions

- (void)categoryChanged:(UISegmentedControl *)sender {
    self.selectedCategoryIndex = sender.selectedSegmentIndex;
    [self loadAppsForCategory:self.selectedCategoryIndex];
}

- (void)toggleButtonTapped:(UIButton *)sender {
    NSInteger row = sender.tag;
    if (row >= self.apps.count) return;
    
    WKWorkplaceApp *app = self.apps[row];
    [[WKWorkplaceManager sharedManager] toggleApp:app].then(^(id result) {
        // 切换成功，更新状态
        app.isAdded = !app.isAdded;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
        return result;
    }).catch(^(NSError *error) {
        NSLog(@"切换应用状态失败: %@", error.localizedDescription);
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell" forIndexPath:indexPath];
    
    // 设置cell背景色
    if (@available(iOS 13.0, *)) {
        cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    // 移除之前的子视图（除了系统默认的）
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag >= 1000) {
            [view removeFromSuperview];
        }
    }
    
    WKWorkplaceApp *app = self.apps[indexPath.row];
    
    // 应用图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.tag = 1000;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.clipsToBounds = YES;
    iconView.layer.cornerRadius = 12; // 更大的圆角，符合App Store风格
    iconView.layer.borderWidth = 0.5;
    if (@available(iOS 13.0, *)) {
        iconView.layer.borderColor = [UIColor tertiaryLabelColor].CGColor;
    } else {
        iconView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    // 添加轻微阴影
    iconView.layer.shadowColor = [UIColor blackColor].CGColor;
    iconView.layer.shadowOffset = CGSizeMake(0, 1);
    iconView.layer.shadowRadius = 2;
    iconView.layer.shadowOpacity = 0.1;
    
    [iconView sd_setImageWithURL:[NSURL URLWithString:app.icon]];
    [cell.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(16);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(50, 50)); // 稍大的图标
    }];
    
    // 应用信息
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.tag = 1001;
    nameLabel.text = app.name;
    if (@available(iOS 13.0, *)) {
        nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        nameLabel.textColor = [UIColor labelColor];
    } else {
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = [UIColor blackColor];
    }
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.tag = 1002;
    descLabel.text = app.appDescription;
    if (@available(iOS 13.0, *)) {
        descLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        descLabel.textColor = [UIColor secondaryLabelColor];
    } else {
        descLabel.font = [UIFont systemFontOfSize:12];
        descLabel.textColor = [UIColor grayColor];
    }
    descLabel.numberOfLines = 2;
    
    UIStackView *infoStack = [[UIStackView alloc] initWithArrangedSubviews:@[nameLabel, descLabel]];
    infoStack.tag = 1003;
    infoStack.axis = UILayoutConstraintAxisVertical;
    infoStack.spacing = 4;
    [cell.contentView addSubview:infoStack];
    [infoStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(12);
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-90);
    }];
    
    // 添加/已添加按钮
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleButton.tag = 1004;
    if (@available(iOS 13.0, *)) {
        toggleButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
    } else {
        toggleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    toggleButton.layer.cornerRadius = 16;
    [toggleButton addTarget:self action:@selector(toggleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    if (app.isAdded) {
        [toggleButton setTitle:@"已添加" forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [toggleButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
            toggleButton.backgroundColor = [UIColor tertiarySystemFillColor];
        } else {
            [toggleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            toggleButton.backgroundColor = [UIColor lightGrayColor];
        }
    } else {
        [toggleButton setTitle:@"添加" forState:UIControlStateNormal];
        [toggleButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            toggleButton.backgroundColor = [UIColor systemBlueColor];
            [toggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            toggleButton.backgroundColor = [UIColor systemBlueColor];
            [toggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    [cell.contentView addSubview:toggleButton];
    [toggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-16);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(70, 32));
    }];
    
    // 设置按钮tag为行号，方便点击处理
    toggleButton.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80; // 增加行高以适应更大的图标
}

@end 
