//
//  ActionRequestHandler.h
//  WebBlcoker
//
//  Created by Matthias Vermeulen on 27/06/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionRequestHandler : NSObject <NSExtensionRequestHandling>
- (void)addURLToJSON:(NSNotification *)note;
@end
