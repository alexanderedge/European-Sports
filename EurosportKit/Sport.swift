import Foundation
import CoreData

@objc(Sport)
public class Sport: _Sport {
	// Custom logic goes here.
    
    public var imageURL: NSURL? {
        return NSURL(string: imageURLString)
    }
    
    public class func object(withIdentifier identifier: Int, inContext context: NSManagedObjectContext) throws -> Sport? {
        
        // check for an existing object with this identifier
        
        let predicate = NSPredicate(format: "identifier == %d", identifier)
        
        if let existingObject = try singleObjectInContext(context, predicate: predicate, sortedBy: nil, ascending: true) {
            return existingObject
        }
        
        guard let newObject = Sport(managedObjectContext: context) else {
            return nil
        }
        
        newObject.identifier = identifier
        return newObject
    }
    
}


extension Sport: Fetchable {
    public typealias FetchableType = Sport
}