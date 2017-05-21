//
//  ManagedObjectResponseSerializer.swift
//  EurosportPlayer
//

import Foundation
import CoreData

internal protocol ManagedObjectResponseSerializerType {
    associatedtype T

    func serializeResponse(_ context: NSManagedObjectContext, data: Data?, removeExisting: Bool, response: URLResponse?, error: Error?) throws -> T

}

internal class ManagedObjectResponseSerializer<T>: ManagedObjectResponseSerializerType {

    func serializeResponse(_ context: NSManagedObjectContext, data: Data?, removeExisting: Bool, response: URLResponse?, error: Error?) throws -> T {
        fatalError("should be implemented by subclass")
    }

}

extension URLSession {

    internal func dataTaskWithRequest<T>(_ request: URLRequest, persistentContainer: NSPersistentContainer, responseSerializer: ManagedObjectResponseSerializer<T>, completionHandler: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        return dataTaskWithRequest(request, persistentContainer: persistentContainer, responseSerializer: responseSerializer, removeExisting: true, completionHandler: completionHandler)
    }

    internal func dataTaskWithRequest<T>(_ request: URLRequest, persistentContainer: NSPersistentContainer, responseSerializer: ManagedObjectResponseSerializer<T>, removeExisting: Bool, completionHandler: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            persistentContainer.performBackgroundTask { context in
                context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                do {
                    let object = try responseSerializer.serializeResponse(context, data: data, removeExisting: removeExisting, response: response, error: error)
                    try context.save()
                    completionHandler(.success(object))
                } catch {
                    completionHandler(.failure(error))
                }
            }

        }
    }

}
