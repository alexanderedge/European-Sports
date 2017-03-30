//
//  AuthenticatedResource.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 23/02/2017.

import Foundation

public protocol AuthenticatedResource {

    var url: URL { get }

}

enum AuthenticatedResourceError: Error {
    case unableToConstructURLComponents
    case unableToConstructURL
}

extension AuthenticatedResource {

    func authenticated(url streamURL: URL, withToken token: Token) throws -> URL {
        guard var components = URLComponents(url: streamURL, resolvingAgainstBaseURL: false) else {
            throw AuthenticatedResourceError.unableToConstructURLComponents
        }
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "token", value: token.token))
        queryItems.append(URLQueryItem(name: "hdnts", value: token.hdnts))
        components.queryItems = queryItems
        guard let url = components.url else {
            throw AuthenticatedResourceError.unableToConstructURL
        }
        return url
    }

    public func generateAuthenticatedURL(_ user: User, completionHandler: @escaping (Result<URL>) -> Void) {
        Token.fetch(user.identifier, hkey: user.hkey) { result in

            switch result {

            case .success(let token):

                do {
                    completionHandler(.success(try self.authenticated(url: self.url, withToken: token)))
                } catch {
                    completionHandler(.failure(error))
                }

                break
            case .failure(let error):
                completionHandler(.failure(error))
                break

            }

        }.resume()

    }

}
