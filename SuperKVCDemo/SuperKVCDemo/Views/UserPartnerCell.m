//
//  UserPartnerCell.m
//  SuperKVCDemo
//
//  Created by soulghost on 12/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "UserPartnerCell.h"
#import "UserModel.h"

@interface UserPartnerCell ()

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

@end

@implementation UserPartnerCell

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
    self.partnerLabel.text = [self.user.partners componentsJoinedByString:@"\n"];
    self.birthdayLabel.text = self.user.birthday.description;
}

@end
