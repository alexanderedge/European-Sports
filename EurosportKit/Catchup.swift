import Foundation
import CoreData

@objc(Catchup)
public class Catchup: NSManagedObject {
 
    @NSManaged public
    var catchupDescription: String
    
    @NSManaged public
    var expirationDate: NSDate
    
    @NSManaged public
    var identifier: NSNumber
    
    @NSManaged public
    var imageURL: NSURL
    
    @NSManaged public
    var startDate: NSDate
    
    @NSManaged public
    var title: String
    
    // MARK: - Relationships
    
    @NSManaged public
    var sport: Sport
    
    @NSManaged public
    var streams: NSOrderedSet

}

extension Catchup: NumberIdentifiable { }

extension Catchup: Fetchable {
    
    public typealias FetchableType = Catchup
    
    public class func entityName () -> String {
        return "Catchup"
    }
    
}

