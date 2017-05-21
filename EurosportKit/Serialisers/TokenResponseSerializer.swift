//
//  TokenResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation

class TokenResponseSerializer: ResponseSerializer<Token> {

    override func serializeResponse(_ data: Data?, response: URLResponse?, error: Error?) throws -> Token {
        return try TokenParser.parse(VideoshopResponseSerializer<JSONObject>().serializeResponse(data, response: response, error: error))
    }

}
