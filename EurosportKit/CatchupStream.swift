import Foundation
import CoreData

@objc(CatchupStream)
open class CatchupStream: NSManagedObject {
	
    // MARK: - Properties
    
    @NSManaged open
    var identifier: NSNumber
    
    @NSManaged open
    var url: URL
    
    // MARK: - Relationships
    
    @NSManaged open
    var catchup: Catchup
    
}

extension CatchupStream: Fetchable {
    
    public typealias FetchableType = CatchupStream
    
    public static var entityName: String {
        return "CatchupStream"
    }
    
}
