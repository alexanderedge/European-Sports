//
//  UIImageView+URL.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

fileprivate struct DarkenFilter {
    
    internal var filter: (UIImage) -> UIImage {
        return { image in
            return UIImageEffects.imageByApplyingBlur(to: image, withRadius: 0, tintColor: UIColor.black.withAlphaComponent(0.6), saturationDeltaFactor: 1, maskImage: nil)
        }
    }
}

private class SessionDelegate: NSObject {
    
   /*
    fileprivate func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
    }
    
    private func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        
        
    }
    
    private func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        
        
    }
    
     
    fileprivate func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        completionHandler(.performDefaultHandling, nil)
        return
        guard let trust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        completionHandler(.useCredential, URLCredential(trust: trust))
        
    }
    */
}

internal class WebImageView: UIImageView {
    
    private var currentTask: URLSessionTask?
    
    func setImage(_ url: URL?, placeholder: UIImage? = nil, darken: Bool) {
        
        let filter = DarkenFilter()
        
        if let placeholder = placeholder {
            self.image = darken ? filter.filter(placeholder) : placeholder
        }
        
        if let url = url {
            
            /*
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            let task = session.downloadTask(with: url)
            */
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let data = data {
                    
                    guard let image = UIImage(data: data) else {
                        return
                    }
                    
                    if darken {
                        
                        let filteredImage = filter.filter(image)
                        
                        DispatchQueue.main.async {
                            self.setImageWithTransition(image: filteredImage, animate: true)
                        }
                        
                        
                    } else {
                        DispatchQueue.main.async {
                            self.setImageWithTransition(image: image, animate: true)
                        }
                    }
                    
                }
                
            }
            
            currentTask = task
            task.resume()
            
        }

    }
    
    func cancelCurrentImageLoad() {
        currentTask?.cancel()
    }
    
    private func setImageWithTransition(image: UIImage, animate: Bool) {
        self.alpha = 0
        self.image = image
        UIView.transition(with: self, duration: (animate ? 0.2 : 0), options: .transitionCrossDissolve, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    /*
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let image = UIImage(contentsOfFile: location.path) else {
            return
        }
        
        let filteredImage = DarkenFilter().filter(image)
        
        DispatchQueue.main.async {
            self.setImageWithTransition(image: filteredImage, animate: true)
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("error: \(error)")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust:challenge.protectionSpace.serverTrust!))
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust:challenge.protectionSpace.serverTrust!))
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("error: \(error)")
    }
    */
    
}


