//
//  WebImageView.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.


import UIKit

fileprivate struct DarkenFilter {

    internal var filter: (UIImage) -> UIImage {
        return { image in
            return UIImageEffects.imageByApplyingBlur(to: image, withRadius: 0, tintColor: UIColor.black.withAlphaComponent(0.6), saturationDeltaFactor: 1, maskImage: nil)
        }
    }
}

internal class WebImageView: UIImageView {

    private var currentTask: URLSessionTask?

    func setImage(_ url: URL?, placeholder: UIImage? = nil, darken: Bool) {

        let filter = DarkenFilter()

        if let placeholder = placeholder {
            self.image = placeholder
        }

        if let url = url {

            // check for a cached response
            if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)), let cachedImage = UIImage(data: cachedResponse.data) {
                self.image = darken ? filter.filter(cachedImage) : cachedImage
            } else {
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in

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

    }

    func cancelCurrentImageLoad() {
        currentTask?.cancel()
    }

    private func setImageWithTransition(image: UIImage, animate: Bool) {
        alpha = 0
        self.image = image
        UIView.transition(with: self, duration: (animate ? 0.2 : 0), options: .transitionCrossDissolve, animations: {
            self.alpha = 1
        }, completion: nil)
    }

}
