//
//  ShallowDictSampleVc.m
//  SuperKVCDemo
//
//  Created by soulghost on 12/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "ShallowDictSampleVc.h"
#import "UserModel.h"
#import "SuperKVC.h"

@interface ShallowDictSampleVc ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UserModel *user;

@end

@implementation ShallowDictSampleVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass([self class]);
    self.view.backgroundColor = [UIColor whiteColor];
    self.label = [[UILabel alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.label];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id responseObject = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shallow_dict" ofType:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    self.user = [responseObject sk_injectWithInjector:^(SuperKVCInjector *injector) {
        injector.bind([UserModel class]);
        injector.mapping(@"id").to(@"userId");
        injector.format(@"birthday").with.converter(^NSDate* (NSString *birthdayString) {
            NSDateFormatter *fmt = [NSDateFormatter new];
            fmt.dateFormat = @"yyyy-MM-dd";
            return [fmt dateFromString:birthdayString];
        });
    }];
}

- (void)setUser:(UserModel *)user {
    self.label.text = [NSString stringWithFormat:@"id:%@\nname:%@(%@)\nbirthday:%@\npartners:%@",
                       @(user.userId), user.name, user.isVip ? @"VIP" : @"Common", user.birthday, user.partners];
}

@end
