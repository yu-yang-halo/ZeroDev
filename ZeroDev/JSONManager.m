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
+(NSString *)getAppTitle{
    NSDictionary* jsonObject=[self reverseJSONToObject];
   
     
    if(jsonObject!=nil){
        return [[jsonObject objectForKey:@"mobileApp"] objectForKey:@"appName"];
    }else{
        NSLog(@"json nil ");
    }
   
    
    return nil;
    
}
+(NSDictionary *)reverseJSONToObject{
    NSString *jsonPath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"json/app.json"];
    if([[NSFileManager defaultManager] fileExistsAtPath:jsonPath]){
        
        NSString *jsonDictionary= [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
        id  jsonObject=[jsonDictionary objectFromJSONString];
        if([jsonObject isKindOfClass:[NSDictionary class]]){
           
            return jsonObject;
        }
        
    }
    return nil;
}
+(NSString *)reverseJSONToString{
    NSString *jsonPath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"json/app.json"];
    if([[NSFileManager defaultManager] fileExistsAtPath:jsonPath]){
        
        NSString *jsonDictionary= [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
        return jsonDictionary;
        
    }
    return nil;
}

/*
 {
 name = "\U4f4d\U7f6e";
 tag =         (
 Bedroom,
 Kitchen,
 "Front Door"
 );
 tagSetId = 16;
 }
 */
+(NSArray *)getTags{
    id tags=nil;
    NSDictionary* jsonObject=[self reverseJSONToObject];
    if(jsonObject!=nil){
        tags=[[jsonObject objectForKey:@"mobileApp"] objectForKey:@"Tags"];
        if([tags isKindOfClass:[NSArray class]]){
            return tags;
        }else if([tags isKindOfClass:[NSDictionary class]]){
            return [NSArray arrayWithObject:tags];
        }
    }else{
        NSLog(@"json nil ");
    }
    
    return nil;
}
@end
