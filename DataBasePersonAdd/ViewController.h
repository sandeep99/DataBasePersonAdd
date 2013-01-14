//
//  ViewController.h
//  DataBasePersonAdd
//
//  Created by thinksysuser on 26/12/12.
//  Copyright (c) 2012 thinksysuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "person.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
//IBOutlet UITableView *myTableView;
}


@property (weak,nonatomic) IBOutlet UITextField *nameField;
@property (weak,nonatomic) IBOutlet UITextField *ageField;
@property (weak,nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)addPersonButton:(id)sender;
- (IBAction)displayPersonButton:(id)sender;
- (IBAction)deletePersonButton:(id)sender;
@end
