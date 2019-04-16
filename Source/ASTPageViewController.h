#import <UIKit/UIKit.h>
#import <substrate.h>
#import <spawn.h>
#import <objc/message.h>
#import "ASTChildViewController.h"
#import "ASTSourceDelegate.h"

@interface ASTPageViewController : UIViewController <ASTSourceDelegate>
- (instancetype)initWithPages:(NSArray *)pages;
@property (nonatomic, retain) UIPageViewController *pageController;
@property (nonatomic, retain) NSArray *astPageSources;
@end

@interface SBDashBoardIdleTimerProvider
-(void) addDisabledIdleTimerAssertionReason:(NSString *)reason;
-(void) removeDisabledIdleTimerAssertionReason:(NSString *)reason;
@end

@interface SBDashBoardViewController
@end

@interface SBLockScreenManager
-(id) sharedInstance;
@property (nonatomic,readonly) SBDashBoardViewController * dashBoardViewController;
@end
