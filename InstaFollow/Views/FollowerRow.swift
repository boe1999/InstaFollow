//
//  FollowerRow.swift
//  InstaFollow
//
//  Created by Daniele Boerio on 14/03/23.
//

import SwiftUI

struct FollowerRow: View {
    var follower : Follower
    var body: some View {
        HStack{
            Image("instaLogo")
            .frame(width: 70, height: 70) .clipShape(RoundedRectangle(cornerRadius: 25))
            Text(follower.username)
        }
    }
}
