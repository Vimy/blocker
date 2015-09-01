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

@interface ViewController ()
{
    NSMutableArray *blockedSitesArray;
    //NSString *newlyAddedSite;
    NSString *filePath;
    NSMutableDictionary *jsonResults;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    blockedSitesArray = [[NSMutableArray alloc]init];
 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    filePath= [documentsDirectory stringByAppendingPathComponent:@"blockList.json"];
    
    if ([fileManager fileExistsAtPath:filePath] == NO) {
        // NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"txt"];
        NSString *resourcePath =  [[NSBundle mainBundle] pathForResource:@"blockerList" ofType:@"json"];
        
        [fileManager copyItemAtPath:resourcePath toPath:filePath error:&error];
    }
    
   [self readJSONandRefreshTableviewArray];
    

    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"DIT IS DE CONTENT: %@", content);

    
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
        // NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"txt"];
        NSString *resourcePath =  [[NSBundle mainBundle] pathForResource:@"blockerList" ofType:@"json"];
        
        [fileManager copyItemAtPath:resourcePath toPath:filePath error:&error];
    }

    

  //  NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
   
//
//    NSString *newString = [content substringToIndex:[content length]-2];
//    
//    NSMutableString *nieuweJSON = [[NSMutableString alloc]initWithString:newString];
//    [nieuweJSON appendString:@","];
//    [nieuweJSON appendString:jsonStr];
//    [nieuweJSON appendString:@"]"];
//    [nieuweJSON writeToFile:filePath atomically:YES
//encoding:NSUTF8StringEncoding error:nil];
//    
//    
//    NSLog(@"DIT IS DE NIEUWE CONTENT: %@", nieuweJSON);
    
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
        //[blockedSitesArray addObject:Blockurl];
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


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    
    BlockedSite *blockURL =  blockedSitesArray[indexPath.row];
    
    NSLog(@"Indexpath: %ld",(long)indexPath.row);
    cell.textLabel.text = blockURL.url;
    return cell;

}

@end
