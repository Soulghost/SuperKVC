//
//  UserCardCell.m
//  SuperKVCDemo
//
//  Created by soulghost on 12/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "UserCardCell.h"
#import "UserModel.h"
#import "CardModel.h"

@interface UserCardCell ()

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

@end

@implementation UserCardCell

- (void)setUser:(UserModel *)user {
    _user = user;
    self.idLabel.text = [NSString stringWithFormat:@"%@", @(user.userId)];
    if (self.user.isVip) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@[VIP]", self.user.name];
        self.nameLabel.textColor = [UIColor redColor];
    } else {
        self.nameLabel.text = self.user.name;
        self.nameLabel.textColor = [UIColor darkGrayColor];
    }
    self.birthdayLabel.text = self.user.birthday.description;
    if (!user.cards.count) return;
    NSMutableString *cardStr = @"--------- Card List ---------\n".mutableCopy;
    for (CardModel *cardModel in self.user.cards) {
        [cardStr appendFormat:@"Card Num:%@\nCard Name:%@\nExipre Date:%@\n---------------\n", @(cardModel.cardId), cardModel.name, cardModel.expireDate];
    }
    self.cardLabel.text = cardStr;
}

@end
