//
//  LoginResponseSerializer.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.


struct LoginResponseSerializer {

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

    static func serializer() -> ManagedObjectResponseSerializer <T> {
        return ManagedObjectResponseSerializer { context, data, _, response, error in
            let json = try JSONResponseSerializer<JSONObject>.serializer().serializeResponse(data, response: response, error: error)
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

}
