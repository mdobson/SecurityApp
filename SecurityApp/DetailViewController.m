//
//  DetailViewController.m
//  SecurityApp
//
//  Created by Matthew Dobson on 10/30/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "DetailViewController.h"
#import <SHMKit/SHMActionField.h>

@interface DetailViewController ()

@property (nonatomic, retain) SHMAction *action;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    NSLog(@"%@", _detailItem.properties);
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"%@", _detailItem.properties[@"state"]];
    }
    
    if([self.detailItem.properties[@"state"] isEqualToString:@"disarmed"]) {
        self.action = [self.detailItem getSirenAction:@"arm-system"];
    } else if([self.detailItem.properties[@"state"] isEqualToString:@"armed"]) {
        self.action = [self.detailItem getSirenAction:@"disarm-system"];
    } else if([self.detailItem.properties[@"state"] isEqualToString:@"alarm"]) {
        self.action = [self.detailItem getSirenAction:@"stop-alarm"];
    }
    
    [self setUpButton];
}

- (void)setUpButton {
    [self.actionButton setTitle:self.action.name forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(performAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) performAction {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (SHMActionField *field in self.action.fields) {
        params[field.name] = field.value;
    }
    
    [self.action performActionWithFields:params andCompletion:^(NSError *error, SHMEntity *entity) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            self.detailItem = entity;
            [self configureView];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
