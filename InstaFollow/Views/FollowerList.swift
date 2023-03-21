//
//  FollowerList.swift
//  InstaFollow
//
//  Created by Daniele Boerio on 14/03/23.
//

//view of the list of unfollowers

import SwiftUI

struct FollowerList: View {
    @Binding var unFollowers : String
    var body: some View {
        NavigationView{
            
            //setup the unfollower list using function
            let followers: [Follower] = initializeList(array: treatArray(idk: unFollowers))
            //show text if no unfollowers in the list
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

func treatArray(idk: String) -> [String]{
    var myString = idk
    var finalArray : [String] = []
    //drop first and last char becouse i have parantesies []
    myString = String(myString.dropLast())
    myString = String(myString.dropFirst())
    //split the list
    let splittedList = myString.split(separator: ",")
    //for each word in the list drop first and last chat becouse i have ""
    splittedList.forEach { word in
        var parola : String
        parola = String(word.dropLast())
        parola = String(parola.dropFirst())
        finalArray.append(parola)
    }
    return finalArray
}

//initialize a list aving an Array of Strings
func initializeList(array : [String]) -> [Follower]{
    var index : Int = 0
    var followers : [Follower] = []
    array.forEach { stringa in
        let follow = Follower(id: index, username: stringa)
        followers.append(follow)
        index+=1
    }
    return followers
}


