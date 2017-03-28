//
//  DeviceAppInfo.h
//  AppList
//
//  Created by NATON on 2017/3/28.
//  Copyright © 2017年 NATON. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ShowAllAppStyle = 0,
    ShowDownloadAppStyle = 1,
} DeviceDisplayStyle;

@interface DeviceAppInfo : NSObject

+ (NSArray *)deviceApplist:(DeviceDisplayStyle)style;

@end
