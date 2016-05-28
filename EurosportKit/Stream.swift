import Foundation

@objc(Stream)
public class Stream: _Stream {
	// Custom logic goes here.
    
    public var authenticatedURL: NSURL {
        return Router.Catchup.authenticatedURL(url as! NSURL)
    }
    
}
