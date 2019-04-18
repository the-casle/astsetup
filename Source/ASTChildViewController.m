#import "ASTChildViewController.h"

#define PATH_TO_CACHE @"/var/mobile/Library/Caches/Asteroid"

@interface ASTChildViewController ()
@end

@implementation ASTChildViewController

- (instancetype)initWithSource:(ASTSetupSettings *) aSource{
    if(self = [super init]) {
        self.source = aSource;
    }
    return self;
}
-(void) viewDidLoad{
    [super viewDidLoad];
    
    UIColor *sourceColor = self.source.colorTheme;
    self.colorTheme = sourceColor ? sourceColor : [UIColor colorWithRed:10 / 255.0 green:106 / 255.0 blue:255 / 255.0 alpha:1.0];
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setUserInteractionEnabled:TRUE];
    
    //Create navigation bar
    self.navBar = [[UINavigationBar alloc]init];
    //Make navigation bar background transparent
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navBar.shadowImage = [UIImage new];
    self.navBar.translucent = YES;
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    
    //Create the back button view
    UIView* leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(-12, 0, 75, 50)];
    
    self.backButton = [HighlightButton buttonWithType:UIButtonTypeSystem];
    self.backButton.backgroundColor = [UIColor clearColor];
    self.backButton.frame = leftButtonView.frame;
    if([UIScreen mainScreen].scale == 3){
        [self.backButton setImage:[UIImage imageWithContentsOfFile:@"/Library/Frameworks/astSetup.framework/ic_arrow_back_ios@3x.png"] forState:UIControlStateNormal];
    } else {
        [self.backButton setImage:[UIImage imageWithContentsOfFile:@"/Library/Frameworks/astSetup.framework/ic_arrow_back_ios@2x.png"] forState:UIControlStateNormal];
    }
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.tintColor = self.colorTheme;
    self.backButton.autoresizesSubviews = YES;
    self.backButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [leftButtonView addSubview:self.backButton];
    
    //Add back button to navigation bar
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButtonView];
    navItem.leftBarButtonItem = leftBarButton;
    
    self.navBar.items = @[ navItem ];
    [self.view addSubview:self.navBar];
    [self.view bringSubviewToFront:self.navBar];
    
    self.navBar.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem: self.navBar
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeWidth
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.navBar
                                  attribute: NSLayoutAttributeHeight
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: nil
                                  attribute: NSLayoutAttributeNotAnAttribute
                                 multiplier: 1
                                   constant: 50] setActive:true];
}


-(void) sessionLoaded{
    // Can be overriden
}
-(void) setupComplete{
    // Can be overriden
}

-(void) nextButtonPressedWithBlock:(block) aBlock{
    if([self.delegate respondsToSelector:@selector(changePage:)]){
        [self.delegate changePage: UIPageViewControllerNavigationDirectionForward];
    }
    if(aBlock) aBlock();
}
-(void) backButtonPressed{
    if([self.delegate respondsToSelector:@selector(changePage:)]){
        [self.delegate changePage: UIPageViewControllerNavigationDirectionReverse];
    }
}

+(BOOL) isASTChildViewController{
    // allows for checking inheritence idk
    return YES;
}
@end
