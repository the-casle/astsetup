#import "ASTPageViewController.h"

#define PATH_TO_CACHE @"/var/mobile/Library/Caches/Asteroid"

@interface ASTPageViewController ()
@end

@implementation ASTPageViewController {
    
}

- (instancetype)initWithPages:(NSArray *)pages{
    if(self = [super init]) {
        self.astPageSources = pages;
        [self createDirectory];
        [self loadCache];
    }
    return self;
}

-(void) createDirectory{
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:PATH_TO_CACHE isDirectory:&isDir]){
        [fileManager createDirectoryAtPath:PATH_TO_CACHE withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

- (void)loadCache {
    for (ASTSetupSettings *page in self.astPageSources) {
        NSURL *url = [NSURL URLWithString:page.mediaURL];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", PATH_TO_CACHE, url.lastPathComponent];
            NSURL *scaledUrl = [self scaledUrlFromUrl:url];
            [[[NSURLSession sharedSession] dataTaskWithURL:scaledUrl
                                         completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
                                             NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
                                             if(httpStatus != 404){
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [data writeToFile:filePath atomically:YES];
                                                     for (ASTChildViewController * cont in self.pageController.viewControllers) {
                                                         [cont sessionLoaded];
                                                     }
                                                 });
                                             } else {
                                                 [[[NSURLSession sharedSession] dataTaskWithURL:url
                                                                              completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
                                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                                      [data writeToFile:filePath atomically:YES];
                                                                                      for (ASTChildViewController * cont in self.pageController.viewControllers) {
                                                                                          [cont sessionLoaded];
                                                                                      }
                                                                                  });
                                                                              }] resume];
                                             }
                                         }] resume];
        });
    }
}

-(void) clearCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:PATH_TO_CACHE error:nil];
    for (NSString *filename in fileArray)  {
        [fileManager removeItemAtPath:[PATH_TO_CACHE stringByAppendingPathComponent:filename] error:NULL];
    }
}

-(NSURL *) scaledUrlFromUrl:(NSURL *)url{
    NSString *scaledUrl = url.absoluteString;
    float endLgth = url.pathExtension.length;
    endLgth ++; // including the "."
    NSMutableString *mu = [NSMutableString stringWithString:scaledUrl];
    NSString *insert = [UIScreen mainScreen].scale == 2 ? @"@2x" : @"@3x";
    [mu insertString:insert atIndex:scaledUrl.length - endLgth];
    scaledUrl = mu;
    return [NSURL URLWithString:scaledUrl];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    ASTChildViewController *initialViewController = [self viewControllerAtIndex:0];
    initialViewController.delegate = self;
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    [self disableAutoLock];
}

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    NSUInteger pageIndex = ((ASTChildViewController *) [self.pageController.viewControllers objectAtIndex:0]).index;
    if (direction == UIPageViewControllerNavigationDirectionForward){
        pageIndex++;
    }else {
        pageIndex--;
    }
    if(pageIndex >= self.astPageSources.count){
        for(ASTChildViewController *page in self.pageController.viewControllers){
            [page setupComplete];
        }
        [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut  animations:^{
            self.view.center = CGPointMake(self.view.center.x, - (2 * self.view.frame.size.height));
        } completion:^(BOOL finished){
            self.view.superview.hidden = YES;
            self.view.center = self.view.superview.center;
            [self enableAutoLock];
            [self clearCache];
            //[self startRespring]; // MAKE SURE TO ENABLE THIS WHEN DONE MAKING!!!!!!!!!!!!!!!!!
        }];
        return;
    }
    
    ASTChildViewController *viewController = [self  viewControllerAtIndex:pageIndex];
    if (viewController == nil) {
        return;
    }
    [self.pageController setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
}

- (ASTChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    ASTSetupSettings *settingsAtIndex = self.astPageSources[index];
    ASTChildViewController *childViewController = nil;
    if([settingsAtIndex.style respondsToSelector:@selector(initWithSource:)]){
        childViewController = [[settingsAtIndex.style alloc] initWithSource:settingsAtIndex];
    } else {
        childViewController = [[ASTChildViewController alloc] initWithSource:settingsAtIndex];
    }
    childViewController.index = index;
    childViewController.delegate = self;
    
    return childViewController;
}

#pragma mark - Autolock
-(void) enableAutoLock{
    SBLockScreenManager *lockMan = (SBLockScreenManager *)[objc_getClass("SBLockScreenManager") sharedInstance];
    SBDashBoardIdleTimerProvider *idleProv = MSHookIvar<SBDashBoardIdleTimerProvider *>(lockMan.dashBoardViewController, "_idleTimerProvider");
    [idleProv removeDisabledIdleTimerAssertionReason:@"astSetup"];
}
-(void) disableAutoLock{
    SBLockScreenManager *lockMan = (SBLockScreenManager *)[objc_getClass("SBLockScreenManager") sharedInstance];
    SBDashBoardIdleTimerProvider *idleProv = MSHookIvar<SBDashBoardIdleTimerProvider *>(lockMan.dashBoardViewController, "_idleTimerProvider");
    [idleProv addDisabledIdleTimerAssertionReason:@"astSetup"];
}


#pragma mark - Respring
- (void)startRespring {
    [self.view endEditing:YES]; //save changes to text fields and dismiss keyboard
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    visualEffectView.alpha = 0.0;
    
    //add it to the main window, but with no alpha
    [[[UIApplication sharedApplication] keyWindow] addSubview:visualEffectView];
    
    //animate in the alpha
    [UIView animateWithDuration:3.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         visualEffectView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             NSLog(@"Squiddy says hello");
                             NSLog(@"Midnight replys with 'where am I?'");
                             //call the animation here for the screen fade and respring
                             [self graduallyAdjustBrightnessToValue:0.0f];
                         }
                     }];
}
- (void)graduallyAdjustBrightnessToValue:(CGFloat)endValue{
    CGFloat startValue = [[UIScreen mainScreen] brightness];
    
    CGFloat fadeInterval = 0.01;
    double delayInSeconds = 0.005;
    if (endValue < startValue)
        fadeInterval = -fadeInterval;
    
    CGFloat brightness = startValue;
    while (fabs(brightness-endValue)>0) {
        
        brightness += fadeInterval;
        
        if (fabs(brightness-endValue) < fabs(fadeInterval))
            brightness = endValue;
        
        dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(dispatchTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[UIScreen mainScreen] setBrightness:brightness];
        });
    }
    UIView *finalDarkScreen = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
    finalDarkScreen.backgroundColor = [UIColor blackColor];
    finalDarkScreen.alpha = 0.3;
    
    //add it to the main window, but with no alpha
    [[[UIApplication sharedApplication] keyWindow] addSubview:finalDarkScreen];
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         finalDarkScreen.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             //DIE
                             AudioServicesPlaySystemSound(1521);
                             sleep(1);
                             pid_t pid;
                             const char* args[] = {"killall", "-9", "backboardd", NULL};
                             posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
                         }
                     }];
}

@end
