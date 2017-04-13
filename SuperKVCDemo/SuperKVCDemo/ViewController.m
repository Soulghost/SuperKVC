//
//  ViewController.m
//  SuperKVCDemo
//
//  Created by soulghost on 12/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "ViewController.h"
#import "ShallowDictSampleVc.h"
#import "ShallowArraySimpleVc.h"
#import "DeepArraySampleVc.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Samples";
    
}
- (IBAction)shallowDictClick:(id)sender {
    [self.navigationController pushViewController:[ShallowDictSampleVc new] animated:YES];
}

- (IBAction)shallowArrayClick:(id)sender {
    [self.navigationController pushViewController:[ShallowArraySimpleVc new] animated:YES];
}

- (IBAction)deepArrayClick:(id)sender {
    [self.navigationController pushViewController:[DeepArraySampleVc new] animated:YES];
}

@end
