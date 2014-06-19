DBEnvironmentConfiguration
=====================

Overview
---------

Super-simple environment configuration for iOS apps. Set environment variables that switch automagically based on build type or set an environment with one line of code.

### Installation

##### Via CocoaPods
- Add `pod 'DBEnvironmentConfiguration'` to your podfile
- Run `pod install`
- Import header (`#import <DBEnvironmentConfiguration/DBEnvironmentConfiguration.h>`)
 
##### Manual Installation
- Add `DBEnvironmentConfiguration` folder to your project
- Import header (`#import "DBEnvironmentConfiguration"`)

Environment File
---------

### File Format

- Supported formats include `.json` and `.plist`. 
- Default configuration file is `environments.json`

###### Example JSON file:
```json
{
    "Development": {
        "base_url": "https://dev.mycompany.com",
        "api_version": "5"
    },
    "Staging": {
        "base_url": "https://stage.mycompany.com",
        "api_version": "3"
    },
    "Production": {
        "base_url": "https://mycompany.com",
        "api_version": "3"
    }
}

```

Example
---------
```objc
[DBEnvironmentConfiguration setEnvironment:@"Staging"]; // Set Environment (Defaults to 'Development')
NSString *baseURL = [DBEnvironmentConfiguration valueForKey:@"base_url"]; // Done 
```

Environment Detection
---------
**DBEnvironmentConfiguration** can detect the build type of the application. You can map these build types to environments so that the environments will sitch automatcially. 

Possible build types:
```objc
    DBBuildTypeUndetermined,
    DBBuildTypeSimulator,
    DBBuildTypeDebug,
    DBBuildTypeAdHoc,
    DBBuildTypeAppStore,
	DBBuildTypeEnterprise
```

You can map build types individually or as one `NSDictionary *`.
```objc
    // Individual mapping
    [DBEnvironmentConfiguration setEnvironment:@"Development" forBuildType:DBBuildTypeSimulator];
    
    // Map all environments at once
    [DBEnvironmentConfiguration setEnvironmentMapping:@{
                                                        [NSNumber numberWithInt:DBBuildTypeSimulator]     : @"Development",
                                                        [NSNumber numberWithInt:DBBuildTypeDebug]         : @"Development",
                                                        [NSNumber numberWithInt:DBBuildTypeAdHoc]         : @"Staging",
                                                        [NSNumber numberWithInt:DBBuildTypeAppStore]      : @"Production",
                                                        [NSNumber numberWithInt:DBBuildTypeEnterprise]    : @"Production"
                                                        }];
```

Setting the environment manually by calling `setEnvironment:` will turn off environment detection. You can also enable/disable environment detection by calling `setEnvironmentDetection:`. 

Shorthand
---------
**DBEnvironmentConfiguration** allows shorthand to get environment variables and to set the environment 

##### Turn on environment variable shorthand
```objc
    #define _DBEC_SHORTHAND_                    // Set before importing header
    #import <DBEnvironmentConfiguration/DBEnvironmentConfiguration.h> 

...

    SET_BUILD_ENVIRONMENT(@"Staging");          // Set the environment
    SET_ENVIRONMENT_MAPPING(@{@2:@"Staging"});  // Map environments
    NSString *baseURL = ENV(@"base_url");       // Get environment variables 

```

License
---------------

The MIT License (MIT)

Copyright (c) 2014 David Benko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
