#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "./HighlightButton.h"
#import "./ASTChildViewController.h"
#import "./ASTSetupSettings.h"
#import "./ASTSourceDelegate.h"

@interface ASTHeaderBasicController : ASTChildViewController
@property (nonatomic, retain) UILabel *bigTitle;
@property (nonatomic, retain) UILabel *titleDescription;
@property (nonatomic, retain) HighlightButton *otherButton;
@property (nonatomic, retain) HighlightButton *nextButton;
@end
