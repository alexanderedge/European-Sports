//
//  Router.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import CoreData

public protocol URLRequestConvertible {
    var request: URLRequest { get }
}

enum Method: String {
    case GET
}

struct Router {
    
    static var token: Token?
    
    fileprivate static func standardRequest(_ url: URL) -> URLRequest {
        var req = URLRequest(url: url)
        req.setValue("EurosportPlayer/5.1.12 (iPad; iOS 10.1.1; Scale/2.00)", forHTTPHeaderField: "User-Agent")
        return req
    }
    
    enum User: URLRequestConvertible {
        case login(email: String, password: String)
        
        fileprivate var baseURL: URL {
            return URL(string : "https://playercrm.ssl.eurosport.com")!
        }
        
        var path: String {
            return "/JsonPlayerCrmApi.svc/login"
        }
        
        var request: URLRequest {
            switch self {
            case .login(let email, let password):
                var params = [String : String]()
                
                let contextData = try! JSONSerialization.data(withJSONObject: ["g": "GB", "p": 9, "l": "EN", "d":2,"mn":"iPad","v":"5.1.5","tt":"Pad","li":2,"s":1,"b":7], options: [])
                
                params["context"] = String(data: contextData, encoding: String.Encoding.utf8)
                
                let identifier = UIDevice.current.identifierForVendor!.uuidString
                
                let data = try! JSONSerialization.data(withJSONObject: ["email": email, "password": password, "udid": identifier], options: [])
                
                params["data"] = String(data: data, encoding: String.Encoding.utf8)
                
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
            return URL(string : "http://videoshop.ext.ws.eurosport.com")!
        }
        
        var path: String {
            return "/JsonProductService.svc/GetToken"
        }
        
        var request: URLRequest {
            switch self {
            case .fetch(let userId, let hkey):
                var params = [String : String]()
                
                let contextData = try! JSONSerialization.data(withJSONObject: ["g": "GB", "d":2], options: [])
                
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
            guard let preferredLanguage = NSLocale.preferredLanguages.first, let language = Language(rawValue: preferredLanguage) else {
                return .English
            }
            return language
        }
        
    }
    
    enum Catchup: URLRequestConvertible {
        case fetch
        
        fileprivate var baseURL: URL {
            return URL(string : "http://videoshop.ext.ws.eurosport.com")!
        }
        
        var path: String {
            return "/JsonProductService.svc/GetAllCatchupCache"
        }
        
        var request: URLRequest {
            switch self {
            case .fetch:
                var params = [String : String]()
                
                let contextData = try! JSONSerialization.data(withJSONObject: ["g": "GB", "d": 2], options: [])
                
                params["context"] = String(data: contextData, encoding: String.Encoding.utf8)
                
                let data = try! JSONSerialization.data(withJSONObject: ["languageid": Language.preferredLanguage.identifier], options: [])
                
                params["data"] = String(data: data, encoding: String.Encoding.utf8)
                
                var URLComponents = Foundation.URLComponents(url: URL(string: path, relativeTo: baseURL)!, resolvingAgainstBaseURL: true)!
                URLComponents.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
                let url = URLComponents.url!
                
                return Router.standardRequest(url)
                
            }
        }
        
        static func authenticatedURL(_ streamURL: URL) -> URL {
            guard let token = token else {
                return streamURL
            }
            // the order of the query parameters is important - videos do not play otherwise
            return streamURL.URLByAppendingQueryParameters(["token": token.token]).URLByAppendingQueryParameters(["hdnea": token.hdnea])
        }
        
    }
    
    enum Product: URLRequestConvertible {
        case fetch
        
        fileprivate var baseURL: URL {
            return URL(string : "http://videoshop.ext.ws.eurosport.com")!
        }
        
        var path: String {
            return "/JsonProductService.svc/GetAllProductsCache"
        }
        
        var request: URLRequest {
            switch self {
            case .fetch:
                var params = [String : String]()
                
                let contextData = try! JSONSerialization.data(withJSONObject: ["g":"GB","p":9,"l":"EN","d":2,"mn":"iPad","v":"5.1.5","tt":"Pad","li":2,"s":1,"b":7], options: [])
                
                params["context"] = String(data: contextData, encoding: String.Encoding.utf8)
                
                let data = try! JSONSerialization.data(withJSONObject: ["languageid": Language.preferredLanguage.identifier, "isfullaccess":0,"withouttvscheduleliveevents":"true","groupchannels":"true","pictureformatids":"[87]","isbroadcasted":1], options: [])
                
                params["data"] = String(data: data, encoding: String.Encoding.utf8)
                
                var URLComponents = Foundation.URLComponents(url: URL(string: path, relativeTo: baseURL)!, resolvingAgainstBaseURL: true)!
                URLComponents.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
                let url = URLComponents.url!
                
                return Router.standardRequest(url)
                
            }
        }

    }
    
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = NSString(format: "%@=%@",
                                (key as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                                (value as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new NSURL.
     */
    func URLByAppendingQueryParameters(_ parametersDictionary: [String: String]) -> URL {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems , !queryItems.isEmpty else {
            return URL(string:self.absoluteString.appendingFormat("?%@", parametersDictionary.queryParameters))!
        }
        guard let url = components.url else {
            return self
        }
        return URL(string:url.absoluteString.appendingFormat("&%@", parametersDictionary.queryParameters))!
    }
}
