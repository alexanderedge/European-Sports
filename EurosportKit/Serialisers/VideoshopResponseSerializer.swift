//
//  VideoshopResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation

class VideoshopResponseSerializer<T>: ResponseSerializer<T> {

    override func serializeResponse(_ data: Data?, response: URLResponse?, error: Error?) throws -> T {
        return try JSONResponseSerializer<JSONObject>().serializeResponse(data, response: response, error: error).extract("PlayerObj")
    }

}
