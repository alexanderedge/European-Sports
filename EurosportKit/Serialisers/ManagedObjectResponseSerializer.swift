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

internal struct ManagedObjectResponseSerializer<T>: ManagedObjectResponseSerializerType {

    typealias ManagedObjectSerializationBlock = (NSManagedObjectContext, Data?, Bool, URLResponse?, Error?) throws -> T

    let serializationBlock: ManagedObjectSerializationBlock

    init(serializationBlock: @escaping ManagedObjectSerializationBlock) {
        self.serializationBlock = serializationBlock
    }

    func serializeResponse(_ context: NSManagedObjectContext, data: Data?, removeExisting: Bool, response: URLResponse?, error: Error?) throws -> T {
        return try serializationBlock(context, data, removeExisting, response, error)
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
