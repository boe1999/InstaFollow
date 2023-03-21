import instaloader
import os
from pathlib import Path

followersSet = set()
followeesSet = set()
unfollowersSet = set()
whiteList = set()

class Insta_info:

    def __init__(self, username):

        self.username = username
        self.loader = instaloader.Instaloader()
        self.profile = instaloader.Profile.from_username(self.loader.context,self.username)


    def Login(self, username, password):

        login = self.loader.login(username, password)

        #login = self.loader.load_session_from_file(self.username)

        return login

    def get_my_followers(self):
 
        for followers in self.profile.get_followers():
            followersSet.add(followers.username)
            #with open("followers.txt","a+") as f:
            #    file = f.write(followers.username+'\n')
    
    def get_my_followees(self):
 
        for followees in self.profile.get_followees():
            followeesSet.add(followees.username)
            #with open("followees.txt","a+") as f:
            #    file = f.write(followees.username+'\n')

    def get_my_unfollowers(self):
 
        followers = set(followersSet)
        followees = set(followeesSet)
        path = Path('./whiteList.txt')
        if path.is_file() == False:
            open("whiteList.txt","a+")
        whiteList = set(open("whiteList.txt","r").read().split('\n'))

        unfollowersSet = followees.difference(followers)
        unfollowersSet = unfollowersSet.difference(whiteList)
            
        for unfollowers in unfollowersSet:
            print(unfollowers)
                
       
def main():
    insta_info = Insta_info("daniele.boerio","Instagram11051999!")
    print("-----------------------------------------------------------------")
    insta_info.get_my_followers()
    insta_info.get_my_followees()
    insta_info.get_my_unfollowers()
    
def hello():
    print("Hello PythonKit")

