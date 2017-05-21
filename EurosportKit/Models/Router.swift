//
//  Router.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation
import CoreData

public protocol URLRequestConvertible {
    var request: URLRequest { get }
}

struct Router {

    fileprivate static func standardRequest(_ url: URL) -> URLRequest {
        var req = URLRequest(url: url)
        req.setValue("EurosportPlayer PROD/5.2.2 (iPad; iOS 10.2; Scale/2.00)", forHTTPHeaderField: "User-Agent")
        return req
    }

    enum User: URLRequestConvertible {
        case login(email: String, password: String)

        fileprivate var baseURL: URL {
            return URL(string : "https://crm-partners.eurosportplayer.com/")!
        }

        var path: String {
            return "JsonPlayerCrmApi.svc/login"
        }

        var request: URLRequest {
            switch self {
            case .login(let email, let password):
                var params = [String: String]()

                let contextData = try! JSONSerialization.data(withJSONObject: ["g": "GB", "p": 9, "l": "EN", "d": 2, "mn": "iPad", "v": "5.2.2", "tt": "Pad", "li": 2, "s": 1, "b": 7], options: [])

                params["context"] = String(data: contextData, encoding: .utf8)

                let identifier = UIDevice.current.identifierForVendor!.uuidString

                let data = try! JSONSerialization.data(withJSONObject: ["email": email, "password": password, "udid": identifier], options: [])

                params["data"] = String(data: data, encoding: .utf8)

                var URLComponents = Foundation.URLComponents(url: URL(string: path, relativeTo: baseURL)!, resolvingAgainstBaseURL: true)!
                URLComponents.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
                let url = URLComponents.url!

                return Router.standardRequest(url)

            }
        }

    }

    enum AuthToken: URLRequestConvertible {
        case fetch(userId: String, hkey: String)

        fileprivate var baseURL: URL {
            return URL(string : "https://videoshop-partners.eurosportplayer.com/")!
        }

        var path: String {
            return "JsonProductService.svc/GetToken"
        }

        var request: URLRequest {
            switch self {
            case .fetch(let userId, let hkey):
                var params = [String: String]()

                let contextData = try! JSONSerialization.data(withJSONObject: ["g": "GB", "d": 2], options: [])

                params["context"] = String(data: contextData, encoding: String.Encoding.utf8)

                let data = try! JSONSerialization.data(withJSONObject: ["userid": userId, "hkey": hkey], options: [])

                params["data"] = String(data: data, encoding: String.Encoding.utf8)

                var URLComponents = Foundation.URLComponents(url: URL(string: path, relativeTo: baseURL)!, resolvingAgainstBaseURL: true)!
                URLComponents.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
                let url = URLComponents.url!

                return Router.standardRequest(url)

            }
        }

    }

    fileprivate enum Language: String {
        case German = "de"
        case English = "en"
        case French = "fr"

        fileprivate var identifier: Int {
            switch self {
            case .German:
                return 1
            case .English:
                return 2
            case .French:
                return 3
            }
        }

        static var preferredLanguage: Language {
            guard let preferredLanguage = Locale.preferredLanguages.first, let language = Language(rawValue: preferredLanguage) else {
                return .English
            }
            return language
        }

    }

    enum Catchup: URLRequestConvertible {
        case fetch

        fileprivate var baseURL: URL {
            return URL(string : "https://videoshop-partners.eurosportplayer.com/")!
        }

        var path: String {
            return "JsonProductService.svc/GetAllCatchupCache"
        }

        var request: URLRequest {
            switch self {
            case .fetch:
                var params = [String: String]()

                let contextData = try! JSONSerialization.data(withJSONObject: ["g": "GB", "d": 2], options: [])

                params["context"] = String(data: contextData, encoding: .utf8)

                let data = try! JSONSerialization.data(withJSONObject: ["languageid": Language.preferredLanguage.identifier], options: [])

                params["data"] = String(data: data, encoding: String.Encoding.utf8)

                var URLComponents = Foundation.URLComponents(url: URL(string: path, relativeTo: baseURL)!, resolvingAgainstBaseURL: true)!
                URLComponents.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
                let url = URLComponents.url!

                return Router.standardRequest(url)

            }
        }

    }

    enum Channel: URLRequestConvertible {
        case fetch

        fileprivate var baseURL: URL {
            return URL(string : "https://videoshop-partners.eurosportplayer.com/")!
        }

        var path: String {
            return "JsonProductService.svc/GetAllChannelsCache"
        }

        var request: URLRequest {
            switch self {
            case .fetch:
                var params = [String: String]()

                let contextData = try! JSONSerialization.data(withJSONObject: ["g": "GB", "d": 2], options: [])

                params["context"] = String(data: contextData, encoding: .utf8)

                let data = try! JSONSerialization.data(withJSONObject:
                    ["languageid": Language.preferredLanguage.identifier,
                     "isfullaccess": 0,
                     "withouttvscheduleliveevents": "true",
                     "groupchannels": "true",
                     "pictureformatids": "[87]",
                     "isbroadcasted": 1], options: [])

                params["data"] = String(data: data, encoding: .utf8)

                var URLComponents = Foundation.URLComponents(url: URL(string: path, relativeTo: baseURL)!, resolvingAgainstBaseURL: true)!
                URLComponents.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
                let url = URLComponents.url!

                return Router.standardRequest(url)

            }
        }

    }

}
