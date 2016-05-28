import Foundation

@objc(Catchup)
public class Catchup: _Catchup {
	// Custom logic goes here.
 
    
}

//extension Catchup: NumberIdentifiable { }

extension Catchup: Fetchable {
    public typealias FetchableType = Catchup
}

