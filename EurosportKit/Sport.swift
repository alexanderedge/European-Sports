import Foundation
import CoreData

@objc(Sport)
open class Sport: NSManagedObject {
	
    // MARK: - Properties
    
    @NSManaged open
    var identifier: NSNumber
    
    @NSManaged open
    var imageURL: URL?
    
    @NSManaged open
    var name: String?
    
    // MARK: - Relationships
    
    @NSManaged open
    var catchups: NSSet
    
}

extension Sport: Fetchable {
    public typealias FetchableType = Sport
    
    public static var entityName: String {
        return "Sport"
    }
}

extension Sport: NumberIdentifiable { }
