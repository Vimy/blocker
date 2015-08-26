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
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(addURLToJSON:)
                                                         name:@"urlAdded" object:nil];
    
    
    //kopie maken van blockerlist
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *jsonPath = [documentsDirectory stringByAppendingPathComponent:@"blockList.json"];
    
    if ([fileManager fileExistsAtPath:jsonPath] == NO)
    {
        // NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"txt"];
        NSString *resourcePath =  [[NSBundle mainBundle] pathForResource:@"blockerList" ofType:@"json"];
        
        [fileManager copyItemAtPath:resourcePath toPath:jsonPath error:&error];
    }

    NSURL *jsonURL = [NSURL fileURLWithPath: jsonPath];
    
    
    //NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockerList" withExtension:@"json"]];

    NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:jsonURL];
    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.attachments = @[attachment];
    
    [context completeRequestReturningItems:@[item] completionHandler:nil];
}

- (void)addURLToJSON:(NSNotification *)note
{
    NSLog(@"De notificationcenter werkt!");
}

@end
