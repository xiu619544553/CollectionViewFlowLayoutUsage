//
//  TableViewController.m
//  CollectionViewFlowLayoutUsage
//
//  Created by hello on 2021/3/26.
//

#import "TableViewController.h"
#import "CentralCardLayoutUsageController.h"
#import "WaterFallFlowLayoutUsageController.h"
#import "OnePixelSpacingViewController.h"

static NSString *cellIdentifier = @"UITableViewCell";
static NSString *keyForTitle = @"title";
static NSString *keyForVc = @"vc";

@interface TableViewController ()

@property (nonatomic, strong) NSArray<NSDictionary *> *dataSources;

@end

@implementation TableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Layout 使用";

    self.dataSources = @[
        @{
            keyForVc : WaterFallFlowLayoutUsageController.class,
            keyForTitle : @"瀑布流"
        },
        @{
            keyForVc : CentralCardLayoutUsageController.class,
            keyForTitle : @"卡片式"
        },
        @{
            keyForVc : OnePixelSpacingViewController.class,
            keyForTitle : @"UICollectionView 动态设置 Cell 间距"
        }
    ];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellIdentifier];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [self.dataSources objectAtIndex:indexPath.row];
    
    Class vcCls = [dict objectForKey:keyForVc];
    NSString *title = [dict objectForKey:keyForTitle];
    
    UIViewController *vc = [vcCls new];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [self.dataSources objectAtIndex:indexPath.row];
    
    NSString *title = [dict objectForKey:keyForTitle];
    
    cell.textLabel.text = title;
    
    return cell;
}

@end
