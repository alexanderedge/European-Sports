import Foundation

@objc(Stream)
public class Stream: _Stream {
	// Custom logic goes here.
    
}

extension Stream: Fetchable {
    public typealias FetchableType = Stream
}
