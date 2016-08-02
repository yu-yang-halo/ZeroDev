//
//  AppManager.m
//  ZeroDev
//
//  Created by admin on 15/11/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "AppManager.h"
#import "ZipArchive.h"
@implementation AppManager

const NSString *ROOT=@"uilibs";
const NSString *UI=@"ui";
//资源根路径
+(NSString *)homePath{
    NSString *HOME_PATH=[[self documentPath] stringByAppendingPathComponent:ROOT];
    
    BOOL isDir;
    if(![[NSFileManager defaultManager] fileExistsAtPath:HOME_PATH isDirectory:&isDir]){
        BOOL isCreateDirSuccess=[[NSFileManager defaultManager] createDirectoryAtPath:HOME_PATH withIntermediateDirectories:YES attributes:nil error:NULL];
        if(isCreateDirSuccess){
            NSLog(@"HOME 目录创建成功");
        }else{
            NSLog(@"HOME 目录创建失败");
        }
       
    }
    return HOME_PATH;
}

//ui 路径
+(NSString *)uiRootPath{
    return [[self homePath] stringByAppendingPathComponent:UI];
}
+(NSString *)imgRootPath{
    return [[self uiRootPath] stringByAppendingPathComponent:@"img"];
}

+(NSString *)bundleUIPath{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:UI];
}

+(NSString *)addPointZip:(NSString *)url{
    
    if(![url hasSuffix:@".zip"]){
        url=[url stringByAppendingPathExtension:@"zip"];
        NSLog(@"URL :%@",url);
    }
    
    return url;
}

+(void)downloadApp:(NSString *)url block:(DataHandler)handler{
    /*
        首先下载云端配置界面zip文件到res.zip{
           img目录
           mobileApp.json
           class.json
           application.json
        }
         
     
     
        第1步: 拷贝 ui.zip到本地
        第2步: 解压 本地ui.zip
        第3步: 拷贝 res.zip 到ui/下
        第4步: 解压 res.zip
     
     */
    url=[self addPointZip:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSString *bundleReszipPath=[[self homePath] stringByAppendingPathComponent:@"res.zip"];
        NSString *targetReszipPath=[[self uiRootPath] stringByAppendingPathComponent:@"res.zip"];
        
        [self downloadWebResource:url tofile:bundleReszipPath];
        
        
        NSString *bundleuizipPath=[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ui/ui.zip"];
        NSString *targetuizipPath=[[self homePath] stringByAppendingPathComponent:@"ui.zip"];
        
        [self copyfile:bundleuizipPath toTarget:targetuizipPath];
        
        
        
        /* 解压uilibs/ 下的ui.zip文件 */
        BOOL step0=[self OpenZip:targetuizipPath unzipto:[self homePath]];
        BOOL step1=NO;
        BOOL step2=NO;
        if(step0){
            NSLog(@"解压UI zip文件成功---1");
            step1=[self copyfile:bundleReszipPath toTarget:targetReszipPath];
            if(step1){
                NSLog(@"拷贝res.zip 文件到UI目录成功---2");
                step2=[self OpenZip:targetReszipPath unzipto:[self uiRootPath]];
                if(step2){
                     NSLog(@"解压res.zip 文件成功---3");
                }
            }
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(step1&&step2&&step0){
                handler(YES);
            }else{
                handler(NO);
            }
            
            
        });
        
        
    });
   
    
    
}

+(BOOL)downloadWebResource:(NSString *)webPath tofile:(NSString *)saveFilePath{
    
        NSLog(@"saveFilePath : %@",saveFilePath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
    
        if ([fileManager fileExistsAtPath:saveFilePath])
        {
            BOOL isDeleteFile=[fileManager removeItemAtPath:saveFilePath error:nil];
            if(isDeleteFile){
                NSLog(@"%@ 文件已删除...",saveFilePath);
            }
        }
        
        NSURL *url = [NSURL URLWithString:webPath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        BOOL isWriteToFile=[fileManager createFileAtPath:saveFilePath contents:data attributes:nil];
        
        //BOOL isWriteToFile=[data writeToFile:saveFilePath atomically:NO];//将NSData类型对象data写入文件，文件名为FileName
        
        return isWriteToFile;
    
}
+(BOOL)movefile:(NSString *)srcfile toTarget:(NSString *)dstfile{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSError *err;
    BOOL retSuc=NO;
    if([manager fileExistsAtPath:srcfile]){
        BOOL isDeleteDstFile=YES;
        if([manager fileExistsAtPath:dstfile]){
            
            isDeleteDstFile=[manager removeItemAtPath:dstfile error:nil];
        }
        if(isDeleteDstFile){
            
            
            BOOL moveSuc=[manager moveItemAtPath:srcfile toPath:dstfile error:&err];
            if(moveSuc){
                retSuc=moveSuc;
                NSLog(@"移动成功");
            }else{
                NSLog(@"移动失败%@",err);
            }
        }
        
    }else{
        NSLog(@"%@文件不存在",srcfile);
    }
    return retSuc;
    
}
+(BOOL)copyfile:(NSString *)srcfile toTarget:(NSString *)dstfile{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSError *err;
    BOOL retSuc=NO;
    if([manager fileExistsAtPath:srcfile]){
        BOOL isDeleteDstFile=YES;
        if([manager fileExistsAtPath:dstfile]){
            
            isDeleteDstFile=[manager removeItemAtPath:dstfile error:nil];
        }
        if(isDeleteDstFile){
            
            
            BOOL moveSuc=[manager copyItemAtPath:srcfile toPath:dstfile error:&err];
            if(moveSuc){
                retSuc=moveSuc;
                NSLog(@"拷贝成功");
            }else{
                NSLog(@"拷贝失败%@",err);
            }
        }
        
    }else{
        NSLog(@"%@文件不存在",srcfile);
    }
    return retSuc;
    
}


+(NSString *)documentPath{
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
    NSLog(@"documentPath %@",documentPath);
    return documentPath;
}

+ (BOOL)OpenZip:(NSString*)zipPath  unzipto:(NSString*)_unzipto
{
    NSFileManager *manager=[NSFileManager defaultManager];
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:zipPath] )
    {
        BOOL ret = [zip UnzipFileTo:_unzipto overWrite:YES];
        if( YES==ret )
        {
            
            BOOL isDeleteSourceFile=[manager removeItemAtPath:zipPath error:nil];
            if(isDeleteSourceFile){
               NSLog(@"解压成功,并删除源文件");
            }
            
            
            return ret;
        }
        [zip UnzipCloseFile];
    }
    return NO;
}

@end
