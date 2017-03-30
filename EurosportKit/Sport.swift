import Foundation
import CoreData

extension Sport: Fetchable {

    public static var entityName: String {
        return "Sport"
    }
}

extension Sport: Int32Identifiable { }
