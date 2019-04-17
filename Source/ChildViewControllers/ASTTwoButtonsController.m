#import "ASTTwoButtonsController.h"

#define PATH_TO_CACHE @"/var/mobile/Library/Caches/Asteroid"

@interface ASTTwoButtonsController ()
@end

@implementation ASTTwoButtonsController

- (instancetype)initWithSource:(ASTSetupSettings *) aSource{
    if(self = [super init]) {
        self.source = aSource;
    }
    return self;
}
-(void) viewDidLoad{
    [super viewDidLoad];
    
    [self formatButtons];
    
    self.bigTitle = [[UILabel alloc] init];
    self.bigTitle.textAlignment = NSTextAlignmentCenter;
    self.bigTitle.font = [UIFont boldSystemFontOfSize:35];
    self.bigTitle.textAlignment = NSTextAlignmentCenter;
    self.bigTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.bigTitle.numberOfLines = 0;
    [self.view addSubview:self.bigTitle];
    
    self.titleDescription = [[UILabel alloc] init];
    self.titleDescription.textAlignment = NSTextAlignmentCenter;
    self.titleDescription.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleDescription.numberOfLines = 0;
    self.titleDescription.font = [UIFont systemFontOfSize:20];
    [self.view addSubview: self.titleDescription];
    
    [self formatHeaderAndDescriptionTop];
    [self formatMediaPlayerStyleCenter];
    
    [self registerForSettings];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect playerFrame = self.mediaView.bounds;
    playerFrame.size.height = self.nextButton.frame.origin.y - self.mediaView.frame.origin.y - 15;
    self.playerLayer.frame = playerFrame;
}

#pragma mark - Video Player For Style
-(void) formatMediaPlayerStyleCenter {
    self.imageView = [[UIImageView alloc] init];
    self.mediaView = [[UIView alloc] init];
    [self.mediaView addSubview:self.imageView];
    [self.view addSubview: self.mediaView];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [[NSLayoutConstraint constraintWithItem: self.mediaView
                                  attribute: NSLayoutAttributeTop
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.titleDescription
                                  attribute: NSLayoutAttributeBottom
                                 multiplier: 1
                                   constant: 10] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.mediaView
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeWidth
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.mediaView
                                  attribute: NSLayoutAttributeBottom
                                  relatedBy: NSLayoutRelationLessThanOrEqual
                                     toItem: self.nextButton
                                  attribute: NSLayoutAttributeTop
                                 multiplier: 1
                                   constant: -20] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.mediaView
                                  attribute: NSLayoutAttributeHeight
                                  relatedBy: NSLayoutRelationLessThanOrEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeHeight
                                 multiplier: 1
                                   constant: 0] setActive:true];
    
    [[NSLayoutConstraint constraintWithItem: self.imageView
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.mediaView
                                  attribute: NSLayoutAttributeWidth
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.imageView
                                  attribute: NSLayoutAttributeHeight
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.mediaView
                                  attribute: NSLayoutAttributeHeight
                                 multiplier: 1
                                   constant: 0] setActive:true];
    
    self.playerLayer = [AVPlayerLayer layer];
    self.playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.mediaView.layer addSublayer:self.playerLayer];
}

#pragma mark - Button for Style
-(void) formatButtons{
    self.nextButton = [[HighlightButton alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.nextButton setTitle: @"Continue" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.backgroundColor = self.colorTheme;
    self.nextButton.layer.cornerRadius = 7.5;
    self.nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nextButton.titleLabel.textColor = [UIColor whiteColor];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem: self.nextButton
                                  attribute: NSLayoutAttributeCenterX
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeCenterX
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.nextButton
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: nil
                                  attribute: NSLayoutAttributeNotAnAttribute
                                 multiplier: 1
                                   constant: 320] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.nextButton
                                  attribute: NSLayoutAttributeHeight
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: nil
                                  attribute: NSLayoutAttributeNotAnAttribute
                                 multiplier: 1
                                   constant: 50] setActive:true];
    
    self.otherButton = [[HighlightButton alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.otherButton setTitle:@"Set Up Later in Settings" forState:UIControlStateNormal];
    [self.otherButton setTitleColor:self.colorTheme forState:UIControlStateNormal];
    self.otherButton.backgroundColor = [UIColor clearColor];
    self.otherButton.layer.cornerRadius = 7.5;
    self.otherButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.otherButton.titleLabel.textColor = [UIColor whiteColor];
    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.otherButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.otherButton];
    
    self.otherButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem: self.otherButton
                                  attribute: NSLayoutAttributeCenterX
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeCenterX
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.otherButton
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: nil
                                  attribute: NSLayoutAttributeNotAnAttribute
                                 multiplier: 1
                                   constant: 320] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.otherButton
                                  attribute: NSLayoutAttributeHeight
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: nil
                                  attribute: NSLayoutAttributeNotAnAttribute
                                 multiplier: 1
                                   constant: 50] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.otherButton
                                  attribute: NSLayoutAttributeBottom
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeBottom
                                 multiplier: 1
                                   constant: -10] setActive:true];
    
    
    [[NSLayoutConstraint constraintWithItem: self.nextButton
                                  attribute: NSLayoutAttributeBottom
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.otherButton
                                  attribute: NSLayoutAttributeTop
                                 multiplier: 1
                                   constant: 0] setActive:true];
}

#pragma mark - Title and Descrition
-(void) formatHeaderAndDescriptionTop{
    [self.bigTitle sizeToFit];
    [self.titleDescription sizeToFit];
    self.bigTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem: self.bigTitle
                                  attribute: NSLayoutAttributeTop
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeTop
                                 multiplier: 1
                                   constant: 30] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.bigTitle
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeWidth
                                 multiplier: .9
                                   constant: 1] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.bigTitle
                                  attribute: NSLayoutAttributeCenterX
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeCenterX
                                 multiplier: 1
                                   constant: 0] setActive:true];
    
    self.titleDescription.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem: self.titleDescription
                                  attribute: NSLayoutAttributeTop
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.bigTitle
                                  attribute: NSLayoutAttributeBottom
                                 multiplier: 1
                                   constant: 10] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.titleDescription
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeWidth
                                 multiplier: .8
                                   constant: 1] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.titleDescription
                                  attribute: NSLayoutAttributeCenterX
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeCenterX
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.titleDescription
                                  attribute: NSLayoutAttributeLastBaseline
                                  relatedBy: NSLayoutRelationLessThanOrEqual
                                     toItem: self.nextButton
                                  attribute: NSLayoutAttributeTop
                                 multiplier: 1
                                   constant: -10] setActive:true];
}

-(void) registerForSettings{
    self.bigTitle.text = self.source.title;
    self.titleDescription.text = self.source.titleDescription;
    
    [self.nextButton setTitle: self.source.primaryButtonLabel forState:UIControlStateNormal];
    [self.otherButton setTitle: self.source.secondaryButtonLabel forState:UIControlStateNormal];
    if(self.source.backButtonLabel){
        [self.backButton setTitle: self.source.backButtonLabel forState:UIControlStateNormal];
    }
    
    [self setupMediaWithUrl:self.source.mediaURL];
    if(self.source.disableBack){
        self.backButton.hidden = YES;
    }
}

-(void) sessionLoaded{
    AVAsset *asset = self.videoPlayer.currentItem.asset;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if(!self.imageView.image && tracks.count == 0){
        [self setupMediaWithUrl:self.source.mediaURL];
    }
}

-(void) setupComplete {
    [self.videoPlayer pause];
}

-(void) setupMediaWithUrl:(NSString *) pathToUrl{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", PATH_TO_CACHE, [NSURL URLWithString:pathToUrl].lastPathComponent];
    if ([fileManager fileExistsAtPath:filePath]){
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
        if (image) {
            self.imageView.image = image;
            self.playerLayer.hidden = YES;
            
        } else {
            self.videoPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
            AVAsset *asset = self.videoPlayer.currentItem.asset;
            NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
            if(tracks.count > 0){
                self.playerLayer.player = self.videoPlayer;
                self.videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:[self.videoPlayer currentItem]];
                [self.videoPlayer play];
                self.imageView.hidden = YES;
                
            }
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}
@end
