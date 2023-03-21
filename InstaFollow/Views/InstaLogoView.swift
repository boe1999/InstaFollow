//
//  InstaLogoView.swift
//  InstaFollow
//
//  Created by Daniele Boerio on 14/03/23.
//

import SwiftUI

struct InstaLogoView: View {
    var body: some View {
        Image("instaLogo")
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.white,lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct InstaLogo_Previews: PreviewProvider {
    static var previews: some View {
        InstaLogoView()
    }
}
