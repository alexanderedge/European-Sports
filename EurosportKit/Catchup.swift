import Foundation
import CoreData

@objc(Catchup)
open class Catchup: NSManagedObject {
 
    @NSManaged open
    var catchupDescription: String
    
    @NSManaged open
    var expirationDate: Date
    
    @NSManaged open
    var identifier: NSNumber
    
    @NSManaged open
    var imageURL: URL
    
    @NSManaged open
    var startDate: Date
    
    @NSManaged open
    var title: String
    
    // MARK: - Relationships
    
    @NSManaged open
    var sport: Sport
    
    @NSManaged open
    var streams: NSOrderedSet

}

extension Catchup: NumberIdentifiable { }

extension Catchup: Fetchable {
    
    public typealias FetchableType = Catchup
    
    public class var entityName: String {
        return "Catchup"
    }
    
}

