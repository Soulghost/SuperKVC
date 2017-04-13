//
//  CardModel.h
//  SuperKVCDemo
//
//  Created by soulghost on 12/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject

@property (nonatomic, assign) int64_t cardId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *expireDate;

@end
