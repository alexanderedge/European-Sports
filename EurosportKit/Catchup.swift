import Foundation
import CoreData

extension Catchup: Int32Identifiable { }

extension Catchup: Fetchable {

    public class var entityName: String {
        return "Catchup"
    }

}
