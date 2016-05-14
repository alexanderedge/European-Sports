//
//  ViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/04/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import EurosportKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        User.login("alexander.edge@googlemail.com", password: "q6v-BXt-V57-E4r") { result in
            
            switch result {
            case .Success(let user):
                print("user: \(user)")
                
                Token.fetch(user.identifier, hkey: user.hkey) { result in
                    
                    switch result {
                    case .Success(let token):
                        print("received token: \(token)")
                        
                        // get the listings
                        
                        Catchup.fetch { result in
                            
                            switch result {
                                
                            case .Success(let catchupTuple):
                                
                                let catchups = catchupTuple.0
                                // let sports = catchupTuple.1
                                
                                //print("catchups: \(catchups)")
                                //print("sports: \(sports)")
                                
                                for catchup in catchups  where catchup.identifier == 67397 {
                                    
                                    if let stream = catchup.streams.first {
                                        
                                        print("stream: \(stream)")
                                        
                                        self.showVideoForURL(stream.URL.URLByAppendingQueryParameters(["token": token.token, "hdnea": token.hdnea]), options: nil)
                                        
                                    }
                                    
                                }
                                
                                
                                break
                            case .Failure(let error):
                                print("error: \(error)")
                                break
                                
                            }
                            
                            }.resume()
                        
                        break
                    case .Failure(let error):
                        print("error: \(error)")
                        break
                    }
                    
                    }.resume()
                
                break
            case .Failure(let error):
                print("error: \(error)")
                break
            }
            
            }.resume()
        
    }
    
    func showVideoForURL(url: NSURL, options: [String : AnyObject]?) {
        let playerController = AVPlayerViewController()

        let asset = AVURLAsset(URL: url, options: options)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        playerController.player = player
        
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

