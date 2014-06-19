//
//  DBEnvironmentConfiguration.m
//  DBTransitEncryption
//
//  Created by David Benko on 6/17/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//
// Thanks to:
// https://github.com/mhupman/MHHabitat     Mobileprovision Parsing

#import "DBEnvironmentConfiguration.h"

@interface DBEnvironmentConfiguration (){
    bool _shouldAutodetect;
    NSString *_currentEnvironment;
    NSString *_resource;
    NSString *_resourceExtension;
    NSDictionary *_configuration;
    NSDictionary *_environmentMapping;
    DBBuildType _detectedBuildType;
}
@end

@implementation DBEnvironmentConfiguration

static DBEnvironmentConfiguration *sharedInstance;
static NSString * const kEnvironmentConfigurationDefaultEnvironment = @"Development";
static NSString * const kEnvironmentConfigurationDefaultResource = @"environments";
static NSString * const kEnvironmentConfigurationDefaultResourceExt = @"json";

#pragma mark - Init
+ (void)initialize
{
    static bool initialized = false;
    if(!initialized)
    {
        initialized = true;
        sharedInstance = [[DBEnvironmentConfiguration alloc] init];
        [sharedInstance readyInstance];
    }
}

- (void)readyInstance{
    _resource = kEnvironmentConfigurationDefaultResource;
    _resourceExtension = kEnvironmentConfigurationDefaultResourceExt;
    _detectedBuildType = detectCurrentBuildType();
    _environmentMapping = @{
                            [NSNumber numberWithInt:DBBuildTypeSimulator]     : kEnvironmentConfigurationDefaultEnvironment,
                            [NSNumber numberWithInt:DBBuildTypeDebug]         : kEnvironmentConfigurationDefaultEnvironment,
                            [NSNumber numberWithInt:DBBuildTypeAdHoc]         : @"Production",
                            [NSNumber numberWithInt:DBBuildTypeAppStore]      : @"Production",
                            [NSNumber numberWithInt:DBBuildTypeEnterprise]    : @"Production"
                            };
    _shouldAutodetect = true;
    [self detectEnvironment];
}

#pragma mark - Environment Detection

+ (void)setEnvironmentDetection:(BOOL)envDetect{
    sharedInstance->_shouldAutodetect = envDetect;
    if (envDetect) {
        [sharedInstance detectEnvironment];
    }
}

- (void)detectEnvironment{
    if (_shouldAutodetect) {
        NSString *env = [_environmentMapping objectForKey:[NSNumber numberWithInt:_detectedBuildType]];
        if (env) {
            if (![_currentEnvironment isEqualToString:env]) {
                _currentEnvironment = env;
            }
        }
    }
    
    // If autodetection is off or fails and we don't yet have a current env, set default.
    if (!_currentEnvironment){
        _currentEnvironment = kEnvironmentConfigurationDefaultEnvironment;
    }
    
    _configuration = getConfigurationFromFile(_resource, _resourceExtension, _currentEnvironment);
}

#pragma mark - Environment Mapping

+ (void)setEnvironmentMapping:(NSDictionary *)mapping{
    sharedInstance->_environmentMapping = mapping;
    [sharedInstance detectEnvironment];
}

+ (void)setEnvironment:(NSString *)environment forBuildType:(DBBuildType)buildType{
    NSMutableDictionary *mutable = [sharedInstance->_environmentMapping mutableCopy];
    [mutable setObject:environment forKey:[NSNumber numberWithInt:buildType]];
    sharedInstance->_environmentMapping = mutable;
    [sharedInstance detectEnvironment];
}

#pragma mark - Build Type Detection

DBBuildType detectCurrentBuildType(){
    
    // Default to AppStore for safety.  If anything ever changes, like the format of the file or it's filename,
    // this would ensure that we would treat every build as "AppStore" and a developer would need to intervene
    // to re-enable testing/sandbox logic.
    DBBuildType type = DBBuildTypeAppStore;
    
#if TARGET_IPHONE_SIMULATOR
    type = DBBuildTypeSimulator;
#else
    // AppStore builds don't contain an embedded.mobileprovision file, Apple strips it out of the
    // IPA before submitting to the AppStore.
    NSString* file = [[NSBundle mainBundle] pathForResource:@"embedded.mobileprovision" ofType:nil];
    @try{
        if (file) {
            //get plist XML
            NSString *fileString = [[NSString alloc] initWithContentsOfFile:file encoding:NSStringEncodingConversionAllowLossy error:nil];
            NSScanner *scanner = [[NSScanner alloc] initWithString:fileString];
            
            if ([scanner scanUpToString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" intoString:NULL])
            {
                
                NSString *plistString = nil;
                
                if ([scanner scanUpToString:@"</plist>" intoString:&plistString])
                {
                    
                    NSDictionary *plist = [[plistString stringByAppendingString:@"</plist>"] propertyList];
                    
                    
                    // Only Debug and AdHoc can have provisioned devices
                    if ([plist valueForKeyPath:@"ProvisionedDevices"])
                    {
                        // Entitlements.get-task-allow allows a debugger to attach
                        if ([[plist valueForKeyPath:@"Entitlements.get-task-allow"] boolValue])
                        {
                            type = DBBuildTypeDebug;
                        }
                        else
                        {
                            type = DBBuildTypeAdHoc;
                        }
                    }
                    else if ([[plist valueForKeyPath:@"ProvisionsAllDevices"] boolValue])
                    {
                        type = DBBuildTypeEnterprise;
                    }
                }
            }
        }
    }
    @catch (NSException* e) {}
#endif
    
    return type;
}

#pragma mark - File Contents
NSDictionary* getConfigurationFromFile(NSString *resource, NSString *type, NSString *environment){
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    @try{
        if (path) {
            NSDictionary *contents;
            if ([type isEqualToString:kEnvironmentConfigurationDefaultResourceExt]) {
                contents = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
            }
            else {
                contents = [[NSDictionary alloc] initWithContentsOfFile:path];
            }
            return [contents objectForKey:environment];
        }
        else return nil;
    }
    @catch (NSException* e) {
        return nil;
    }
}

+ (void)setConfigurationResource:(NSString *)resource ofType:(NSString *)type{
    sharedInstance->_resource = resource;
    sharedInstance->_resourceExtension = type;
    sharedInstance->_configuration = getConfigurationFromFile(resource, type, sharedInstance->_currentEnvironment);
}

#pragma mark - Environments
+ (void)setEnvironment:(NSString *)environment{
    if (![environment isEqualToString:sharedInstance->_currentEnvironment]) {
        sharedInstance->_currentEnvironment = environment;
        sharedInstance->_configuration = getConfigurationFromFile(sharedInstance->_resource, sharedInstance->_resourceExtension, sharedInstance->_currentEnvironment);
    }
    sharedInstance->_shouldAutodetect = false;
}

#pragma mark - Values
+ (NSString *)valueForKey:(NSString *)key{
    return [sharedInstance->_configuration objectForKey:key];
}
@end
