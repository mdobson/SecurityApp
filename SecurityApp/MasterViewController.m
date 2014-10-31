//
//  MasterViewController.m
//  SecurityApp
//
//  Created by Matthew Dobson on 10/30/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <SHMKit/SHMKit.h>
#import <SHMKit/SHMRequestFactory.h>
#import "AppDelegate.h"

NSString * const endpoint = @"http://zetta-instructor.herokuapp.com/";
NSString * const systemQuery = @"where type = \"security-system\"";
NSString * const serverRel = @"http://rels.zettajs.io/server";
NSString * const peerRel = @"http://rels.zettajs.io/peer";

@interface MasterViewController ()

@property (nonatomic, retain) NSMutableArray *systems;
@property (nonatomic, retain) SHMParser *parser;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parser = [[SHMParser alloc] initWithSirenRoot:endpoint];
    self.systems = [[NSMutableArray alloc] init];
    SHMRequestFactory *factory = [SHMRequestFactory sharedFactory];
    factory.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.parser retrieveRoot:^(NSError *err, SHMEntity *entity) {
        if(err) {
            NSLog(@"Error:%@", err);
        } else {
            //Iterate through links. If it's a server request and search for securoty systems.
            SHMAction *action = [entity getSirenAction:@"query-devices"];
            for (SHMLink *link in entity.links) {
                if ([link.rel containsObject:peerRel]) {
                    NSDictionary *params = @{@"ql": systemQuery, @"server": link.title};
                    NSLog(@"PARAMS:%@", params);
                    [action performActionWithFields:params andCompletion:^(NSError *error, SHMEntity *entity) {
                        if (error) {
                            NSLog(@"Error retrieving objects: %@", err);
                        } else {
                            if (entity.entities.count > 0) {
                                for (SHMEntity *resultEntity in entity.entities) {
                                    NSLog(@"ENTITY:%@", resultEntity.links);
                                    [resultEntity stepToLinkRel:@"self" withCompletion:^(NSError *error, SHMEntity *entity) {
                                        if (err) {
                                            NSLog(@"Error getting full system");
                                        } else {
                                            [self.systems addObject:entity];
                                            [self.tableView reloadData];
                                        }
                                    }];
                                }
                            }
                        }
                    }];
                }
            }
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SHMEntity *object = self.systems[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.systems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    SHMEntity *object = self.systems[indexPath.row];
    cell.textLabel.text = object.properties[@"name"];
    cell.detailTextLabel.text = object.properties[@"state"];
    if ([object.properties[@"state"] isEqualToString:@"armed"]) {
        cell.detailTextLabel.textColor = [UIColor greenColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    return cell;
}

@end
