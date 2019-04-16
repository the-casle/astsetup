#import "ASTSetup-private.h"

@implementation ASTSetup
- (instancetype)initWithPages:(NSArray *)pages {
    if(self = [super init]) {
        self.window = [[ASTSetupWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
        self.viewController = [[ASTPageViewController alloc] initWithPages: pages];
        self.window.pageManager = self.viewController;
        [self.window addSubview: self.viewController.view];
        [self.window makeKeyAndVisible];
    }
    return self;
}
@end
