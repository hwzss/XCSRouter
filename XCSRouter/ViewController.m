//
//  ViewController.m
//  XCSRouter
//
//  Created by kaifa on 2018/11/15.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import "ViewController.h"
#import "XCSRouter.h"
#import "SecondController.h"

@interface CellItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^oprationBlock)(void);
@end

@implementation CellItem

@end

static NSString * const kTableViewCellIndentifier = @"kTableViewCellIndentifier";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArrs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XCSRouter";
    [self initializeViews];
    [self initializeViewsData];
    [self registerRouters];
    [self.tableView reloadData];
    
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"asdf%p", self);
}

- (void)registerRouters {
    /* 方式一 */
    [XCSRouter registerRouterUrl:@"abc" toHandlder:^(NSDictionary *params) {
        SecondController *aVc = [[SecondController alloc] init];
        [self presentViewController:aVc animated:YES completion:nil];
        return aVc;
    }];
    /* 方式二 */
    [XCSRouter registerRouterUrl:@"acd" toControllerClassStr:@"SecondController"];
}

- (void)initializeViews {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 66;
    tableView.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIndentifier];
    
    _tableView = tableView;
}

- (void)initializeViewsData {
    CellItem *item0 = ({
        CellItem *item = [[CellItem alloc] init];
        item.title = @"acd 作为 url, SecondController 注册数据";
        item.oprationBlock = ^{
            [XCSRouter router:@"acd"];
        };
        item;
    });
    
    CellItem *item3 = ({
        CellItem *item = [[CellItem alloc] init];
        item.title = @"abc 作为 url, block 注册数据 ";
        item.oprationBlock = ^{
            [XCSRouter router:@"abc"];
        };
        item;
    });
    
    CellItem *item1 = ({
        CellItem *item = [[CellItem alloc] init];
        item.title = @"没有注册 router 的情况下, 直接使用类名 ThirdVc 作为 url, Third 实现了 XCSRouterRequestProtocl";
        item.oprationBlock = ^{
            [XCSRouter router:@"ThirdVc"];
        };
        item;
    });
    CellItem *item2 = ({
        CellItem *item = [[CellItem alloc] init];
        item.title = @"FourthVc 没有注册 router 也没有实现协议, 默认是 push 出来";
        item.oprationBlock = ^{
            [XCSRouter router:@"FourthVc?title=哈哈哈😂"];
        };
        item;
    });
    
    CellItem *item4 = ({
        CellItem *item = [[CellItem alloc] init];
        item.title = @"FifthVc 没有注册 router 实现协议但不做跳转只获取参数, 默认是 push 出来";
        item.oprationBlock = ^{
            [XCSRouter router:@"FifthVc?aKey=哈哈哈😂"];
        };
        item;
    });
    
    CellItem *item5 = ({
        CellItem *item = [[CellItem alloc] init];
        item.title = @"FourthVc 传除字符串意外的格式参数";
        item.oprationBlock = ^{
            [XCSRouter routerFormatUrl:@"FourthVc?bgColor=%@&title=%@", [UIColor redColor], @"笑颜"];
        };
        item;
    });
    
    _dataArrs = [NSMutableArray new];
    [_dataArrs addObjectsFromArray:@[ item0, item3, item1, item2, item4, item5]];
}

#pragma -mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellItem *model = _dataArrs[indexPath.row];
    if(model.oprationBlock) model.oprationBlock();
}

#pragma -mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIndentifier forIndexPath:indexPath];
    if (cell.textLabel.numberOfLines) {
        cell.textLabel.numberOfLines = 0;
    }
    
    CellItem *model = _dataArrs[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [XCSRouter router:@"acd"];
}


@end
