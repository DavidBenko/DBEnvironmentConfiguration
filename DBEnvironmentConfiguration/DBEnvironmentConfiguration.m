//
//  DBEnvironmentConfiguration.m
//  DBTransitEncryption
//
//  Created by David Benko on 6/17/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "DBEnvironmentConfiguration.h"

@interface DBEnvironmentConfiguration (){
    NSString *_currentEnvironment;
    NSString *_resource;
    NSString *_resourceExtension;
    NSDictionary *_configuration;
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
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedInstance = [[DBEnvironmentConfiguration alloc] init];
        [sharedInstance readyInstance];
    }
}

- (void)readyInstance{
    _currentEnvironment = kEnvironmentConfigurationDefaultEnvironment;
    _resource = kEnvironmentConfigurationDefaultResource;
    _resourceExtension = kEnvironmentConfigurationDefaultResourceExt;
    _configuration = getConfigurationFromFile(_resource, _resourceExtension, kEnvironmentConfigurationDefaultEnvironment);
}

#pragma mark - File Contents
NSDictionary* getConfigurationFromFile(NSString *resource, NSString *type, NSString *environment){
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
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

+ (void)setConfigurationResource:(NSString *)resource ofType:(NSString *)type{
    sharedInstance->_resource = resource;
    sharedInstance->_resourceExtension = type;
    sharedInstance->_configuration = getConfigurationFromFile(resource, type, sharedInstance->_currentEnvironment);
}

#pragma mark - Environments
+ (void)setEnvironment:(NSString *)environment{
    sharedInstance->_currentEnvironment = environment;
    sharedInstance->_configuration = getConfigurationFromFile(sharedInstance->_resource, sharedInstance->_resourceExtension, sharedInstance->_currentEnvironment);
}

#pragma mark - Values
+ (NSString *)valueForKey:(NSString *)key{
    return [sharedInstance->_configuration objectForKey:key];
}
@end
