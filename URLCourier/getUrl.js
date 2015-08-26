var MyPreprocessor = function() {};

MyPreprocessor.prototype = {
run: function(arguments) {
    arguments.completionFunction({"URL": document.URL});
}
};

var ExtensionPreprocessingJS = new MyPreprocessor;