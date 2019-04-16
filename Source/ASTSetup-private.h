#import "ASTSetupWindow.h"
#import "ASTPageViewController.h"

@interface ASTSetup : NSObject
- (instancetype)initWithPages:(NSArray *)pages;
@property (nonatomic, retain) ASTSetupWindow *window;
@property (nonatomic, retain) ASTPageViewController *viewController;
@end
