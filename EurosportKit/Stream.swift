import Foundation
import CoreData

@objc(Stream)
public class Stream: NSManagedObject {
	
    // MARK: - Properties
    
    @NSManaged public
    var identifier: NSNumber?
    
    @NSManaged public
    var url: AnyObject
    
    // MARK: - Relationships
    
    @NSManaged public
    var catchup: Catchup?
    
}

extension Stream: Fetchable {
    
    public typealias FetchableType = Stream
    
    public static func entityName() -> String {
        return "Stream"
    }
    
}
