//
//  Followers.swift
//  InstaFollow
//
//  Created by Daniele Boerio on 14/03/23.
//

import Foundation
import SwiftUI
struct Follower: Hashable, Codable, Identifiable{
    var id: Int
    var username: String
    var url : String
}
