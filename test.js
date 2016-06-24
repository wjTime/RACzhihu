function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge);
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function() {callback(WebViewJavascriptBridge);}, false);
    }
}

connectWebViewJavascriptBridge(function(bridge) {
            bridge.init(function(message, responseCallback) {
                            log('JS got a message', message)
                                           var data = { 'Javascript Responds':'Wee!' }
                                           log('JS responding with', data)
                                           responseCallback(data)
                                           })
});
