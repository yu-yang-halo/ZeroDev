//
//  JSONManager.m
//  ZeroDev
//
//  Created by admin on 15/11/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "JSONManager.h"
#import "AppManager.h"
#import <JSONKit/JSONKit.h>
@implementation JSONManager

+(NSDictionary *)reverseApplicationJSONToObject{
    NSString *jsonPath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"application.json"];
    if([[NSFileManager defaultManager] fileExistsAtPath:jsonPath]){
        
        NSString *jsonDictionary= [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
        id  jsonObject=[jsonDictionary objectFromJSONString];
        if([jsonObject isKindOfClass:[NSDictionary class]]){
            
            return jsonObject;
        }
        
    }
    return nil;
}

+(NSDictionary *)reverseMobileAppJSONToObject{
    NSString *jsonPath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"mobileApp.json"];
    if([[NSFileManager defaultManager] fileExistsAtPath:jsonPath]){
        
        NSString *jsonDictionary= [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
        id  jsonObject=[jsonDictionary objectFromJSONString];
        if([jsonObject isKindOfClass:[NSDictionary class]]){
            
            return jsonObject;
        }
        
    }
    return nil;
}

+(NSDictionary *)reverseClassJSONToObject{
    NSString *jsonPath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"class.json"];
    if([[NSFileManager defaultManager] fileExistsAtPath:jsonPath]){
        
        NSString *jsonDictionary= [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
        id  jsonObject=[jsonDictionary objectFromJSONString];
        if([jsonObject isKindOfClass:[NSDictionary class]]||[jsonObject isKindOfClass:[NSArray class]]){
            
            return jsonObject;
        }
        
    }
    return nil;
}

+(NSArray *)getMobileAppTags{
    NSDictionary *mobileAppObject=[self reverseMobileAppJSONToObject];
    NSArray* localTags=[mobileAppObject objectForKey:@"localTags"];
    return localTags;
}

@end
