//
//  Followers.swift
//  InstaFollow
//
//  Created by Daniele Boerio on 14/03/23.
//

//struct Follower that permit to save this type of data
import Foundation
import SwiftUI
struct Follower: Hashable, Codable, Identifiable{
    var id: Int
    var username: String
}
