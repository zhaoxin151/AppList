//
//  DeviceAppInfo.m
//  AppList
//
//  Created by NATON on 2017/3/28.
//  Copyright © 2017年 NATON. All rights reserved.
//

#import "DeviceAppInfo.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation DeviceAppInfo

+ (NSArray *)deviceApplist:(DeviceDisplayStyle)style; {
    Class cls = NSClassFromString(@"LSApplicationWorkspace");
    id s = [(id)cls performSelector:NSSelectorFromString(@"defaultWorkspace")];
    NSArray *arr = [s performSelector:NSSelectorFromString(@"allInstalledApplications")];
    NSMutableArray *iconList = [[NSMutableArray alloc] init];
    for (id item in arr) {
        NSDictionary *dic;
        switch (style) {
            case ShowAllAppStyle:
                dic = [self appInfoWithItem:item isShowSystem:YES];
                break;
            case ShowDownloadAppStyle:
                dic = [self appInfoWithItem:item isShowSystem:NO];
                break;
            default:
                break;
        }
        if(dic)
        {
            [iconList addObject:dic];
        }
    }
    return iconList;
}


+ (NSDictionary *)appInfoWithItem:(id)item isShowSystem:(BOOL)showSystem{
    BOOL isSystemOrInternalApp = [item performSelector:NSSelectorFromString(@"isSystemOrInternalApp")];
    if(!showSystem) {
        if(isSystemOrInternalApp) {
            return nil;
        }
    }
    NSMutableDictionary *appInfoDic = [[NSMutableDictionary alloc] init];
    NSString *bundleIdentifier = [item performSelector:NSSelectorFromString(@"bundleIdentifier")];
    if(bundleIdentifier) {
        [appInfoDic setValue:bundleIdentifier forKey:@"appIdentifier"];
    }
    //获取icon
    NSData *data = [item performSelector:NSSelectorFromString(@"iconDataForVariant:") withObject:@(2)];
    UIImage *image = [self imageWithImageData:data];
    if(image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        [appInfoDic setValue:imageData forKey:@"appIcon"];
    }
    
    NSString *localizeName = [item performSelector:NSSelectorFromString(@"localizedName")];
    if(localizeName) {
        [appInfoDic setValue:localizeName forKey:@"appName"];
    }
    
    NSString *version = [item performSelector:NSSelectorFromString(@"bundleVersion")];
    if(version) {
        [appInfoDic setValue:version forKey:@"version"];
    }
    return appInfoDic;
}

+ (UIImage *)imageWithImageData:(NSData *)imageData {
    NSInteger lenth =  imageData.length;
    NSInteger width = 87;
    NSInteger height = 87;
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
    [imageData getBytes:pixels range:NSMakeRange(32, lenth - 32)];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //  注意此处的 bytesPerRow 多加了 4 个字节
    CGContextRef ctx = CGBitmapContextCreate(pixels, width, height, 8, (width + 1) * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    UIImage *icon = [UIImage imageWithCGImage: cgImage];
    CGImageRelease(cgImage);
    
    return icon;
}

+ (NSString *)stringWithInstallSize:(CGFloat)installSize {
    NSArray *units = @[ @"B", @"KB", @"MB", @"GB"];
    NSString *unit = @"B";
    NSInteger i = 0;
    while (installSize >= 1024) {
        
        installSize /= 1024;
        ++i;
        unit = [units objectAtIndex: i];
    }
    
    return [NSString stringWithFormat:@"%.2f %@", installSize, unit];
}

@end
