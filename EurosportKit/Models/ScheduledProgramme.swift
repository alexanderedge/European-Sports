//
//  ScheduledProgramme.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/01/2017.


import Foundation
import CoreData

extension ScheduledProgramme: Int32Identifiable { }

extension ScheduledProgramme: Fetchable {

    public static var entityName: String {
        return "ScheduledProgramme"
    }

}
