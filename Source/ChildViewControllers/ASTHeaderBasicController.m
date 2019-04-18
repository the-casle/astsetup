#import "ASTHeaderBasicController.h"

#define PATH_TO_CACHE @"/var/mobile/Library/Caches/Asteroid"

@interface ASTHeaderBasicController ()
@end

@implementation ASTHeaderBasicController

- (instancetype)initWithSource:(ASTSetupSettings *) aSource{
    if(self = [super init]) {
        self.source = aSource;
    }
    return self;
}
-(void) viewDidLoad{
    [super viewDidLoad];
    
    [self formatButtons];
    
    self.mediaView = [[UIView alloc] init];
    [self.view addSubview:self.mediaView];
    [self.view sendSubviewToBack:self.mediaView];
    
    self.imageView = [[UIImageView alloc] init];
    [self.mediaView addSubview:self.imageView];
    
    self.playerLayer = [AVPlayerLayer layer];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    
    [self.mediaView.layer addSublayer:self.playerLayer];
    
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
    
    
    [self registerForSettings];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mediaView.frame = self.playerLayer.bounds;
}

#pragma mark - Video Player For Style
-(void) formatImageViewStyleHeader {
    CGFloat ratio = self.imageView.image.size.height / self.imageView.image.size.width;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem: self.imageView
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeWidth
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.imageView
                                  attribute: NSLayoutAttributeHeight
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeWidth
                                 multiplier: ratio
                                   constant: 0] setActive:true];
    
    self.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem: self.mediaView
                                  attribute: NSLayoutAttributeWidth
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.imageView
                                  attribute: NSLayoutAttributeWidth
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.mediaView
                                  attribute: NSLayoutAttributeHeight
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.imageView
                                  attribute: NSLayoutAttributeHeight
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [[NSLayoutConstraint constraintWithItem: self.mediaView
                                  attribute: NSLayoutAttributeTop
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeTop
                                 multiplier: 1
                                   constant: 0] setActive:true];
    [self formatHeaderAndDescriptionToMedia];
}

-(void) formatVideoPlayerStyleHeader {
    AVAsset *asset = self.videoPlayer.currentItem.asset;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [tracks objectAtIndex:0];
    CGSize mediaSize = track.naturalSize;
    mediaSize = CGSizeApplyAffineTransform(mediaSize, track.preferredTransform);
    
    CGFloat ratio = fabs(mediaSize.height) / fabs(mediaSize.width);
    CGFloat newHeight = self.view.frame.size.width * ratio;
    self.playerLayer.frame = CGRectMake(0,0, self.view.frame.size.width, newHeight);
    self.mediaView.frame = self.playerLayer.frame;
    
    [self formatHeaderAndDescriptionToMedia];
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
    [self.nextButton addTarget:self action:@selector(primaryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
    [[NSLayoutConstraint constraintWithItem: self.nextButton
                                  attribute: NSLayoutAttributeBottom
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeBottom
                                 multiplier: 1
                                   constant: -30] setActive:true];
}

#pragma mark - Title and Descrition
-(void) formatHeaderAndDescriptionToMedia{
    [self.bigTitle sizeToFit];
    [self.titleDescription sizeToFit];
    self.bigTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem: self.bigTitle
                                  attribute: NSLayoutAttributeTop
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.mediaView
                                  attribute: NSLayoutAttributeBottom
                                 multiplier: 1
                                   constant: 10] setActive:true];
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
                                     toItem: self.mediaView
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
            [self formatImageViewStyleHeader];
            self.playerLayer.hidden = YES;
            
        } else {
            self.videoPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
            AVAsset *asset = self.videoPlayer.currentItem.asset;
            NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
            if(tracks.count > 0){
                [self formatVideoPlayerStyleHeader];
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
-(void) primaryButtonPressed{
    [self nextButtonPressedWithBlock:self.source.primaryBlock];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}
@end
