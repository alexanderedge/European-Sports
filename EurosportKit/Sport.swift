import Foundation
import CoreData

@objc(Sport)
public class Sport: NSManagedObject {
	
    // MARK: - Properties
    
    @NSManaged public
    var identifier: NSNumber
    
    @NSManaged public
    var imageURL: NSURL
    
    @NSManaged public
    var name: String
    
    // MARK: - Relationships
    
    @NSManaged public
    var catchups: NSSet
    
}

extension Sport: Fetchable {
    public typealias FetchableType = Sport
    
    public static func entityName() -> String {
        return "Sport"
    }
}

extension Sport: NumberIdentifiable { }
