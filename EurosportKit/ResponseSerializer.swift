//
//  ResponseSerializer.swift
//  StocksKit
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

internal protocol ResponseSerializerType {
    associatedtype T
    
    func serializeResponse(_ data: Data?, response: URLResponse?, error: NSError?) throws -> T
    
}

internal struct ResponseSerializer<T>: ResponseSerializerType {
    
    typealias SerializationBlock = (Data?, URLResponse?, NSError?) throws -> T
    
    let serializationBlock: SerializationBlock
    
    init(serializationBlock: @escaping SerializationBlock) {
        self.serializationBlock = serializationBlock
    }
    
    func serializeResponse(_ data: Data?, response: URLResponse?, error: NSError?) throws -> T {
        return try serializationBlock(data, response, error)
    }
    
}

extension URLSession {
    
    internal func dataTaskWithRequest<T>(_ request: URLRequest, responseSerializer: ResponseSerializer<T>,completionHandler: @escaping (Result<T, NSError>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            do {
                let object = try responseSerializer.serializeResponse(data, response: response, error: error as NSError?)
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(error as NSError))
                }
            }
        }
    }
    
}
