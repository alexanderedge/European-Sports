//
//  Router.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation

public protocol URLRequestConvertible {
    var request: NSURLRequest { get }
}

enum Method: String {
    case GET
}

struct Router {
    
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

    enum Token: URLRequestConvertible {
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
        
    }
    
}