import Foundation
import CoreData

@objc(CatchupStream)
public class CatchupStream: NSManagedObject {
	
    // MARK: - Properties
    
    @NSManaged public
    var identifier: NSNumber
    
    @NSManaged public
    var url: NSURL
    
    // MARK: - Relationships
    
    @NSManaged public
    var catchup: Catchup
    
}

extension CatchupStream: Fetchable {
    
    public typealias FetchableType = CatchupStream
    
    public static func entityName() -> String {
        return "CatchupStream"
    }
    
}
