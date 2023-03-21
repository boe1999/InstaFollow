//
//  ContentView.swift
//  InstaFollow
//
//  Created by Daniele Boerio on 14/03/23.
//

//HomePage of the app

import SwiftUI
struct ContentView: View {
    
    //need for navigation to next view after the success of the login
    @State var signInSuccess = false
    //store the Array of string retrieved from internet
    @State var unFollowers = ""
    var body: some View {
        if signInSuccess {
            
            //function for navigate to next view
            FollowerList(unFollowers: $unFollowers)
        }
        else {
            NavigationView{
                Home(signInSuccess: $signInSuccess, unFollowers: $unFollowers)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View{
    //username and password from textView
    @State var username : String = ""
    @State var password : String = ""
    //state that need for showing alert when needed
    @State private var showingAlert = false
    //message to prompt in the alert
    @State var message : String = ""
    //state that need for show popUp when needed
    @State var showPopUp = false
    //Binding of variable signInSuccess
    @Binding var signInSuccess: Bool
    //Binding of variable unFollowers
    @Binding var unFollowers: String
    //state that need for remove keyboard when click on the button
    @FocusState private var inputFocused: Bool
    
    //color scheme for dark mode
    @Environment(\.colorScheme) var scheme
    
    
    var body: some View{
        ZStack{
            VStack{
                //insert logo
                InstaLogoView()
                    .offset(y: -130)
                    .padding(.bottom, -130)
                    .padding()
                //insert username and password textView
                UsernameTextView
                PasswordTextView
                
                //insert button "accedi"
                Button(action: {
                    //function for dismiss keyboard when button clicked
                    dismissKeyword()
                    //add animation when showPopUp is true
                    withAnimation(.spring()){showPopUp.toggle()}
                    
                    //start the task for take unfollowers from internet
                    Task {
                        //setup url
                        guard let url = URL(string: "https://246a-93-41-233-102.eu.ngrok.io/?user="+username+"&&passw="+password) else{
                            return
                        }
                        //setup session configuration to have timeout setted not by default
                        let sessionConfig = URLSessionConfiguration.default
                        sessionConfig.timeoutIntervalForRequest = 20.0
                        
                        //start the task with urlSession
                        let task = URLSession(configuration: sessionConfig).dataTask(with: url){
                                data, response, error in
                            
                            //if timeout
                            if (error as? URLError)?.code == .timedOut {
                                message = "timeOut request"
                                showPopUp.toggle()
                                showingAlert = true
                                return
                            }
                            
                            //retrieve data
                            guard let data = data else { return }
                            
                            //retrieve response code
                            guard let response = response else { return }
                                        
                            //show popUp when response is between (200 and 530]
                            guard let response = response as? HTTPURLResponse, (200 ..< 530) ~= response.statusCode else {
                                message = "Error: HTTP request failed"
                                    showingAlert = true
                                    return
                            }
                            
                            //if response is 200 all is okay
                            if response.statusCode == 200 {
                                print("Status code is 200")
                                do {
                                    
                                    //take taka string from internet
                                    unFollowers = String(data: data, encoding: .utf8) ?? ""
                                    print(unFollowers)
                                    
                                    //catch and error from API
                                    if(unFollowers == "Login error: Wrong password.")||(unFollowers == "Profile " + username.lowercased() + " does not exist.")||(unFollowers=="JSON Query to graphql/query: HTTP error code 401.")||(unFollowers.localizedStandardContains("Sorry, your password was incorrect. Please double-check your password.")){
                                        message = unFollowers
                                        showingAlert = true
                                    }else{
                                        signInSuccess = true
                                    }
                                }
                            //catch error in response
                            } else if response.statusCode == 422 {
                                message = "Status code is 422"
                                showingAlert = true
                                return
                            }
                            showPopUp.toggle()
                        }
                        task.resume()
                    }
                }, label : {
                    Text("Accedi")
                        .fontWeight(.semibold)
                        .foregroundColor(scheme == .dark ? Color.black : Color.white)
                        .padding(.vertical,12)
                        .frame(maxWidth: .infinity)
                        .background{
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(.blue)
                        }
                })
                //disable button when username and passoword are empty
                .disableWithOpacity(username.count < 1 || password.count < 1)
                .alert(message, isPresented: $showingAlert) {
                            Button("OK") { }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            ZStack{
                if(showPopUp){
                    Color.primary.opacity(0.2)
                        .ignoresSafeArea()
                    DribbleAnimatedView(showPopUp: $showPopUp)
                }
                    
            }
        )
    }
}

//amimation of loading
struct DribbleAnimatedView: View{
    @Environment(\.colorScheme) var scheme
    
    @Binding var showPopUp : Bool
    
    @State private var animateLoading = false
    var body: some View{
        ZStack{
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.blue, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: animateLoading ? 360 : 0))
        }
        .onAppear(perform: {
            doAnimation()
        })
    }
    
    func doAnimation(){
        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)){
            animateLoading.toggle()
        }
    }
}

//setup of textviews
private extension Home{
    var UsernameTextView: some View{
        TextField("Username", text: $username)
            .textContentType(.username)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding(.bottom)
            .focused($inputFocused)
    }
    
    var PasswordTextView: some View{
        SecureField("Password", text: $password)
            .textContentType(.password)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)
            .padding(.bottom)
            .focused($inputFocused)
    }
}

//function for the opacity during the loading and to dismiss keyboard pressing the button
extension View{
    func disableWithOpacity(_ condition: Bool) ->some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func dismissKeyword(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
