//
//  LoginResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.

import CoreData

class LoginResponseSerializer: ManagedObjectResponseSerializer<User> {

    typealias T = User

    enum LoginError: CustomNSError {
        case failure(message: String)

        var errorUserInfo: [String : Any] {
            switch self {
            case .failure(let message):
                return [NSLocalizedDescriptionKey: message]
            }
        }

    }

    override func serializeResponse(_ context: NSManagedObjectContext, data: Data?, removeExisting: Bool, response: URLResponse?, error: Error?) throws -> User {
        let json = try JSONResponseSerializer<JSONObject>().serializeResponse(data, response: response, error: error)
        let responseDict: JSONObject = try json.extract("Response")
        let status: Int = try responseDict.extract("Success")
        if status == 1 {
            return try UserParser.parse(json, context: context)
        } else {
            let message: String = try responseDict.extract("Message")
            throw LoginError.failure(message: message)
        }
    }

}
