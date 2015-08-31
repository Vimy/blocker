//
//  ActionRequestHandler.m
//  URLCollector
//
//  Created by Matthias Vermeulen on 29/08/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "ActionRequestHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionRequestHandler ()

@property (nonatomic, strong) NSExtensionContext *extensionContext;

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    // Do not call super in an Action extension with no user interface
    self.extensionContext = context;
    
    BOOL found = NO;
    
    // Find the item containing the results from the JavaScript preprocessing.
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *dictionary, NSError *error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self itemLoadCompletedWithPreprocessingResults:dictionary[NSExtensionJavaScriptPreprocessingResultsKey]];
                        
                       
                      
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"urlAdded" object:nil];
                    
                    
                    //http://nsnerd.co/action-extension-in-swift/

                        
                    }];
              
                found = YES;
            }
            break;
        }
        if (found) {
            
            
            break;
        }
    }
    
    if (!found) {
        // We did not find anything
        [self doneWithResults:nil];
    }
}

- (void)itemLoadCompletedWithPreprocessingResults:(NSDictionary *)javaScriptPreprocessingResults {
    // Here, do something, potentially asynchronously, with the preprocessing
    // results.
    
    // In this very simple example, the JavaScript will have passed us the
    // current background color style, if there is one. We will construct a
    // dictionary to send back with a desired new background color style.
    if ([javaScriptPreprocessingResults[@"URL"] length] == 0)
    {
        
        //http://stackoverflow.com/questions/24118918/sharing-data-between-an-ios-8-share-extension-and-main-app
        
        
        // No specific background color? Request setting the background to red.
        [self doneWithResults:@{ @"newBackgroundColor": @"red" }];
    } else {
        
        NSString *string = javaScriptPreprocessingResults[@"URL"];
        NSLog(@"Dit is de url json extensie: %@", string );
        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.noizystudios.websiteblocker"];
        [shared setObject:javaScriptPreprocessingResults forKey:@"URL"];
        [shared synchronize];

        // Specific background color is set? Request replacing it with green.
        [self doneWithResults:@{ @"newBackgroundColor": @"green" }];
    }
}

- (void)doneWithResults:(NSDictionary *)resultsForJavaScriptFinalize {
    if (resultsForJavaScriptFinalize) {
        // Construct an NSExtensionItem of the appropriate type to return our
        // results dictionary in.
        
        // These will be used as the arguments to the JavaScript finalize()
        // method.
        
        NSDictionary *resultsDictionary = @{ NSExtensionJavaScriptFinalizeArgumentKey: @{@"statusmessage":@"website toegevoegd"}};
        
        NSItemProvider *resultsProvider = [[NSItemProvider alloc] initWithItem:resultsDictionary typeIdentifier:(NSString *)kUTTypePropertyList];
        
        NSExtensionItem *resultsItem = [[NSExtensionItem alloc] init];
        resultsItem.attachments = @[resultsProvider];
        
        // Signal that we're complete, returning our results.
        [self.extensionContext completeRequestReturningItems:@[resultsItem] completionHandler:nil];
    } else {
        // We still need to signal that we're done even if we have nothing to
        // pass back.
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }
    
    // Don't hold on to this after we finished with it.
    self.extensionContext = nil;
}

@end
