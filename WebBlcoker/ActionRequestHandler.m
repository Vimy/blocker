//
//  ActionRequestHandler.m
//  WebBlcoker
//
//  Created by Matthias Vermeulen on 27/06/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "ActionRequestHandler.h"
#import "OrderedDictionary.h"

@interface ActionRequestHandler ()

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    
    
    
    
    //parse json
    //uitableview
    //
    NSLog(@"Web extensions geladen");
    
    
    //kopie maken van blockerlist
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
  //  NSString *jsonPath = [documentsDirectory stringByAppendingPathComponent:@"blockList.json"];
    
     NSString *filePath= [documentsDirectory stringByAppendingPathComponent:@"blockList.json"];
    
    
        if ([fileManager fileExistsAtPath:filePath] == NO)
        {
            
            NSDictionary *action = @{@"type": @"block"};
            
            NSDictionary *trigger = @{@"url-filter": @"" };
            
            OrderedDictionary *newJSON2 = [[OrderedDictionary alloc]init];
            
            [newJSON2 insertObject:action forKey:@"action" atIndex:0];
            [newJSON2 insertObject:trigger forKey:@"trigger" atIndex:1];
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
            NSMutableArray *newArray = [[NSMutableArray alloc]init];
            
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
            [jsonStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

            
            NSLog(@"Nu gebruiken we de extension!");
//            if ([fileManager fileExistsAtPath:filePath])
//            {
//                [fileManager removeItemAtPath:filePath error:&error];
//                [jsonStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            }

        }
    
    
    
        NSURL *jsonURL = [NSURL fileURLWithPath: filePath];
        
    
    
        NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:jsonURL];
        

    
//    
//    if ([fileManager fileExistsAtPath:jsonPath] == NO)
//    {
//        NSString *resourcePath =  [[NSBundle mainBundle] pathForResource:@"blockerList" ofType:@"json"];
//        
//        [fileManager copyItemAtPath:resourcePath toPath:jsonPath error:&error];
//    }
//
//    NSURL *jsonURL = [NSURL fileURLWithPath: jsonPath];
//    
//    
//
//    NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:jsonURL];
//    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.attachments = @[attachment];
    
    [context completeRequestReturningItems:@[item] completionHandler:nil];
}


@end
