
function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

    setupWebViewJavascriptBridge(function(bridge) {
              
                         
        var objs = document.getElementsByTagName("img");
        for(var i=0;i<objs.length;i++)
            {
                objs[i].onclick = function()
            {
                                 
            url = this.getAttribute("src");
            bridge.callHandler('showImage', url, function(response) {
                                                    
            })
                                 
            }
        }
                           
                                 
        var allImage = document.querySelectorAll("img");
        allImage = Array.prototype.slice.call(allImage, 0);
        var imageUrlsArray = new Array();
        allImage.forEach(function(image) {
            
            var esrc = image.getAttribute("esrc");
            var newLength = imageUrlsArray.push(esrc);
        });
        
                                 
                                 
        bridge.callHandler('imagJavascriptHandler', imageUrlsArray, function(response) {
        })
               
                                 
            bridge.registerHandler("imagesDownloadComplete", function(data, responseCallback) {
                   
                var pOldUrl = data[0];
                var pNewUrl = data[1];
                var allImage = document.querySelectorAll("img");
                allImage = Array.prototype.slice.call(allImage, 0);
                allImage.forEach(function(image) {
                    if (image.getAttribute("esrc") == pOldUrl ) {
                        
                            image.src = pNewUrl;
                    }
            });
                                   
            })
    })







                            
                            
                            


