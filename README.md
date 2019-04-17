# astsetup
Setup framework for tweak developers

# Installation
Transfer the most recent `.framework` to `$THEOS/lib` from the releases tab.

`ASTSetup.h` under the release tab should be placed under `$THEOS/include`

# Usage
Most of the properties are outlined under `ASTSetup.h` (release tab). Essentially the framework will create a window holding the setup controllers.

Each page of the setup is broken down into multiple properties. Below is an example of a setup being initialized. (Header contains full list of properties).

```objc
ASTSetupSettings *page1 = [[ASTSetupSettings alloc] init];
    page1.style = [ASTHeaderTwoButtonsController class];
    page1.title = @"Asteroid";
    page1.titleDescription = @"MidnightChips & the casle © 2019\n\nThank you for installing Asteroid. In order to deliver the best user experience, further setup is required.";
    page1.primaryButtonLabel = @"Setup";
    page1.secondaryButtonLabel = @"second";
    page1.backButtonLabel = @"Skip";
    page1.mediaURL = @"https://the-casle.github.io/TweakResources/Asteroid.png";
    page1.primaryBlock= [^{ NSLog(@"code that will be run when button is pressed");} copy]; // copy is important!
    
    NSArray *pages = @[page1];
    self.setup = [[ASTSetup alloc] initWithPages:pages]; // Creating the setup
```

# Custom Controllers
A big part of this framework is customization. Some styles are already included, however Developers can create any kind of style they would like. 
Empty class files are inside of the repo for a start, however the following files need to be included with the project so they can be imported for inheritence. They can be found under the release tab or within the source folder.
```objc
ASTChildViewController.h
ASTSetupSettings.h
```
If you need more resources, the files under /Source/ChildViewControllers are formatted as custom classes so they can serve as a examples.

If need more properties than supplied within the settings, `ASTSetupSettings` can be inheritted and any additional properties can be included within the new class.

# Last Notes
It's up to the dev on handling the setup being run only once if that's their primary use. It doesn't have to be only for following an installation, it will popup the window whenever the `ASTSetup` is initialized.
