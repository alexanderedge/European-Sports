//
//  TokenResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.


import Foundation

struct TokenResponseSerializer {
    typealias T = Token

    static func serializer() -> ResponseSerializer <T> {
        return ResponseSerializer { data, response, error in
            return try TokenParser.parse(VideoshopResponseSerializer<JSONObject>.serializer().serializeResponse(data, response: response, error: error))
        }
    }

}
