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
@property (nonatomic, strong) UICollectionView *bannerCollectionView;
@property (nonatomic, strong) UICollectionView *appCollectionView;
@property (nonatomic, strong) UIButton *appStoreButton;

@property (nonatomic, strong) NSArray<WKWorkplaceBanner *> *banners;
@property (nonatomic, strong) NSArray<WKWorkplaceApp *> *apps;

@end

@implementation WKWorkplaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

#pragma mark - UI Setup

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"";
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
    
    // 应用网格
    [self setupAppGridView];
    
    // 应用商店按钮
    [self setupAppStoreButton];
    
    // 设置内容视图高度
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.appStoreButton.mas_bottom).offset(20);
    }];
}

- (void)setupBannerView {
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
    [self.bannerCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BannerCell"];
    
    [self.contentView addSubview:self.bannerCollectionView];
    [self.bannerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(120);
    }];
}

- (void)setupAppGridView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    self.appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.appCollectionView.backgroundColor = [UIColor clearColor];
    self.appCollectionView.dataSource = self;
    self.appCollectionView.delegate = self;
    [self.appCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AppCell"];
    
    [self.contentView addSubview:self.appCollectionView];
    [self.appCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerCollectionView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(300); // 固定高度，支持4行
    }];
}

- (void)setupAppStoreButton {
    self.appStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.appStoreButton setTitle:@"应用商店" forState:UIControlStateNormal];
    [self.appStoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.appStoreButton.backgroundColor = [UIColor systemBlueColor];
    self.appStoreButton.layer.cornerRadius = 8;
    [self.appStoreButton addTarget:self action:@selector(appStoreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.appStoreButton];
    [self.appStoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appCollectionView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Data Loading

- (void)loadData {
    [[WKWorkplaceManager sharedManager] loadHomeData].then(^(NSDictionary *result) {
        self.banners = result[@"banners"] ?: @[];
        self.apps = result[@"apps"] ?: @[];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bannerCollectionView reloadData];
            [self.appCollectionView reloadData];
        });
        return result;
    }).catch(^(NSError *error) {
        // 处理错误
        NSLog(@"加载数据失败: %@", error.localizedDescription);
    });
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
        imageView.layer.cornerRadius = 8;
        [imageView sd_setImageWithURL:[NSURL URLWithString:banner.cover]];
        
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(5, 15, 5, 15));
        }];
        
        return cell;
    } else if (collectionView == self.appCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCell" forIndexPath:indexPath];
        
        // 移除之前的子视图
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        WKWorkplaceApp *app = self.apps[indexPath.item];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 8;
        [iconView sd_setImageWithURL:[NSURL URLWithString:app.icon]];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = app.name;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.numberOfLines = 2;
        
        [cell.contentView addSubview:iconView];
        [cell.contentView addSubview:nameLabel];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(cell.contentView);
            make.height.equalTo(iconView.mas_width);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom).offset(5);
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
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 120);
    } else if (collectionView == self.appCollectionView) {
        CGFloat width = (CGRectGetWidth(collectionView.frame) - 30) / 4.0; // 4列
        return CGSizeMake(width, width + 20); // 图标 + 文字高度
    }
    return CGSizeZero;
}

@end 