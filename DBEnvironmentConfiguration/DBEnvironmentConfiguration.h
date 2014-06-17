//
//  DBEnvironmentConfiguration.h
//  DBTransitEncryption
//
//  Created by David Benko on 6/17/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@end
