//
//  SKVBindAttribute.h
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVAttribute.h"

@interface SKVBindAttribute : SKVAttribute

@property (nonatomic, assign) Class bindClass;

- (instancetype)initWithBindClass:(Class)bindClass;

@end
