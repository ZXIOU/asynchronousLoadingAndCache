//
//  AXUContactPersonsViewController2.m
//  Chat
//
//  Created by zxiou on 16/4/8.
//  Copyright © 2016年 Meng To. All rights reserved.
//

#import "AXUContactPersonsViewController.h"
#import "AXUMainCellTableViewCell.h"
#import "AXUContactPerson.h"

//屏幕宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface AXUContactPersonsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *contacts;
@property(nonatomic, strong) NSMutableDictionary *images;
@property(nonatomic, strong) NSMutableDictionary *operations;
@property(nonatomic, strong) NSOperationQueue* queue;
@property (strong, nonatomic) NSCache *memCache;

@end

@implementation AXUContactPersonsViewController

//加载视图
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加载子视图
    [self loadSubview];
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

#pragma mark - Private Method

//视图初始化
- (void)loadSubview
{
//    修改导航栏
    self.navigationItem.title = @"Contacts";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:48/255.0 green:134/255.0 blue:202/255.0 alpha:1.0]];
//    去掉导航栏下面的白线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    

//    设置tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.showsVerticalScrollIndicator = NO;  // 是否显示滚动条
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 不要分割线
    
//    [_tableView.tableHeaderView removeFromSuperview];
//    _tableView.tableHeaderView = nil;
    [self.view addSubview:_tableView];
//    [_tableView reloadData];
    
    
    _contacts = [[NSMutableArray alloc] init];
    _images = [[NSMutableDictionary alloc] init];
    _queue = [[NSOperationQueue alloc] init];
    _operations = [[NSMutableDictionary alloc] init];
    [self loadData];
}

- (void)loadData
{
//    NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
    
    AXUContactPerson *person1 = [[AXUContactPerson alloc] init];
    person1.id = @"579335";
    person1.name = @"张三";
    person1.nickname = @"Z";
    person1.sex = @"男";
    person1.age = [[NSNumber alloc] initWithInt:25];
    person1.birthday =@"1988-3-6";
    person1.company = @"华远";
    person1.phone = @"1698658976";
    [_contacts addObject:person1];
    
    AXUContactPerson *person2 = [[AXUContactPerson alloc] init];
    person2.id = @"579300";
    person2.name = @"李四";
    person2.nickname = @"L";
    person2.sex = @"男";
    person2.age = [[NSNumber alloc] initWithInt:35];
    person2.birthday =@"1978-3-6";
    person2.company = @"国贸";
    person2.phone = @"16956464564";
    [_contacts addObject:person2];
    
    AXUContactPerson *person3 = [[AXUContactPerson alloc] init];
    person3.id = @"579320";
    person3.name = @"王五";
    person3.nickname = @"W";
    person3.sex = @"男";
    person3.age = [[NSNumber alloc] initWithInt:25];
    person3.birthday =@"1988-3-6";
    person3.company = @"电信";
    person3.phone = @"13678787878";
    [_contacts addObject:person3];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nickname" ascending:NO];
    
    [_contacts sortedArrayUsingDescriptors:[NSMutableArray arrayWithObject:sortDescriptor]];
}

#pragma mark - Table view data source

// 返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

// 每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

// 设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

//返回二级列表的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 54;
}

//返回表尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.0;
}

//设置显示表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainCell";
    AXUMainCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[AXUMainCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    AXUContactPerson *person = [_contacts objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = person.name;
    cell.phoneLabel.text = person.phone;
    cell.sexLabel.text = person.sex;
    cell.imageLine.image = [UIImage imageNamed:@"line.png"];

    NSString *imageName = person.id;
    NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://www.easyicon.cn/download/png/", person.id, @"/256/"];

    //1.获取本地cache文件路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2.根据文件URL最后文件名作为文件名保存到本地 -> 文件名
    NSString *filePath = [path stringByAppendingString:@"/documents/"];
    NSString *imageFilePath = [filePath stringByAppendingPathComponent:imageName];
//    NSLog(@"%@", imageFilePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    UIImage *image = _images[imageName];
    
    if (image) {
//        内存缓存查找
        cell.headerPhoto.image = image;
    }
    else if([fileManager fileExistsAtPath:imageFilePath]){
//        磁盘缓存查找
        NSData* imageData = [NSData dataWithContentsOfFile:imageFilePath];
        image = [UIImage imageWithData:imageData];
        
//        缓存到内存
        if (image) {
            cell.headerPhoto.image = image;
            _images[imageName] = image;
        }
    }
    else{
//        缓存没找到只能异步下载
        cell.imageView.image = [UIImage imageNamed:@"placeholder"];
        
        NSBlockOperation *operation = _operations[imageName];
        if (nil == operation){
            
            __weak typeof(self) wself = self;
            operation = [NSBlockOperation blockOperationWithBlock:^{
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                UIImage *image = [UIImage imageWithData:imageData];
                
                //缓存到内存和磁盘
                if (image) {
                    wself.images[imageName] = image;
                    [UIImagePNGRepresentation(image) writeToFile:imageFilePath atomically:YES];
                }
                
                //回到主线程刷新表格
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // 从字典中移除下载操作 (防止operations越来越大，保证下载失败后，能重新下载)
                    [wself.operations removeObjectForKey:imageName];
                    
                    //刷新当前行的图片数据
                    [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }];
            
            //添加操作到队列中
            [_queue addOperation:operation];
            //添加到字典中
            _operations[imageName] = operation;
        }
    }

    return cell;
}

//快速滑动时暂停下载
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 暂停下载
    [_queue setSuspended:YES];
}


//当用户停止拖拽表格时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 恢复下载
    [_queue setSuspended:NO];
}


#pragma mark - Table view delegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
//    取消所有的内存缓存和下载
    [self.queue cancelAllOperations];
    [self.operations removeAllObjects];
    [self.images removeAllObjects];
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

@end