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

@interface ViewController ()
{
    NSMutableArray *blockedSitesArray;
    NSString *newlyAddedSite;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    blockedSitesArray = [[NSMutableArray alloc]init];
    [self readJSONandRefreshTableviewArray];
    [ SFContentBlockerManager reloadContentBlockerWithIdentifier:@"net.noizystudios.Website-Blocker.WebBlcoker" completionHandler:nil];
    
   
}

- (void)readJSONandRefreshTableviewArray
{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"blockerList" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error = nil;
    
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions error:&error];
    
    BlockedSite *blockedURL = [[BlockedSite alloc]init];
 
    if (!(blockedSitesArray == nil || [blockedSitesArray count] == 0))
    {
        [blockedSitesArray removeAllObjects];
    }
    
    
    NSDictionary *boempatat = [jsonResults valueForKey:@"trigger"];
    //  NSDictionary *pff = [jsonResults]
    for (NSDictionary* kak in boempatat)
    {
        // NSDictionary *patatje = [jsonResults valueForKey:@"trigger"];
        blockedURL.url = [kak valueForKey:@"url-filter"];
        [blockedSitesArray addObject:blockedURL];
        
        NSLog(@"Dit is kak:%@", blockedURL.url);
    }
    
  

    
    
   // NSLog(@"Dit is de json: %@", jsonResults);
}

- (void)addURLToJson
{
   
    newlyAddedSite = @"debolle.be";
    
    
    NSDictionary *action = @{@"type": @"block"};
 
    NSDictionary *trigger = @{@"url-filter": newlyAddedSite };
    
    NSDictionary *json = @{
                           @"action": action,
                           @"trigger" : trigger,
                        
                           };
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    
   NSLog(@"Dit is de json string: %@", jsonStr);
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)RefreshButtonPressed:(UIBarButtonItem *)sender
{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.noizystudios.websiteblocker"];
    id value = [shared valueForKey:@"json"];
   
    BlockedSite *Blockurl = [[BlockedSite alloc]init];
    
    Blockurl.url = [value valueForKey:@"URL"];
    NSLog(@"DE WAARDE VAN DE NIEUWE SITE 1 2 %@",  Blockurl.url);
    [self readJSONandRefreshTableviewArray];
    [self addURLToJson];
    [blockedSitesArray addObject:Blockurl];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [blockedSitesArray count];
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        
    }
    
    BlockedSite *blockURL =  [blockedSitesArray objectAtIndex:indexPath.row];
    
    NSLog(@"Indexpath: %ld",(long)indexPath.row);
    cell.textLabel.text = blockURL.url;
    return cell;

}

@end
