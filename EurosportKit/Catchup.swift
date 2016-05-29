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
    var imageURL: AnyObject
    
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

extension Catchup {

    func addStreams(objects: NSOrderedSet) {
        let mutable = self.streams.mutableCopy() as! NSMutableOrderedSet
        mutable.unionOrderedSet(objects)
        self.streams = mutable.copy() as! NSOrderedSet
    }
    
    func removeStreams(objects: NSOrderedSet) {
        let mutable = self.streams.mutableCopy() as! NSMutableOrderedSet
        mutable.minusOrderedSet(objects)
        self.streams = mutable.copy() as! NSOrderedSet
    }
    
    func addStreamsObject(value: Stream) {
        let mutable = self.streams.mutableCopy() as! NSMutableOrderedSet
        mutable.addObject(value)
        self.streams = mutable.copy() as! NSOrderedSet
    }
    
    func removeStreamsObject(value: Stream) {
        let mutable = self.streams.mutableCopy() as! NSMutableOrderedSet
        mutable.removeObject(value)
        self.streams = mutable.copy() as! NSOrderedSet
    }
    
}

extension Catchup: NumberIdentifiable { }

extension Catchup: Fetchable {
    
    public typealias FetchableType = Catchup
    
    public class func entityName () -> String {
        return "Catchup"
    }
    
}

