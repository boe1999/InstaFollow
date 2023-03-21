//
//  FollowerList.swift
//  InstaFollow
//
//  Created by Daniele Boerio on 14/03/23.
//

import SwiftUI

struct FollowerList: View {
    @Binding var unFollowers : String
    var body: some View {
        NavigationView{
            let followers: [Follower] = inizializzaLista(array: trattaArray(string: unFollowers))
            if(followers.count == 0){
                Text("[Nessun] Unfollower trovato")
            }else{
                List(followers) { follower in
                    FollowerRow(follower: follower)
                }
            }
        }.navigationTitle("Profili")
    }
}

func trattaArray(string: String) -> [String]{
    var myString = string
    var finalArray : [String] = []
    myString = String(myString.dropLast())
    myString = String(myString.dropFirst())
    let stringList = myString.split(separator: ",")
    stringList.forEach { word in
        var parola : String
        parola = String(word.dropLast())
        parola = String(parola.dropFirst())
        finalArray.append(parola)
    }
    return finalArray
}

func inizializzaLista(array : [String]) -> [Follower]{
    var index : Int = 0
    var followers : [Follower] = []
    array.forEach { stringa in
        let follow = Follower(id: index, username: stringa, url: "")
        followers.append(follow)
        index+=1
    }
    return followers
}


