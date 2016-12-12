//
//  ManagedObjectResponseSerializer.swift
//  EurosportPlayer
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Alexander Edge
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import CoreData

internal protocol ManagedObjectResponseSerializerType {
    associatedtype T
    
    func serializeResponse(_ context:NSManagedObjectContext, data: Data?, response: URLResponse?, error: Error?) throws -> T
    
}

internal struct ManagedObjectResponseSerializer<T>: ManagedObjectResponseSerializerType {
    
    typealias ManagedObjectSerializationBlock = (NSManagedObjectContext, Data?, URLResponse?, Error?) throws -> T
    
    let serializationBlock: ManagedObjectSerializationBlock
    
    init(serializationBlock: @escaping ManagedObjectSerializationBlock) {
        self.serializationBlock = serializationBlock
    }
    
    func serializeResponse(_ context: NSManagedObjectContext, data: Data?, response: URLResponse?, error: Error?) throws -> T {
        return try serializationBlock(context, data, response, error)
    }
    
}

extension URLSession {
    
    internal func dataTaskWithRequest<T>(_ request: URLRequest, context: NSManagedObjectContext, responseSerializer: ManagedObjectResponseSerializer<T>, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            
            context.perform {
                do {
                    let object = try responseSerializer.serializeResponse(context, data: data, response: response, error: error)
                    try context.save()
                    completionHandler(.success(object))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            
        }
    }
    
}
