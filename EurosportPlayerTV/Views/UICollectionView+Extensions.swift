//
//  UICollectionView+Extensions.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 23/03/2017.


import Foundation

extension UICollectionView {

    func dequeueReusableCell<T>(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("unable to dequeue cell with identifier \(identifier) for indexPath: \(indexPath)")
        }
        return cell
    }

    func dequeueReusableSupplementaryView<T>(ofKind kind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("unable to dequeue view of kind \(kind) with identifier \(identifier) for indexPath: \(indexPath)")
        }
        return view
    }
    
}
