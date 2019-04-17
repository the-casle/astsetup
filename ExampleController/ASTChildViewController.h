#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "HighlightButton.h"
#import "ASTSetupSettings.h"
#import "ASTSourceDelegate.h"

@interface ASTChildViewController : UIViewController
@property (nonatomic, retain) UINavigationBar *navBar;
@property (nonatomic, retain) HighlightButton *backButton;
@property (nonatomic, retain) UIColor *colorTheme;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id <ASTSourceDelegate> delegate;
@property (nonatomic, retain) ASTSetupSettings *source;

- (instancetype)initWithSource:(ASTSetupSettings *) source;
-(void) setupComplete;
-(void) sessionLoaded;
-(void) nextButtonPressed;
-(void) backButtonPressed;
@end
