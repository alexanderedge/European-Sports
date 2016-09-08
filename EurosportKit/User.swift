import Foundation
import CoreData

@objc(User)
open class User: NSManagedObject {
    
    @NSManaged open var identifier: String
    @NSManaged open var hkey: String
    @NSManaged open var email: String
    
}

extension User: StringIdentifiable { }
extension User: Fetchable {

    public typealias FetchableType = User
    
    public static var entityName: String {
        return "User"
    }
}

extension User {
    
    public static func currentUser(_ context: NSManagedObjectContext) -> User? {
        do {
            return try singleObjectInContext(context, predicate: nil, sortedBy: nil, ascending: true)
        } catch {
            return nil
        }
    }
    
}
