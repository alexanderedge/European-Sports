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
    var request: NSURLRequest { get }
}

enum Method: String {
    case GET
}

struct Router {
    
    static var token: Token?
    
    private static func standardRequest(url: NSURL) -> NSMutableURLRequest {
        let mutableRequest = NSMutableURLRequest(URL: url)
        mutableRequest.setValue("EurosportPlayer/5.1.5 (iPad; iOS 9.3.1; Scale/3.00)", forHTTPHeaderField: "User-Agent")
        //mutableRequest.setValue("en-GB;q=1, en;q=0.9", forHTTPHeaderField: "Accept-Language")
        //mutableRequest.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        return mutableRequest
    }
    
    enum User: URLRequestConvertible {
        case Login(email: String, password: String)
        
        private var baseURL: NSURL {
            return NSURL(string : "https://playercrm.ssl.eurosport.com")!
        }
        
        var path: String {
            return "/JsonPlayerCrmApi.svc/login"
        }
        
        var request: NSURLRequest {
            switch self {
            case .Login(let email, let password):
                var params = [String : String]()
                
                do {
                    
                    let contextData = try NSJSONSerialization.dataWithJSONObject(["g": "GB", "p": 9, "l": "EN", "d":2,"mn":"iPad","v":"5.1.5","tt":"Pad","li":2,"s":1,"b":7], options: [])
                    
                    params["context"] = String(data: contextData, encoding: NSUTF8StringEncoding)
                    
                    let data = try NSJSONSerialization.dataWithJSONObject(["email": email, "password": password, "udid": "D270986F-35B1-43F5-8535-C874C9173B68"], options: [])
                    
                    params["data"] = String(data: data, encoding: NSUTF8StringEncoding)
                    
                    let URLComponents = NSURLComponents(URL: NSURL(string: path, relativeToURL: baseURL)!, resolvingAgainstBaseURL: true)!
                    URLComponents.queryItems = params.map({NSURLQueryItem(name: $0, value: $1)})
                    let url = URLComponents.URL!
                    
                    return Router.standardRequest(url)
                } catch {
                    
                    return NSURLRequest()
                    
                }
                
            }
        }
        
    }

    enum AuthToken: URLRequestConvertible {
        case Fetch(userId: String, hkey: String)
        
        private var baseURL: NSURL {
            return NSURL(string : "http://videoshop.ext.ws.eurosport.com")!
        }
        
        var path: String {
            return "/JsonProductService.svc/GetToken"
        }
        
        var request: NSURLRequest {
            switch self {
            case .Fetch(let userId, let hkey):
                var params = [String : String]()
                
                do {
                    
                    let contextData = try NSJSONSerialization.dataWithJSONObject(["g": "GB", "d":2], options: [])
                    
                    params["context"] = String(data: contextData, encoding: NSUTF8StringEncoding)
                    
                    let data = try NSJSONSerialization.dataWithJSONObject(["userid": userId, "hkey": hkey], options: [])
                    
                    params["data"] = String(data: data, encoding: NSUTF8StringEncoding)
                    
                    let URLComponents = NSURLComponents(URL: NSURL(string: path, relativeToURL: baseURL)!, resolvingAgainstBaseURL: true)!
                    URLComponents.queryItems = params.map({NSURLQueryItem(name: $0, value: $1)})
                    let url = URLComponents.URL!
                    
                    return Router.standardRequest(url)
                } catch {
                    
                    return NSURLRequest()
                    
                }
                
            }
        }
        
    }
    
    private enum Language: String {
        case German = "de"
        case English = "en"
        case French = "fr"
        
        private var identifier: Int {
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
            guard let preferredLanguage = NSLocale.preferredLanguages().first, language = Language(rawValue: preferredLanguage) else {
                return .English
            }
            return language
        }
        
    }
    
    enum Catchup: URLRequestConvertible {
        case Fetch
        
        private var baseURL: NSURL {
            return NSURL(string : "http://videoshop.ext.ws.eurosport.com")!
        }
        
        var path: String {
            return "/JsonProductService.svc/GetAllCatchupCache"
        }
        
        var request: NSURLRequest {
            switch self {
            case .Fetch:
                var params = [String : String]()
                
                do {
                    
                    let contextData = try NSJSONSerialization.dataWithJSONObject(["g": "GB", "d": 2], options: [])
                    
                    params["context"] = String(data: contextData, encoding: NSUTF8StringEncoding)
                    
                    let data = try NSJSONSerialization.dataWithJSONObject(["languageid": Language.preferredLanguage.identifier], options: [])
                    
                    params["data"] = String(data: data, encoding: NSUTF8StringEncoding)
                    
                    let URLComponents = NSURLComponents(URL: NSURL(string: path, relativeToURL: baseURL)!, resolvingAgainstBaseURL: true)!
                    URLComponents.queryItems = params.map({NSURLQueryItem(name: $0, value: $1)})
                    let url = URLComponents.URL!
                    
                    return Router.standardRequest(url)
                } catch {
                    
                    return NSURLRequest()
                    
                }
                
            }
        }
        
        static func authenticatedURL(streamURL: NSURL) -> NSURL {
            guard let token = token else {
                return streamURL
            }
            return streamURL.URLByAppendingQueryParameters(["token": token.token, "hdnea": token.hdnea])
        }
        
    }
    
}

extension NSURLSession {
    
    internal func authenticatedDataTaskForRequest<T>(request: NSURLRequest, user: User, responseSerializer: ResponseSerializer<T>, completionHandler: Result<T, NSError> -> Void) -> NSURLSessionDataTask {

        guard let token = Router.token where !token.isExpired else {
            print("no token or token has expired, fetching new token")
            
            return Token.fetch(user.identifier, hkey: user.hkey) { result in
                switch result {
                case .Success(let token):
                    Router.token = token
                    self.authenticatedDataTaskForRequest(request, user: user, responseSerializer: responseSerializer, completionHandler: completionHandler).resume()
                    break
                case.Failure(let error):
                    completionHandler(.Failure(error))
                    break
                    
                }
                
            }
            
        }
        print("using existing token")
        return dataTaskWithRequest(request, responseSerializer: responseSerializer, completionHandler: completionHandler)
        
    }
    
    internal func authenticatedDataTaskForRequest<T>(request: NSURLRequest, user: User, context: NSManagedObjectContext, responseSerializer: ManagedObjectResponseSerializer<T>, completionHandler: Result<T, NSError> -> Void) -> NSURLSessionDataTask {
        
        guard let token = Router.token where !token.isExpired else {
            print("no token or token has expired, fetching new token")
            
            return Token.fetch(user.identifier, hkey: user.hkey) { result in
                switch result {
                case .Success(let token):
                    Router.token = token
                    self.authenticatedDataTaskForRequest(request, user: user, context: context, responseSerializer: responseSerializer, completionHandler: completionHandler).resume()
                    break
                case.Failure(let error):
                    completionHandler(.Failure(error))
                    break
                    
                }
                
            }
            
        }
        print("using existing token")
        return dataTaskWithRequest(request, context: context, responseSerializer: responseSerializer, completionHandler: completionHandler)
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
                                String(key).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
                                String(value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            parts.append(part as String)
        }
        return parts.joinWithSeparator("&")
    }
    
}

extension NSURL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new NSURL.
     */
    func URLByAppendingQueryParameters(parametersDictionary: [String: String]) -> NSURL {
        guard let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems where !queryItems.isEmpty else {
            return NSURL(string:self.absoluteString.stringByAppendingFormat("?%@", parametersDictionary.queryParameters))!
        }
        guard let url = components.URL else {
            return self
        }
        return NSURL(string:url.absoluteString.stringByAppendingFormat("&%@", parametersDictionary.queryParameters))!
    }
}