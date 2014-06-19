//
//  DBEnvironmentConfiguration.h
//  DBTransitEncryption
//
//  Created by David Benko on 6/17/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//
// Thanks to:
// https://github.com/mhupman/MHHabitat     Mobileprovision Parsing

#import <Foundation/Foundation.h>

#ifdef _DBEC_SHORTHAND_
#define ENV(x) [DBEnvironmentConfiguration valueForKey:x]
#define SET_BUILD_ENVIRONMENT(x) [DBEnvironmentConfiguration setEnvironment:x]
#define SET_ENVIRONMENT_MAPPING(x) [DBEnvironmentConfiguration setEnvironmentMapping:x]
#endif

typedef enum DBBuildType{
    DBBuildTypeUndetermined,
    DBBuildTypeSimulator,
    DBBuildTypeDebug,
    DBBuildTypeAdHoc,
    DBBuildTypeAppStore,
    DBBuildTypeEnterprise
} DBBuildType;

@interface DBEnvironmentConfiguration : NSObject

/**
 * Sets environment to read values from.
 * Can also be done by defining BUILD_ENVIRONMENT
 *
 * @param environment The name of the environment as it appears in the file
 *
 */
+ (void)setEnvironment:(NSString *)environment;

/**
 * Sets file to read values from.
 * Defaults to environments.json
 *
 * @param resource The name of the file without the extension
 * @param type The extension of the file
 *
 */
+ (void)setConfigurationResource:(NSString *)resource ofType:(NSString *)type;

/**
 * Reads a value from the current environment
 *
 * @param key The key the value is stored with
 * @return The string value for the key provided
 *
 */
+ (NSString *)valueForKey:(NSString *)key;

/**
 * Turns automatic environment detection on or off
 * Defaults to true
 *
 * @param envDetect whether or not to use environment detection
 *
 */
+ (void)setEnvironmentDetection:(BOOL)envDetect;

/**
 * Set a map of environments to build types
 * Requires Environment Detection to be ON
 *
 * @param mapping a dictionary whose keys are NSNumber * representing the DBBuildType and whose values are the environment name
 *
 */
+ (void)setEnvironmentMapping:(NSDictionary *)mapping;

/**
 * Set an Environment to be used with a specific build type
 * Requires Environment Detection to be ON
 *
 * @param environment the name of the environment to be mapped
 * @param buildType the build type to map the environment to
 *
 */
+ (void)setEnvironment:(NSString *)environment forBuildType:(DBBuildType)buildType;
@end
