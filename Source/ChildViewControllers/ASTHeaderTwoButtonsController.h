#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "./HighlightButton.h"
#import "./ASTChildViewController.h"
#import "./ASTSetupSettings.h"

@interface ASTHeaderTwoButtonsController : ASTChildViewController
@property (nonatomic, retain) UILabel *bigTitle;
@property (nonatomic, retain) UILabel *titleDescription;
@property (nonatomic, retain) HighlightButton *otherButton;
@property (nonatomic, retain) HighlightButton *nextButton;
@property (nonatomic, retain) AVPlayer *videoPlayer;
@property (nonatomic, retain) AVPlayerLayer *playerLayer;
@property (nonatomic, retain) UIView *mediaView;
@property (nonatomic, retain) UIImageView *imageView;
@end
