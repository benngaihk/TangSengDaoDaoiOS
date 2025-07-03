//
//  WKMainTabController.m
//  TangSengDaoDao
//
//  Created by tt on 2019/12/7.
//  Copyright © 2019 xinbida. All rights reserved.
//

#import "WKMainTabController.h"
#import <WuKongBase/WuKongBase.h>
#import <Lottie/Lottie.h>
#import "WKConversationListVC.h"
#import "WKContactsVC.h"
#import "WKMeVC.h"
#import <WuKongWorkplace/WuKongWorkplace.h>
@interface WKMainTabController ()<UITabBarControllerDelegate>

@property(nonatomic,strong) LOTAnimationView *currentLOTAnimationView;

@end

@implementation WKMainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    if (@available(iOS 13.0, *)) {
        [self.tabBar setBarTintColor:[UIColor systemBackgroundColor]];
        [self.tabBar setBackgroundColor:[UIColor systemBackgroundColor]];
    } else {
        [self.tabBar setBarTintColor:[UIColor whiteColor]];
        [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    }
   
    [self setupChildVC:WKConversationListVC.class title:@"" andImage:@"HomeTab" andSelectImage:@"HomeTabSelected"];
    [self setupChildVC:WKContactsVC.class title:@"" andImage:@"ContactsTab" andSelectImage:@"ContactsTabSelected"];
    [self setupChildVC:WKWorkplaceVC.class title:@"" andImage:@"ContactsTab" andSelectImage:@"ContactsTabSelected"];
    [self setupChildVC:WKMeVC.class title:@"" andImage:@"MeTab" andSelectImage:@"MeTabSelected"];

}

- (void)setupChildVC:(Class)vc title:(NSString *)title andImage:(NSString * )image andSelectImage:(NSString *)selectImage{
    
    UIViewController * vcInstall = [[vc alloc] init];
    //VC.view.backgroundColor = UIColor.whiteColor;
    
    // 为工作台VC添加导航控制器
    UIViewController *finalVC;
    if ([vc isEqual:[WKWorkplaceVC class]]) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vcInstall];
        finalVC = navController;
    } else {
        finalVC = vcInstall;
    }
    
    finalVC.tabBarItem.title = title;
    finalVC.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    finalVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    finalVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self addChildViewController:finalVC];
}


-(void) dealloc {
    WKLogDebug(@"WKMainTabController dealloc");
}

#pragma mark - UITabBarControllerDelegate

static UIImpactFeedbackGenerator *impactFeedBack;
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if(!impactFeedBack) {
        impactFeedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    }
    [impactFeedBack prepare];
    [impactFeedBack impactOccurred];
}

@end
