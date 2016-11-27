//
//  EurosportAccount.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 26/11/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import Foundation
import Locksmith

struct EurosportAccount: ReadableSecureStorable,
    CreateableSecureStorable,
    DeleteableSecureStorable,
GenericPasswordSecureStorable {
    
    let username: String
    let password: String
    
    let service = LocksmithDefaultService
    var account: String { return username }
    var data: [String: Any] {
        return ["password": password]
    }
    
}
