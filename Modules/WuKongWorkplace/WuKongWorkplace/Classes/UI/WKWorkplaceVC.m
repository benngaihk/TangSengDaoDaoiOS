//
//  WKWorkplaceVC.m
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import "WKWorkplaceVC.h"
#import "WKWorkplaceManager.h"
#import "WKWorkplaceApp.h"
#import "WKWorkplaceBanner.h"
#import "WKWorkplaceAppStoreVC.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface WKWorkplaceBannerCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WKWorkplaceBanner *banner;
@end

@implementation WKWorkplaceBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.layer.cornerRadius = 8.0f;
    self.coverImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.coverImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.titleLabel.layer.cornerRadius = 4.0f;
    self.titleLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.titleLabel];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView).inset(4);
        make.height.mas_equalTo(24);
    }];
}

- (void)configureBanner:(WKWorkplaceBanner *)banner {
    self.banner = banner;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:banner.cover]];
    self.titleLabel.text = banner.title;
}

@end

@interface WKWorkplaceAppCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) WKWorkplaceApp *app;
@end

@implementation WKWorkplaceAppCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.layer.cornerRadius = 12.0f;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.nameLabel.textColor = [UIColor darkTextColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.iconImageView.mas_width);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(4);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

- (void)configureApp:(WKWorkplaceApp *)app {
    self.app = app;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:app.icon]];
    self.nameLabel.text = app.name;
}

@end

@interface WKWorkplaceVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bannerContainer;
@property (nonatomic, strong) UICollectionView *bannerCollectionView;
@property (nonatomic, strong) UICollectionView *appCollectionView;
@property (nonatomic, strong) UIView *appGridContainer;

@property (nonatomic, strong) NSArray<WKWorkplaceBanner *> *banners;
@property (nonatomic, strong) NSArray<WKWorkplaceApp *> *apps;

@end

@implementation WKWorkplaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
    [self loadData];
}

- (void)setupNavigation {
    self.title = @"";
    
    // 设置导航栏样式
    if (@available(iOS 13.0, *)) {
        self.navigationController.navigationBar.backgroundColor = [UIColor systemBackgroundColor];
        self.navigationController.navigationBar.barTintColor = [UIColor systemBackgroundColor];
    } else {
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    
    // 设置应用商店按钮到右上角
    UIBarButtonItem *appStoreItem;
    if (@available(iOS 13.0, *)) {
        UIImage *appStoreIcon = [UIImage systemImageNamed:@"app.badge.fill"];
        appStoreItem = [[UIBarButtonItem alloc] initWithImage:appStoreIcon
                                                        style:UIBarButtonItemStylePlain 
                                                       target:self 
                                                       action:@selector(appStoreButtonTapped)];
    } else {
        // iOS 12及以下版本使用文字按钮
        appStoreItem = [[UIBarButtonItem alloc] initWithTitle:@"商店" 
                                                        style:UIBarButtonItemStylePlain 
                                                       target:self 
                                                       action:@selector(appStoreButtonTapped)];
    }
    appStoreItem.tintColor = [UIColor systemBlueColor];
    self.navigationItem.rightBarButtonItem = appStoreItem;
}

#pragma mark - UI Setup

- (void)setupUI {
    // 使用系统背景色支持深色模式
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.view).offset(64); // 导航栏高度
            make.left.right.bottom.equalTo(self.view);
        }
    }];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 横幅轮播
    [self setupBannerView];
    
    // 应用网格容器
    [self setupAppGridContainer];
    
    // 设置内容视图高度
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.appGridContainer.mas_bottom).offset(20);
    }];
}

- (void)setupBannerView {
    // 横幅容器视图
    self.bannerContainer = [[UIView alloc] init];
    if (@available(iOS 13.0, *)) {
        self.bannerContainer.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    } else {
        self.bannerContainer.backgroundColor = [UIColor whiteColor];
    }
    self.bannerContainer.layer.cornerRadius = 12;
    self.bannerContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bannerContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.bannerContainer.layer.shadowRadius = 4;
    self.bannerContainer.layer.shadowOpacity = 0.1;
    [self.contentView addSubview:self.bannerContainer];
    
    [self.bannerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.right.equalTo(self.contentView).inset(16);
        make.height.mas_equalTo(140);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.bannerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.bannerCollectionView.backgroundColor = [UIColor clearColor];
    self.bannerCollectionView.showsHorizontalScrollIndicator = NO;
    self.bannerCollectionView.pagingEnabled = YES;
    self.bannerCollectionView.dataSource = self;
    self.bannerCollectionView.delegate = self;
    self.bannerCollectionView.layer.cornerRadius = 12;
    self.bannerCollectionView.clipsToBounds = YES;
    [self.bannerCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BannerCell"];
    
    [self.bannerContainer addSubview:self.bannerCollectionView];
    [self.bannerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bannerContainer);
    }];
}

- (void)setupAppGridContainer {
    // 应用网格容器
    self.appGridContainer = [[UIView alloc] init];
    if (@available(iOS 13.0, *)) {
        self.appGridContainer.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    } else {
        self.appGridContainer.backgroundColor = [UIColor whiteColor];
    }
    self.appGridContainer.layer.cornerRadius = 12;
    self.appGridContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.appGridContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.appGridContainer.layer.shadowRadius = 4;
    self.appGridContainer.layer.shadowOpacity = 0.1;
    [self.contentView addSubview:self.appGridContainer];
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的应用";
    if (@available(iOS 13.0, *)) {
        titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        titleLabel.textColor = [UIColor labelColor];
    } else {
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor darkTextColor];
    }
    [self.appGridContainer addSubview:titleLabel];
    
    [self.appGridContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerContainer.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(16);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.appGridContainer).inset(16);
    }];
    
    [self setupAppGridView:titleLabel];
}

- (void)setupAppGridView:(UILabel *)titleLabel {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 16;
    layout.minimumInteritemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    
    self.appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.appCollectionView.backgroundColor = [UIColor clearColor];
    self.appCollectionView.scrollEnabled = NO;
    self.appCollectionView.dataSource = self;
    self.appCollectionView.delegate = self;
    [self.appCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AppCell"];
    
    [self.appGridContainer addSubview:self.appCollectionView];
    [self.appCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.left.right.bottom.equalTo(self.appGridContainer);
        make.height.mas_equalTo(320); // 动态计算高度
    }];
}

#pragma mark - Data Loading

- (void)loadData {
    [[WKWorkplaceManager sharedManager] loadHomeData].then(^(NSDictionary *result) {
        self.banners = result[@"banners"] ?: @[];
        self.apps = result[@"apps"] ?: @[];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateBannerVisibility];
            [self.bannerCollectionView reloadData];
            [self.appCollectionView reloadData];
            [self updateAppGridHeight];
        });
        return result;
    }).catch(^(NSError *error) {
        // 处理错误
        NSLog(@"加载数据失败: %@", error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 即使出错也要隐藏banner区域
            [self updateBannerVisibility];
        });
    });
}

- (void)updateBannerVisibility {
    BOOL hasBanners = self.banners.count > 0;
    
    if (hasBanners) {
        // 有Banner数据时显示Banner区域
        self.bannerContainer.hidden = NO;
        [self.appGridContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerContainer.mas_bottom).offset(20);
            make.left.right.equalTo(self.contentView).inset(16);
        }];
    } else {
        // 无Banner数据时隐藏Banner区域
        self.bannerContainer.hidden = YES;
        [self.appGridContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(16);
            make.left.right.equalTo(self.contentView).inset(16);
        }];
    }
    
    [self.view layoutIfNeeded];
}

- (void)updateAppGridHeight {
    // 动态计算应用网格高度
    NSInteger appCount = self.apps.count;
    NSInteger rows = (appCount + 3) / 4; // 向上取整，每行4个
    
    // 计算单个应用cell的高度
    CGFloat totalWidth = CGRectGetWidth(self.view.frame) - 64; // 减去外边距
    CGFloat availableWidth = totalWidth - 48; // 减去间距
    CGFloat itemWidth = availableWidth / 4.0;
    CGFloat itemHeight = itemWidth + 28;
    
    // 计算总高度：行数 * item高度 + 间距 + 内边距
    CGFloat totalHeight = rows * itemHeight + (rows - 1) * 16 + 32;
    
    // 确保最小高度
    totalHeight = MAX(totalHeight, 120);
    
    // 更新约束
    [self.appCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Actions

- (void)appStoreButtonTapped {
    WKWorkplaceAppStoreVC *appStoreVC = [[WKWorkplaceAppStoreVC alloc] init];
    [self.navigationController pushViewController:appStoreVC animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.bannerCollectionView) {
        return self.banners.count;
    } else if (collectionView == self.appCollectionView) {
        return self.apps.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.bannerCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndexPath:indexPath];
        
        // 移除之前的子视图
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        WKWorkplaceBanner *banner = self.banners[indexPath.item];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 12;
        [imageView sd_setImageWithURL:[NSURL URLWithString:banner.cover]];
        
        // 横幅标题叠加层
        UIView *overlayView = [[UIView alloc] init];
        overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        overlayView.layer.cornerRadius = 12;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = banner.title;
        titleLabel.textColor = [UIColor whiteColor];
        if (@available(iOS 13.0, *)) {
            titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        } else {
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 2;
        
        [cell.contentView addSubview:imageView];
        [imageView addSubview:overlayView];
        [overlayView addSubview:titleLabel];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(imageView);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(overlayView);
            make.left.right.equalTo(overlayView).inset(16);
        }];
        
        return cell;
    } else if (collectionView == self.appCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCell" forIndexPath:indexPath];
        
        // 移除之前的子视图
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        WKWorkplaceApp *app = self.apps[indexPath.item];
        
        // 应用图标
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 16; // 更大的圆角，符合App Store风格
        iconView.layer.borderWidth = 0.5;
        if (@available(iOS 13.0, *)) {
            iconView.layer.borderColor = [UIColor tertiaryLabelColor].CGColor;
        } else {
            iconView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
        
        // 添加轻微阴影
        iconView.layer.shadowColor = [UIColor blackColor].CGColor;
        iconView.layer.shadowOffset = CGSizeMake(0, 2);
        iconView.layer.shadowRadius = 4;
        iconView.layer.shadowOpacity = 0.1;
        
        [iconView sd_setImageWithURL:[NSURL URLWithString:app.icon]];
        
        // 应用名称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = app.name;
        if (@available(iOS 13.0, *)) {
            nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
            nameLabel.textColor = [UIColor labelColor];
        } else {
            nameLabel.font = [UIFont systemFontOfSize:12];
            nameLabel.textColor = [UIColor darkTextColor];
        }
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.numberOfLines = 2;
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:nameLabel];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(cell.contentView);
            make.height.equalTo(iconView.mas_width);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom).offset(8);
            make.left.right.bottom.equalTo(cell.contentView);
        }];
        
        return cell;
    }
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCell" forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.bannerCollectionView) {
        WKWorkplaceBanner *banner = self.banners[indexPath.item];
        [[WKWorkplaceManager sharedManager] handleBannerClick:banner fromViewController:self];
    } else if (collectionView == self.appCollectionView) {
        WKWorkplaceApp *app = self.apps[indexPath.item];
        [[WKWorkplaceManager sharedManager] handleAppClick:app fromViewController:self];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.bannerCollectionView) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 140);
    } else if (collectionView == self.appCollectionView) {
        // 计算可用宽度：总宽度 - 左右内边距 - 3个间距
        CGFloat totalWidth = CGRectGetWidth(collectionView.frame);
        CGFloat availableWidth = totalWidth - 32 - 48; // 16*2内边距 + 16*3间距
        CGFloat itemWidth = availableWidth / 4.0; // 4列
        return CGSizeMake(itemWidth, itemWidth + 28); // 图标 + 文字高度
    }
    return CGSizeZero;
}

@end 