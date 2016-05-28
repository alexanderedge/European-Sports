import Foundation

@objc(Sport)
public class Sport: _Sport {
	// Custom logic goes here.
    
}

extension Sport: Fetchable {
    public typealias FetchableType = Sport
}

