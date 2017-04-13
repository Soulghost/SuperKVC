//
//  DeepArraySampleVc.m
//  SuperKVCDemo
//
//  Created by soulghost on 12/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "DeepArraySampleVc.h"
#import "UserCardCell.h"
#import "UserModel.h"
#import "CardModel.h"
#import "SuperKVC.h"

static NSString *cellId = @"UserCardCell";

@interface DeepArraySampleVc ()

@property (nonatomic, strong) NSArray<UserModel *> *userArray;

@end

@implementation DeepArraySampleVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass([self class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self injectWithInjector];
}

- (void)injectWithInjector {
    id responseObject = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"deep_array" ofType:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSArray *userArray = [responseObject sk_injectWithInjector:^(SuperKVCInjector *injector) {
        injector.bind([UserModel class]);
        injector.mapping(@"id").to(@"userId");
        injector.format(@"birthday").with.converter(^NSDate* (NSString *birthdayString) {
            return [fmt dateFromString:birthdayString];
        });
        injector.format(@"cards").with.converter(^CardModel* (NSDictionary *cardDictArray) {
            return [cardDictArray sk_dequeInjectorForClass:[CardModel class] emptyHandler:^(SuperKVCInjector *injector) {
                injector.bind([CardModel class]);
                injector.mapping(@"id").to(@"cardId");
                injector.mapping(@"expire").to(@"expireDate");
                injector.format(@"expireDate").with.converter(^NSDate* (NSString *birthdayString) {
                    return [fmt dateFromString:birthdayString];
                });
            }];
        });
    }];
    self.userArray = userArray;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.user = self.userArray[indexPath.row];
    return cell;
}

@end
