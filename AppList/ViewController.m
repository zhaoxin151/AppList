//
//  ViewController.m
//  AppList
//
//  Created by NATON on 2017/3/28.
//  Copyright © 2017年 NATON. All rights reserved.
//

#import "ViewController.h"
#import "DeviceAppInfo.h"
#import "HBAppInfoCell.h"
#import <objc/runtime.h>


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *listArr;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation ViewController

#pragma mark -- life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self accessAppList]; //获取系统app列表
}

#pragma mark --- init
- (NSArray *)listArr {
    if(!_listArr) {
        _listArr = [[NSArray alloc] init];
    }
    return _listArr;
}

#pragma mark -- InitDataSource
- (void)accessAppList {
    self.listArr = [DeviceAppInfo deviceApplist:ShowAllAppStyle];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    HBAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[HBAppInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dic = [self.listArr objectAtIndex:indexPath.row];
    NSLog(@"appNum :%d",self.listArr.count);
    cell.iconImage.image = [UIImage imageWithData:[dic objectForKey:@"appIcon"]];
    cell.titleLabel.text = [dic objectForKey:@"appName"];
    cell.detailLabel.text = [NSString stringWithFormat:@"版本号:%@", [dic objectForKey:@"version"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.listArr objectAtIndex:indexPath.row];
    NSString *appIdenfier = [dic objectForKey:@"appIdentifier"];
    Class cls = NSClassFromString(@"LSApplicationWorkspace");
    id s = [(id)cls performSelector:NSSelectorFromString(@"defaultWorkspace")];
    [s performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:appIdenfier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (IBAction)segmentChange:(UISegmentedControl *)sender {
    NSInteger selectIndex = sender.selectedSegmentIndex;
    switch (selectIndex) {
        case ShowAllAppStyle:
            self.listArr = [DeviceAppInfo deviceApplist:ShowAllAppStyle];
            break;
        case ShowDownloadAppStyle:
            self.listArr = [DeviceAppInfo deviceApplist:ShowDownloadAppStyle];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}



@end
