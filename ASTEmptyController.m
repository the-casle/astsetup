#import "ASTEmptyController.h"

@interface ASTEmptyController ()
@end

@implementation ASTEmptyController

- (instancetype)initWithSource:(ASTSetupSettings *) aSource{
    if(self = [super init]) {
        self.source = aSource;
    }
    return self;
}
-(void) viewDidLoad{
    [super viewDidLoad]; // Inheritence creates some stuff. Removing will result in blank view for complete customization.
    
    [self registerForSettings]; // Not required, just for better formatting
}

-(void) registerForSettings{ // Not required, just for better formatting
    // Settings up stuff
}

-(void) sessionLoaded{
    // When media provided is loaded. Only sent to pages that already exist, do not rely on for all media formatting, future pages will not have this called.
}

-(void) setupComplete {
    // Sent when exiting setup.
}
@end
