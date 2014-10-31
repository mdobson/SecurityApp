//
//  DetailViewController.h
//  SecurityApp
//
//  Created by Matthew Dobson on 10/30/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SHMKit/SHMKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) SHMEntity* detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

