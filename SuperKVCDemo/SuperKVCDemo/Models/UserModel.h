//
//  UserModel.h
//  SuperKVCDemo
//
//  Created by soulghost on 12/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CardModel;

@interface UserModel : NSObject

@property (nonatomic, assign) int64_t userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, strong) NSArray *partners;
@property (nonatomic, strong) NSArray<CardModel *> *cards;

@end
