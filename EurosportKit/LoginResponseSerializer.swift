//
//  LoginResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

struct LoginResponseSerializer {
    
    typealias T = User
    
    enum LoginError: CustomNSError {
        case invalidJSONStructure
        case failure(message: String)
        
        var errorUserInfo: [String : Any] {
            switch self {
            case .invalidJSONStructure:
                return [NSLocalizedDescriptionKey: NSLocalizedString("Invalid JSON structure", comment: "")]
            case .failure(let message):
                return [NSLocalizedDescriptionKey: message]
            }
        }
        
    }
    
    static func serializer() -> ManagedObjectResponseSerializer <T> {
        return ManagedObjectResponseSerializer { context, data, response, error in
            guard let json = try JSONResponseSerializer.serializer().serializeResponse(data, response: response, error: error) as? [String: AnyObject], let responseDict: [String: AnyObject] = try json.extract("Response") else {
                throw LoginError.invalidJSONStructure
            }
            
            let status: Int = try responseDict.extract("Success")
            if status == 1 {
                return try UserParser.parse(json, context: context)
            } else {
                let message: String = try responseDict.extract("Message")
                throw LoginError.failure(message: message)
            }
            
        }
    }
    
}
