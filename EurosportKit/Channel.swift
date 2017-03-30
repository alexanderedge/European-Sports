//
//  Channel.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/01/2017.


import Foundation
import CoreData

extension Channel: Int32Identifiable { }

extension Channel: Fetchable {

    public static var entityName: String {
        return "Channel"
    }

}
