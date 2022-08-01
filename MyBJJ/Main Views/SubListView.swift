//
//  SubListView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 28/4/22.
//

import SwiftUI
import Firebase

struct SubListView: View {
    //MARK: - PROPERTIES
    
    //MARK: - TODO LIST FOR SUBLIST VIEW.
    
    //Need to check and see the user is signed in, if so then need to run a loading wheel to show the user that their submissions are coming. They are heading in from the cloud then once they are in then display the list of subs not the loading wheel. This could also be annoying in the sence that, if the user is logged in and they dont actually have any data logged. It will just keep spinning a loading wheel, will have to find a way to see if they actually have data on their account.
    
    //Also need to make buttons in the stat view and the list view when the user is signed out to then prompt them to login. Or send them to the login screen.
    
    //At the moment i want all people who use the app to sign in.
    //✅
    
    //Also for the app store need to allow users to delete their accounts. I could add it into the profile view down the bottom. But also make it a double button press. So they will have to press delete account and then confirm that they are actually wanting to delete their account.
    //✅
    
    
    var subVM = SubViewModel()
    @EnvironmentObject var vm: AddingNewSubViewModel
    @EnvironmentObject var subListVM: SubListViewModel
    
    //This will open the newSkillView
    @State var isNewBJJItemOpen: Bool = false
    
    //These 2 vars are used to open the full screen login cover. State is from the current view, and binding will be from the stats view.
    //Not sure if need the didtapProfileButton.
    @State var didTapProfileButton: Bool = false
    @Binding var needsToLogin: Bool
    
    @State var ShouldShowLogOutOptions: Bool = false
    
    @State var didFinishLoginOrCreateAccount: Bool = false
    //Showing log out alert
    @State var presentSigninAlert: Bool = false
    
    //This is just a switch to choose if the user has selected either Gi or noGi based on true of fale. Nogi if true and gi if false. This will add a differnt item into the list of their recorded submissions.
    @State var noGiOrGiSelection: Bool = true
    
    //Showing full screen profile view.
    @State var showProfileView: Bool = false
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                //Bottom of ZSTACK!
                GeometryReader { geo in
                    VStack{
                        if subListVM.isUserCurrentlyLoggedOut {
                            VStack {
                                //This VStack here will be shown to the user when they havent signed in and it will send them over to the login/create account screen.
                                Text("To start collecting your stats for MyBJJ make sure you...")
                                    .font(.body.bold())
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Button {
                                    //This button and text view will be shown when the user isnt signed in. This will open the the login and create account screen.

                                    //1. pop open the profile view for them to log in.
                                    needsToLogin.toggle()
                                    print("This button should take the user to the login screen")
                                    
                                } label: {
                                    Image(systemName: "person.fill")
                                        .font(.body.bold())
                                    Text("Login")
                                        .bold()
                            }
                                .buttonStyle(RectangleButton())
                                .frame(width: 120, height: 45)
                            }//: VSTACK
                        } else {
                            List{
                                ForEach(vm.submissions) { submissions in
                                    NavigationLink(destination: Text("This View will show details in future")) {
                                        
                                        SubmissionListRowChokes(submissionListModel: SubmissionListModel(upperLowerChoke: submissions.upperLowerChoke, sub: submissions.sub, date: formatTransactionTimestamp(submissions.date), winOrLoss: winOrLossIntoBool(winOrLoss: submissions.winOrLoss)), noGiOrGi: $noGiOrGiSelection)
                                    }
                                }
                                .onDelete(perform: delete)
                                
                            }//: LIST
                            .listStyle(.plain)
                            .onAppear(perform: {
                                UITableView.appearance().contentInset.top = +30
                            })
                            .cornerRadius(10)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .offset(x: self.showProfileView ? geo.size.width : 0)
                    .disabled(self.showProfileView ? true : false)
                    //MARK: - HANDLING WHEN USER TRIES TO ADD SUBMISSION WHEN THEY ARENT SIGNED IN
                    .actionSheet(isPresented: $presentSigninAlert, content: {
                        .init(title: Text("Sign In!"),message: Text("You must sign in before adding a new submission"), buttons: [.default(Text("Sign In"),action: {
                            didTapProfileButton = true
                            needsToLogin.toggle()
                        }), .cancel()])
                    })
                    .navigationBarTitle(showProfileView ? "Profile" : "MyBJJ")
                    .navigationBarItems(leading:
                                            HStack {
                        let email = subListVM.myBJJUser?.email.replacingOccurrences(of: "@gmail.com", with: "")
                        Button(action: {
                            print("GO TO LOGIN SCREEN BUTTON CLICKED")
                            if subListVM.isUserCurrentlyLoggedOut{
                                //If logged out allow user to open login/create account screen.
                                didTapProfileButton = true
                                needsToLogin.toggle()
                                
                            } else {
                                //This button is a person that isnt filled in when the user isnt signed in.
                                withAnimation {
                                    showProfileView.toggle()
                                }
                                //                            ShouldShowLogOutOptions.toggle()
                            }
                        }, label: {
                            
                            if showProfileView {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }//: HSTACK
                            } else {
                                Image(systemName: subListVM.isUserCurrentlyLoggedOut ? "person" : "person.fill")
                                    .font(.system(size: 20).bold())
                            }
                        })
                        Text(subListVM.isUserCurrentlyLoggedOut ? "" : "\(email ?? "")")
                            .font(.system(size: 18, weight: .bold))
                    }//: HSTACK
                                        
                    ,trailing: Button(action: {
                        print("plus Button")
                        
                        if subListVM.isUserCurrentlyLoggedOut {
                            presentSigninAlert.toggle()
                        } else {
                            isNewBJJItemOpen = true
                        }
                        if showProfileView {
                            withAnimation {
                                showProfileView.toggle()
                            }
                        }
                        
                    }, label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20).bold())
                    }))
                    
                    if self.showProfileView {
                        ProfileView(closeProfileView: $showProfileView)
                            .frame(width: geo.size.width)
                            .transition(.move(edge: .leading))
                    }
                }//: GEO
                //Top of ZSTACK!
            }//: ZSTACK
        }//NAVIGATION
        .onAppear() {
            self.vm.getDataSubmissions()
            self.vm.fetchAllStats()
        }
        
        //MARK: - SIGN OUT ACTION SHEET.
        //this is the sign out action sheet which i think isnt actually in use at the moment.
        .actionSheet(isPresented: $ShouldShowLogOutOptions, content: {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [.destructive(Text("Sign Out"), action:{
                print("Handle Sign out")
                subListVM.handleSignOut()
            }), .cancel()])
        })
        //MARK: - NEW SKILL SHEET
        //This will open a sheet the user can then log a new completed submission either win or loss.
        .sheet(isPresented: $isNewBJJItemOpen,onDismiss: {
            vm.getDataSubmissions()
            vm.fetchAllStats()
        }) {
            
            NewSkillView(newSubVM: AddingNewSubViewModel(myBJJUser: .init(data: ["uid": "bQsUeLnTOXg27Bp06PaUayRXQv82", "email" : "josh@gmail.com"])), isNewSubmissionOpen: $isNewBJJItemOpen, noGiOrGiSelection: $noGiOrGiSelection)
        }
        //MARK: - FULL SCREEN LOG IN SCREEN / CREATE USER
        //This is the full screen cover for the user to log in or create an account. Sign in with apple is also available.
        .fullScreenCover(isPresented: $needsToLogin, onDismiss: {
            vm.getDataSubmissions()
            vm.fetchAllStats()
        }) {
            LoginView(didFinishLoginProcess: {
                self.subListVM.isUserCurrentlyLoggedOut = false
                self.subListVM.fetchCurrentUser()
                
                
                if !subListVM.isUserCurrentlyLoggedOut{
                    didTapProfileButton = false
                    needsToLogin = false
                }
                
            }, didFinishingLoggingIn: $didFinishLoginOrCreateAccount)
        }
    }//: END OF VIEW
    
    
    
    //MARK: - FUNCTION
    func formatTransactionTimestamp(_ timestamp: Timestamp?) -> String {
        if let timestamp = timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            let format = "E, dd MMM yyyy h:mm a"
            let date = timestamp.dateValue()
            dateFormatter.dateFormat = format
            dateFormatter.locale = Locale.current
            let formatted = dateFormatter.string(from: date)
            return formatted
        }
        return ""
    }
    
    
    func delete(at offsets: IndexSet) {
        
        for i in offsets.makeIterator() {
            let submissionItem = vm.submissions[i]
            
            vm.deleteDataSubmissions(submissionToDelete: submissionItem)
            
            if submissionItem.upperLowerChoke == "Upper Body" && submissionItem.winOrLoss == "Win" {
                let upperBodyItem = vm.upperBodyWinsStruct[0]
                vm.deleteUpperWinStats(upperWinStatsToDelete: upperBodyItem)
                vm.upperBodyWinsStruct.removeFirst()
                self.vm.fetchAllStats()
            }
            
            else if submissionItem.upperLowerChoke == "Chokehold" && submissionItem.winOrLoss == "Win" {
                let chokeHoldItem = vm.chokeHoldWinsStruct[0]
                vm.deleteChokeWinStats(chokeWinStatsToDelete: chokeHoldItem)
                vm.chokeHoldWinsStruct.removeFirst()
                self.vm.fetchAllStats()
            }
            
            else if submissionItem.upperLowerChoke == "Lower Body" && submissionItem.winOrLoss == "Win" {
                let lowerBodyItem = vm.lowerBodyWinsStruct[0]
                vm.deleteLowerWinStats(lowerWinStatsToDelete: lowerBodyItem)
                vm.lowerBodyWinsStruct.removeFirst()
                self.vm.fetchAllStats()
                
            }
            
            else if submissionItem.upperLowerChoke == "Lower Body" && submissionItem.winOrLoss == "Loss" {
                let lowerBodyLossItem = vm.lowerBodyLossStruct[0]
                vm.deleteLowerLossStats(lowerLossStatsToDelete: lowerBodyLossItem)
                vm.lowerBodyLossStruct.removeFirst()
                self.vm.fetchAllStats()
                
            }
            
            else if submissionItem.upperLowerChoke == "Upper Body" && submissionItem.winOrLoss == "Loss" {
                let upperBodyLossItem = vm.upperBodyLossStruct[0]
                vm.deleteUpperLossStats(upperLossStatsToDelete: upperBodyLossItem)
                vm.upperBodyLossStruct.removeFirst()
                self.vm.fetchAllStats()
                
            }
            else if submissionItem.upperLowerChoke == "Chokehold" && submissionItem.winOrLoss == "Loss" {
                let chokeHoldLossItem = vm.chokeHoldLossStruct[0]
                vm.deleteChokeLossStats(chokeLossStatsToDelete: chokeHoldLossItem)
                vm.chokeHoldLossStruct.removeFirst()
                self.vm.fetchAllStats()
            }
        }
        vm.submissions.remove(atOffsets: offsets)
        
    }
    
    
    func winOrLossIntoBool(winOrLoss: String) -> Bool{
        
        var winLoss: Bool = true
        
        
        if winOrLoss == "Win"{
            winLoss = true
        } else if winOrLoss == "Loss"{
            winLoss = false
        }
        
        return winLoss
        
    }
    
}


//MARK: - PREVIEW
struct SubListView_Previews: PreviewProvider {
    static var previews: some View {
        SubListView(needsToLogin: .constant(false))
    }
}
