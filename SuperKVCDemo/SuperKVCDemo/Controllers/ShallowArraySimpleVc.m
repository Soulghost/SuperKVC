//
//  ShallowArraySimpleVc.m
//  SuperKVCDemo
//
//  Created by soulghost on 12/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "ShallowArraySimpleVc.h"
#import "UserPartnerCell.h"
#import "UserModel.h"
#import "SuperKVC.h"

static NSString *cellId = @"UserPartnerCell";

@interface ShallowArraySimpleVc ()

@property (nonatomic, strong) NSArray<UserModel *> *userArray;

@end

@implementation ShallowArraySimpleVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass([self class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id responseObject = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shallow_array" ofType:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    self.userArray = [responseObject sk_injectWithInjector:^(SuperKVCInjector *injector) {
        injector.bind([UserModel class]);
        injector.mapping(@"id").to(@"userId");
        injector.format(@"birthday").with.converter(^NSDate* (NSString *birthdayString) {
            NSDateFormatter *fmt = [NSDateFormatter new];
            fmt.dateFormat = @"yyyy-MM-dd";
            return [fmt dateFromString:birthdayString];
        });
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserPartnerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.user = self.userArray[indexPath.row];
    return cell;
}

@end
