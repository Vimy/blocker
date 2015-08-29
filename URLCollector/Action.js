//
//  Action.js
//  URLCollector
//
//  Created by Matthias Vermeulen on 29/08/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        // Here, you can run code that modifies the document and/or prepares
        // things to pass to your action's native code.
        
        // We will not modify anything, but will pass the body's background
        // style to the native code.
        
        arguments.completionFunction({"URL": document.URL});
    },
    
    finalize: function(arguments) {
        var message = arguments["statusMessage"];
        
        if (message) {
            alert(message);
        }
    }
    
};
    
var ExtensionPreprocessingJS = new Action
