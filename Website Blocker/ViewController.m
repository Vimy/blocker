//
//  ViewController.m
//  Website Blocker
//
//  Created by Matthias Vermeulen on 27/06/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "ViewController.h"
#import "BlockedSite.h"
#import <SafariServices/SafariServices.h>
#import "OrderedDictionary.h"
#import "AddSiteViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface ViewController ()
{
    NSMutableArray *blockedSitesArray;
    NSString *filePath;
    NSMutableDictionary *jsonResults;
    IBOutlet UIBarButtonItem *addSiteButton;
    IBOutlet UIBarButtonItem *RefreshButton;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navigationController.navigationBar.barTintColor = Rgb2UIColor(255, 84, 134);
    self.tableView.backgroundColor = Rgb2UIColor(59, 210, 255);
     self.navigationController.navigationBar.translucent = NO;
    [RefreshButton setTintColor:Rgb2UIColor(204, 191, 27)];
    [addSiteButton setTintColor:Rgb2UIColor(204, 191, 27)];
    blockedSitesArray = [[NSMutableArray alloc]init];
 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    filePath= [documentsDirectory stringByAppendingPathComponent:@"blockList.json"];
    
    if ([fileManager fileExistsAtPath:filePath] == NO)
    {
        
        [self addURLToJson:@"www.site.be"];
//        NSString *resourcePath =  [[NSBundle mainBundle] pathForResource:@"blockerList" ofType:@"json"];
//        
//        [fileManager copyItemAtPath:resourcePath toPath:filePath error:&error];
    }
    
   [self readJSONandRefreshTableviewArray];
    

    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"DIT IS DE CONTENT: %@", content);
    [ SFContentBlockerManager reloadContentBlockerWithIdentifier:@"net.noizystudios.Website-Blocker.WebBlcoker" completionHandler:nil];

    
}

- (void)readJSONandRefreshTableviewArray
{
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error = nil;
    
    jsonResults = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions error:&error];
    
 
    
    
    if (!(blockedSitesArray == nil || blockedSitesArray.count == 0))
    {
        [blockedSitesArray removeAllObjects];
    }
    
  
    NSDictionary *triggerDic = [jsonResults valueForKey:@"trigger"];
    
    
    
    for (NSDictionary* dic in triggerDic)
    {
        BlockedSite *blockedURL = [[BlockedSite alloc]init];

        blockedURL.url = [dic valueForKey:@"url-filter"];
        [blockedSitesArray addObject:blockedURL];
  
    }

    [self.tableView reloadData];
    
}
- (IBAction)tappedAddSiteButton:(UIBarButtonItem *)sender
{
    NSLog(@"Gedaan!");
     AddSiteViewController *urlAddViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSiteViewController"];
    

    urlAddViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:urlAddViewController animated:YES completion:nil];
    
}


- (void)addURLToJson:(NSString *)newlyAddedSite
{
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i< blockedSitesArray.count;i++)
    {
        OrderedDictionary *newJSON = [[OrderedDictionary alloc]init];

       

        BlockedSite *blockedURL = blockedSitesArray[i];
        NSDictionary *action = @{@"type": @"block"};
        NSDictionary *trigger = @{@"url-filter": blockedURL.url };
        [newJSON insertObject:action forKey:@"action" atIndex:0];
        [newJSON insertObject:trigger forKey:@"trigger" atIndex:1];
            [newDic addEntriesFromDictionary:newJSON];
            [newArray addObject:newJSON];
      
    }
   
    
    NSDictionary *action = @{@"type": @"block"};
 
    NSDictionary *trigger = @{@"url-filter": newlyAddedSite };
    
    OrderedDictionary *newJSON2 = [[OrderedDictionary alloc]init];

    [newJSON2 insertObject:action forKey:@"action" atIndex:0];
    [newJSON2 insertObject:trigger forKey:@"trigger" atIndex:1];
    
    
    [newDic addEntriesFromDictionary:newJSON2];
    [newArray addObject:newJSON2];
    //http://stackoverflow.com/questions/11106584/appending-to-the-end-of-a-file-with-nsmutablestring
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:newArray
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    
   NSLog(@"Dit is de json string: %@", jsonStr);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    filePath= [documentsDirectory stringByAppendingPathComponent:@"blockList.json"];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:&error];
        [jsonStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    else
    {
        [jsonStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

        // NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"txt"];
//        NSString *resourcePath =  [[NSBundle mainBundle] pathForResource:@"blockerList" ofType:@"json"];
//        
//        [fileManager copyItemAtPath:resourcePath toPath:filePath error:&error];
    }

    
    [ SFContentBlockerManager reloadContentBlockerWithIdentifier:@"net.noizystudios.Website-Blocker.WebBlcoker" completionHandler:nil];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)RefreshButtonPressed:(UIBarButtonItem *)sender
{
    
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.noizystudios.websiteblocker"];
    id value = [shared valueForKey:@"URL"];
   BlockedSite *Blockurl = [[BlockedSite alloc]init];
 
    
    if (value)
    {
        Blockurl.url = [value valueForKey:@"URL"];
        NSLog(@"DE WAARDE VAN DE NIEUWE SITE 1 2 %@",  Blockurl.url);
        [self addURLToJson:Blockurl.url];
        [self readJSONandRefreshTableviewArray];
    }
    else
    {
        NSLog(@"Geen site ontvangen!");
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return blockedSitesArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    
    cell.backgroundColor = Rgb2UIColor(59, 210, 255);
    
    BlockedSite *blockURL =  blockedSitesArray[indexPath.row];
    
    NSLog(@"Indexpath: %ld",(long)indexPath.row);
    cell.textLabel.text = blockURL.url;
    return cell;

}

@end
