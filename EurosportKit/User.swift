import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    @NSManaged public var identifier: String
    @NSManaged public var hkey: String
    @NSManaged public var email: String
    
}

extension User: StringIdentifiable { }
extension User: Fetchable {

    public typealias FetchableType = User
    
    public static func entityName() -> String {
        return "User"
    }
}

extension User {
    
    public static func currentUser(context: NSManagedObjectContext) -> User? {
        do {
            return try singleObjectInContext(context, predicate: nil, sortedBy: nil, ascending: true)
        } catch {
            return nil
        }
    }
    
}