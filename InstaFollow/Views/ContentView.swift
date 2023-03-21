//
//  ContentView.swift
//  InstaFollow
//
//  Created by Daniele Boerio on 14/03/23.
//

import SwiftUI
struct ContentView: View {
    @State var signInSuccess = false
    @State var unFollowers = ""
    var body: some View {
        if signInSuccess {
            FollowerList(unFollowers: $unFollowers)
            //NavigationLink(destination: FollowerList(unFollowers: $unFollowers))
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
    @State var username : String = ""
    @State var password : String = ""
    @State private var showingAlert = false
    @State var messaggio : String = ""
    @State var showPopUp = false
    @Binding var signInSuccess: Bool
    @Binding var unFollowers: String
    @FocusState private var inputFocused: Bool
    
    //color scheme for dark mode
    @Environment(\.colorScheme) var scheme
    
    
    var body: some View{
        ZStack{
            VStack{
                InstaLogoView()
                    .offset(y: -130)
                    .padding(.bottom, -130)
                    .padding()
                UsernameTextView
                PasswordTextView
                
                Button(action: {
                    dismissKeyword()
                    withAnimation(.spring()){showPopUp.toggle()}
                    Task {
                        guard let url = URL(string: "https://246a-93-41-233-102.eu.ngrok.io/?user="+username+"&&passw="+password) else{
                            return
                        }
                        let sessionConfig = URLSessionConfiguration.default
                        sessionConfig.timeoutIntervalForRequest = 20.0
                        let task = URLSession(configuration: sessionConfig).dataTask(with: url){
                                data, response, error in
                            
                            if (error as? URLError)?.code == .timedOut {
                                messaggio = "timeOut request"
                                showPopUp.toggle()
                                showingAlert = true
                                return
                            }
                            guard let data = data else { return }
                            guard let response = response else { return }
                                        
                            guard let response = response as? HTTPURLResponse, (200 ..< 530) ~= response.statusCode else {
                                    messaggio = "Error: HTTP request failed"
                                    showingAlert = true
                                    return
                            }
                                        
                            if response.statusCode == 200 {
                                print("Status code is 200")
                                do {
                                    unFollowers = String(data: data, encoding: .utf8) ?? ""
                                    print(unFollowers)
                                    if(unFollowers == "Login error: Wrong password.")||(unFollowers == "Profile " + username.lowercased() + " does not exist.")||(unFollowers=="JSON Query to graphql/query: HTTP error code 401.")||(unFollowers.localizedStandardContains("Sorry, your password was incorrect. Please double-check your password.")){
                                        messaggio = unFollowers
                                        showingAlert = true
                                    }else{
                                        signInSuccess = true
                                    }
                                }
                            } else if response.statusCode == 422 {
                                messaggio = "Status code is 422"
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
                .disableWithOpacity(username.count < 1 || password.count < 1)
                .alert(messaggio, isPresented: $showingAlert) {
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
