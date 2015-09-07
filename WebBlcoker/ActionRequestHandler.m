//
//  ActionRequestHandler.m
//  WebBlcoker
//
//  Created by Matthias Vermeulen on 27/06/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "ActionRequestHandler.h"

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
    
    NSString *jsonPath = [documentsDirectory stringByAppendingPathComponent:@"blockList.json"];
    
    if ([fileManager fileExistsAtPath:jsonPath] == NO)
    {
        NSString *resourcePath =  [[NSBundle mainBundle] pathForResource:@"blockerList" ofType:@"json"];
        
        [fileManager copyItemAtPath:resourcePath toPath:jsonPath error:&error];
    }

    NSURL *jsonURL = [NSURL fileURLWithPath: jsonPath];
    
    

    NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:jsonURL];
    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.attachments = @[attachment];
    
    [context completeRequestReturningItems:@[item] completionHandler:nil];
}


@end
