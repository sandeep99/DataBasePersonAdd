//
//  ViewController.m
//  DataBasePersonAdd
//
//  Created by thinksysuser on 26/12/12.
//  Copyright (c) 2012 thinksysuser. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    NSMutableArray *arrayOfPerson;
    sqlite3 *personDB;
    NSString *dbPathString;
}


@end

@implementation ViewController
@synthesize myTableView, nameField, ageField;


//@synthesize myTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self myTableView]setDelegate:self];
    [[self myTableView]setDataSource:self];
       //adding array of person
    arrayOfPerson = [[NSMutableArray alloc]init];
    [self creatOrOpendataBase];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [[self myTableView]setDelegate:self];
//    [[self myTableView]setDataSource:self];
//    //adding array of person
//    arrayOfPerson = [[NSMutableArray alloc]init];
//    [self creatOrOpendataBase];
//}


-(void)creatOrOpendataBase
{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
                                                         
    NSString *docpath = [path objectAtIndex:0];
    dbPathString= [docpath stringByAppendingPathComponent:@"COIN.sqlite"];
    char *error;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:dbPathString]) {
        
        const char *dbpath = [dbPathString UTF8String];
        //create database
        if(sqlite3_open(dbpath, &personDB)==SQLITE_OK)
        {
            NSLog(@"Database path Found");
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS COIN( ID INTEGER PRIMARY KEY AUTOINCREMENT ,NAME TEXT, AGE INTEGER)";
            if(sqlite3_exec(personDB, sql_stmt, NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"table created");
            }
            else
            {
                NSLog(@"table is not created");
            }
            sqlite3_close(personDB);
        }
    }
    
}
//creating the no of section in persons table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfPerson count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifire = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifire];

        person *aperson =[arrayOfPerson objectAtIndex:indexPath.row];
        
        cell.textLabel.text = aperson.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",aperson.age];
            }
    return cell;

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPersonButton:(id)sender
{    
    char  *error;
    
    if (sqlite3_open([dbPathString UTF8String], &personDB)==SQLITE_OK) {
        NSString *insertstmt = [NSString stringWithFormat:@"INSERT INTO COIN(NAME,AGE) values('%s','%d')", [self.nameField.text UTF8String],[self.ageField.text intValue]];
        
        const char *insert_stmt = [insertstmt UTF8String];
        if(sqlite3_exec(personDB,insert_stmt , NULL, NULL,&error)==SQLITE_OK)
        {
            NSLog(@"person added");
            
            person *person1 = [[person alloc]init];
            [person1 setName:self.nameField.text];
            [person1 setAge:[self.ageField.text intValue]];
            [arrayOfPerson addObject:person1];
        }
        
        sqlite3_close(personDB);
    }
}
- (IBAction)displayPersonButton:(id)sender {
    
    sqlite3_stmt *statement;
    if(sqlite3_open([dbPathString UTF8String], &personDB))
    {
        [arrayOfPerson removeAllObjects];
        
        NSString *quarrySql = [NSString stringWithFormat:@"SELECT * FROM COIN"];
        const char *quarry_sql = [quarrySql UTF8String];
        if (sqlite3_prepare(personDB, quarry_sql,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW)
        {
            NSString *name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            NSString *ageString = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            person *person1 = [[person alloc]init];
            
            [person1 setName:name];
            [person1 setAge:[ageString intValue]];
            [arrayOfPerson addObject:person1];
        
        }
            
            
        }
    }
    [[self myTableView ]reloadData];
}

- (IBAction)deletePersonButton:(id)sender {
    
    [[self myTableView]setEditing:!self.myTableView.editing animated:YES];
        
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle==UITableViewCellEditingStyleDelete) {
        person *p = [arrayOfPerson objectAtIndex:indexPath.row];
        [self deleteDeta:[NSString stringWithFormat:@"Delete from coin where name '%s'",[p.name UTF8String]]];
        [arrayOfPerson removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }    }

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   [super touchesBegan:touches withEvent:event];
    [[self nameField]resignFirstResponder];
    [[self ageField]resignFirstResponder];
}
-(void)deleteDeta :(NSString *)deleteQuary

{
     char *error;
    if (sqlite3_exec(personDB,[deleteQuary UTF8String], NULL, NULL, &error)) {
        
        NSLog(@"person Deleted");
    }
 }

@end
