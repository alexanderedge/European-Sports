//
//  VideoshopResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.


import Foundation

struct VideoshopResponseSerializer <T> {

    static func serializer() -> ResponseSerializer <T> {
        return ResponseSerializer { data, response, error in
            return try JSONResponseSerializer<JSONObject>.serializer().serializeResponse(data, response: response, error: error).extract("PlayerObj")
        }
    }

}
