//
//  LiveStream.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/01/2017.

import Foundation
import CoreData

extension LiveStream: Fetchable {

    public static var entityName: String {
        return "LiveStream"
    }

}

extension LiveStream: AuthenticatedResource { }
