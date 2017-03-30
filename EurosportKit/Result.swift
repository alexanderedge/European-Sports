//
//  Result.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 14/05/2016.

import Foundation

public enum Result <Value> {
    case success(Value)
    case failure(Error)
}
