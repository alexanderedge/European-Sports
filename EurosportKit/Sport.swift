import Foundation
import CoreData

@objc(Sport)
public class Sport: NSManagedObject {
	
    // MARK: - Properties
    
    @NSManaged public
    var identifier: NSNumber?
    
    @NSManaged public
    var imageURL: AnyObject
    
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

extension Sport {
    
    func addCatchups(objects: NSSet) {
        let mutable = self.catchups.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.catchups = mutable.copy() as! NSSet
    }
    
    func removeCatchups(objects: NSSet) {
        let mutable = self.catchups.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.catchups = mutable.copy() as! NSSet
    }
    
    func addCatchupsObject(value: Catchup) {
        let mutable = self.catchups.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.catchups = mutable.copy() as! NSSet
    }
    
    func removeCatchupsObject(value: Catchup) {
        let mutable = self.catchups.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.catchups = mutable.copy() as! NSSet
    }
    
}