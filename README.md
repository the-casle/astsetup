![](https://imgur.com/a/J9jwild)

# astsetup
Setup framework for tweak developers

# Installation
Transfer the most recent `.framework` to `$THEOS/lib` from the releases tab.

`ASTSetup.h` under the release tab should be placed under `$THEOS/include`

# Usage
Add `astSetup` as an extra framework inside of the makefile.
```
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = astSetup
```

Each page of the setup is broken down into multiple properties. Below is an example of a setup being initialized. The default properties are outlined under `ASTSetup.h` (release tab), but more can be added for custom controllers explained under the Custom Controllers section. Essentially the framework will create a window holding the setup controllers. 

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
    
    NSArray *pages = @[page1]; // Add other pages to the array here.
    self.setup = [[ASTSetup alloc] initWithPages:pages]; // Creating the setup
```
The default styles can be found under `/Source/ChildViewControllers` or inside of `ASTSetup.h`

# Custom Controllers
A big part of this framework is customization. Some styles are already included, however Developers can create any kind of style they would like. It is important to remember that the framework is fully functional without using custom controllers if not needed.
`ASTEmptyController` contains some files for a start, however the header files need to be included with the project so they can be imported for inheritence. They can be found under the release tab or within the source folder.
```objc
ASTChildViewController.h
ASTSetupSettings.h
```
If you need more resources, the files under `/Source/ChildViewControllers` are formatted as custom classes so they can serve as a examples.

If additional properties are needed beyond those supplied within the settings, `ASTSetupSettings` can be inheritted and any additional properties can be included within the new class.

# Last Notes
It's up to the dev on `astSetup`'s use. If for example its used post installation, the dev will have to verify the setup is only triggered once. It doesn't have to be used soley following an installation, it will popup the window whenever the `ASTSetup` is initialized so it can be used wherever it's needed.
