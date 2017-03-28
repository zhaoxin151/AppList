//
//  HBAppInfoCell.h
//  AppList
//
//  Created by NATON on 2017/3/28.
//  Copyright © 2017年 NATON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBAppInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
