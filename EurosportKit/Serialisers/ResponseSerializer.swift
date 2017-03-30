//
//  ResponseSerializer.swift
//  EurosportPlayer
//

import Foundation

internal protocol ResponseSerializerType {
    associatedtype T

    func serializeResponse(_ data: Data?, response: URLResponse?, error: Error?) throws -> T

}

internal struct ResponseSerializer<T>: ResponseSerializerType {

    typealias SerializationBlock = (Data?, URLResponse?, Error?) throws -> T

    let serializationBlock: SerializationBlock

    init(serializationBlock: @escaping SerializationBlock) {
        self.serializationBlock = serializationBlock
    }

    func serializeResponse(_ data: Data?, response: URLResponse?, error: Error?) throws -> T {
        return try serializationBlock(data, response, error)
    }

}

extension URLSession {

    internal func dataTaskWithRequest<T>(_ request: URLRequest, responseSerializer: ResponseSerializer<T>, completionHandler: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            do {
                let object = try responseSerializer.serializeResponse(data, response: response, error: error)
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
    }

}
