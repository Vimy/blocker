//
//  ActionViewController.m
//  URLCourier
//
//  Created by Matthias Vermeulen on 25/08/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad
{
    
    //https://www.shinobicontrols.com/blog/ios8-day-by-day-day-29-safari-action-extension
    // http://stackoverflow.com/questions/27348399/get-selected-text-in-safari-and-use-it-in-action-extension
    
   
    //http://martinnormark.com/present-ios-8-share-extension-as-modal-view/
    
  //  [self setModalPresentationStyle:UIModalPresentationOverCurrentContext]; //voor transparantie!
    
    
     NSLog(@"Extension geladen");
    [super viewDidLoad];
    NSLog(@"Extension geladen");
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    for (NSExtensionItem *item in self.extensionContext.inputItems)
    {
        for (NSItemProvider *itemProvider in item.attachments)
        {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList])
            {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *jsDict, NSError *error)
                {
                   //dispatch mainqueueue terugzetten hier
                        NSDictionary *jsPreprocessingResults = jsDict[NSExtensionJavaScriptPreprocessingResultsKey];
                        NSLog(@"Url verkregen door de extensie:%@", jsPreprocessingResults);
                    
                    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.noizystudios.websiteblocker"];
            //        NSString *url = [jsPreprocessingResults valueForKey:@"URL"];
                    [shared setObject:jsPreprocessingResults forKey:@"URL"];
                    [shared synchronize];
                    
                     //http://stackoverflow.com/questions/24118918/sharing-data-between-an-ios-8-share-extension-and-main-app
                   }];

                
                //http://nsnerd.co/action-extension-in-swift/
            }
        }
    }
    
//    UIAlertController * alert=   [UIAlertController
//                                  alertControllerWithTitle:@"Succes!"
//                                  message:@"Website geblokkeerd"
//                                  preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction
//                         actionWithTitle:@"OK"
//                         style:UIAlertActionStyleDefault
//                         handler:^(UIAlertAction * action)
//                         {
//                             [alert dismissViewControllerAnimated:YES completion:nil];
//                             
//      
//  
//    
//    
//                         }];
//    
//      [alert addAction:ok];
//    [self presentViewController:alert animated:YES completion:nil];
}
                         
                         
                         
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. 
}

- (IBAction)done
{
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    
    NSDictionary *resultsDictionary = @{ NSExtensionJavaScriptFinalizeArgumentKey:@{@"statusmessage":@"website toegevoegd"} };
    
    NSItemProvider *resultsProvider = [[NSItemProvider alloc] initWithItem:resultsDictionary typeIdentifier:(NSString *)kUTTypePropertyList];
    
    NSExtensionItem *resultsItem = [[NSExtensionItem alloc] init];
    resultsItem.attachments = @[resultsProvider];
    
    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
     // [self.extensionContext completeRequestReturningItems:@[resultsItem] completionHandler:nil];
}

@end
