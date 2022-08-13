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
    
    //Also need to make buttons in the stat view and the list view when the user is signed out to then prompt them to login. Or send them to the login screen.✅
    
    
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
    
    //Making the list searchable.
    var listData: [Submissions]{
        if upperChokeLowerSearchTerm.isEmpty {
            return vm.submissions
        } else {
            return vm.searchResults
        }
    }
    
    //Variables for filtering
    @State private var upperChokeLowerSearchTerm = ""
    @State private var giOrNoGiSearchTerm = ""
    @State private var winOrLossSearchTerm = ""
    //Toggles for fitlers.
    @State private var giIsOn: Bool = false
    @State private var noGiIsOn: Bool = false
    @State private var filterWins: Bool = false
    @State private var filterLoss: Bool = false
    @State private var giUpperIsOn: Bool = false
    @State private var giLowerIsOn: Bool = false
    @State private var giChokeIsOn: Bool = false
    @State private var noGiUpperIsOn: Bool = false
    @State private var noGiLowerIsOn: Bool = false
    @State private var noGiChokeIsOn: Bool = false
    @State private var allIsOn: Bool = true
    @State private var doesHaveGiOrNoGiField: Bool = true
    
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
                            VStack {
                                ListFilterHScrollToggles(giUpperIsOn: $giUpperIsOn, giLowerIsOn: $giLowerIsOn, giChokeIsOn: $giChokeIsOn, noGiUpperIsOn: $noGiUpperIsOn, noGiLowerIsOn: $noGiLowerIsOn, noGiChokeIsOn: $noGiChokeIsOn, all: $allIsOn, filterWins: $filterWins, filterLosses: $filterLoss, doesHaveGiOrNoGiField: $doesHaveGiOrNoGiField,     upperChokeLowerSearchTermPassed: $upperChokeLowerSearchTerm, giOrNoGiSearchTermPassed: $giOrNoGiSearchTerm, winOrLossSearchTermPassed: $winOrLossSearchTerm)

                                
                                //List of all of the users saved submissions. The list will append a new item depending on whether or not they have added a gi or nogi submission.
                                List{
                                    ForEach(listData) { submissions in
                                        NavigationLink(destination: Text("This View will show details in future")) {
                                            
                                            //If this is to work correctly it should check first to see if the user had check either gi or nogi. Once it has checked it will then insert the correct row for the list. This will also make sure the old data that everyone has saved with gi or no gi will be saved as nogi
                                            if submissions.giOrNoGi == "Gi" {
                                                SubmissionListRowGi(submissionListModel: SubmissionListModel(upperLowerChoke: submissions.upperLowerChoke, sub: submissions.sub, date: formatTransactionTimestamp(submissions.date), winOrLoss: winOrLossIntoBool(winOrLoss: submissions.winOrLoss)))
                                            } else if submissions.giOrNoGi == "NoGi" {
                                                SubmissionListRowChokes(submissionListModel: SubmissionListModel(upperLowerChoke: submissions.upperLowerChoke, sub: submissions.sub, date: formatTransactionTimestamp(submissions.date), winOrLoss: winOrLossIntoBool(winOrLoss: submissions.winOrLoss)))
                                            } else {
                                                SubmissionListRowChokes(submissionListModel: SubmissionListModel(upperLowerChoke: submissions.upperLowerChoke, sub: submissions.sub, date: formatTransactionTimestamp(submissions.date), winOrLoss: winOrLossIntoBool(winOrLoss: submissions.winOrLoss)))
                                            }
                                        }
                                    }
                                    .onDelete(perform: delete)
                                    
                                }//: LIST
                                .onChange(of: upperChokeLowerSearchTerm, perform: { search in
                                    //Using this to try and make a list using more than 1 filter per item, this is also expandable. I can filter more out more things.
                                    //This will check to see id doeshavegiornigifield is not true, then it will check to see if the item has giornogifield. Once that is all done it will return some filtered lists. If it passes through both if statments it will then just filter the subs based on their upper lower or choke, other wise it will filter them normally with both upperlowerchoke and giornogi.
                                    let filteredList = vm.submissions.filter({ filter in
                                        
                                        if doesHaveGiOrNoGiField == false {
                                            if filter.giOrNoGi.isEmpty == true {
                                                return filter.upperLowerChoke.hasPrefix(upperChokeLowerSearchTerm)
                                            } else {
                                                return filter.upperLowerChoke.hasPrefix(upperChokeLowerSearchTerm) && filter.giOrNoGi.hasPrefix(giOrNoGiSearchTerm)
                                            }
                                            
                                        } else {
                                            return filter.upperLowerChoke.hasPrefix(upperChokeLowerSearchTerm) &&  filter.giOrNoGi.hasPrefix(giOrNoGiSearchTerm)
                                        }
                                        
                                        
                                        
                                    })//: This is the filter for the user if they are wanting to search for giUpper giLower giChoke and so on.
                                    
                                    vm.searchResults = filteredList
                                })

                                .listStyle(.plain)
                                .onAppear(perform: {
                                    //                                    UITableView.appearance().contentInset.top = +30
                                })
                                .cornerRadius(10)
                            }//: VSTACK
                            .onChange(of: winOrLossSearchTerm, perform: { search in
                                let filteredList = vm.submissions.filter { filter in
                                        return filter.winOrLoss.hasPrefix(winOrLossSearchTerm)

                                }
                                vm.searchResults = filteredList
                            })// This is the filer for if the user is going to want to search for just Win or Loss
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
        
        //These constants are so that there will be no spelling errors in the writing of the cases.
        let chokeHoldConstant = "Chokehold"
        let upperBodyConstant = "Upper Body"
        let lowerBodyConstant = "Lower Body"
        let winConstant = "Win"
        let lossConstant = "Loss"
        let giConstant = "Gi"
        let noGiConstant = "NoGi"
        
        
        
        for i in offsets.makeIterator() {
            let submissionItem = vm.submissions[i]
            
            //This let is just grabbing the result from the deleted index and then creating the constant to be switched over. After being switch over we will then delete from the data base according to the case.
            vm.deleteDataSubmissions(submissionToDelete: submissionItem)
            let result = (submissionItem.upperLowerChoke, submissionItem.winOrLoss, submissionItem.giOrNoGi)
            //MARK: - SWITCH FOR DELETING
            //This switch over the result is to delete the right items from the users database. This is to replace the old mile long if else.
            switch result {
                //MARK: - LOWER DELETE CASE
            case (lowerBodyConstant, winConstant, giConstant):
                print("Delete Lower Body Win Gi")
                let lowerBodyGiWinItem = vm.lowerBodyWinsGiStruct[0]
                vm.deleteLowerWinGiStats(lowerWinStatsToDelete: lowerBodyGiWinItem)
                vm.lowerBodyWinsGiStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (lowerBodyConstant, lossConstant, giConstant):
                print("Delete Lower Body Loss Gi")
                let lowerBodyGiLossItem = vm.lowerBodyLossGiStruct[0]
                vm.deleteLowerLossGiStats(lowerLossStatsToDelete: lowerBodyGiLossItem)
                vm.lowerBodyLossGiStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (lowerBodyConstant, winConstant, noGiConstant):
                print("Delete Lower Body Win NoGi")
                let lowerBodyNoGiWinItem = vm.lowerBodyWinsStruct[0]
                vm.deleteLowerWinStats(lowerWinStatsToDelete: lowerBodyNoGiWinItem)
                vm.lowerBodyWinsStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (lowerBodyConstant, lossConstant, noGiConstant):
                print("Delete Lower Body Loss NoGi")
                let lowerBodyNoGiLossItem = vm.lowerBodyLossStruct[0]
                vm.deleteLowerLossStats(lowerLossStatsToDelete: lowerBodyNoGiLossItem)
                vm.lowerBodyLossStruct.removeFirst()
                self.vm.fetchAllStats()
                //End of Lower Body cases
                
                //MARK: - UPPER DELETE CASE
            case (upperBodyConstant, winConstant, giConstant):
                print("Delete Upper Body Win Gi")
                let upperBodyGiWinItem = vm.upperBodyWinsGiStruct[0]
                vm.deleteUpperWinGiStats(upperWinStatsToDelete: upperBodyGiWinItem)
                vm.upperBodyWinsGiStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (upperBodyConstant, lossConstant, giConstant):
                print("Delete Upper Body Loss Gi")
                let upperBodyGiLossItem = vm.upperBodyLossGiStruct[0]
                vm.deleteUpperLossGiStats(upperLossStatsToDelete: upperBodyGiLossItem)
                vm.upperBodyLossGiStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (upperBodyConstant, winConstant, noGiConstant):
                print("Delete Upper Body Win NoGi")
                let upperBodyNoGiWinItem = vm.upperBodyWinsStruct[0]
                vm.deleteUpperWinStats(upperWinStatsToDelete: upperBodyNoGiWinItem)
                vm.upperBodyWinsStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (upperBodyConstant, lossConstant, noGiConstant):
                print("Delete Upper Body Loss NoGi")
                let upperBodyNoGiLossItem = vm.upperBodyLossStruct[0]
                vm.deleteUpperLossStats(upperLossStatsToDelete: upperBodyNoGiLossItem)
                vm.upperBodyLossStruct.removeFirst()
                self.vm.fetchAllStats()
                //End of Upper Body cases
                
                //MARK: - CHOKE DELETE CASE
            case (chokeHoldConstant, winConstant, giConstant):
                print("Delete Chokehold Win Gi")
                let chokeHoldGiWinItem = vm.chokeHoldWinsGiStruct[0]
                vm.deleteChokeWinGiStats(chokeWinStatsToDelete: chokeHoldGiWinItem)
                vm.chokeHoldWinsGiStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (chokeHoldConstant, lossConstant, giConstant):
                print("Delete Chokehold Loss Gi")
                let chokeHoldGiLossItem = vm.chokeHoldLossGiStruct[0]
                vm.deleteChokeLossGiStats(chokeLossStatsToDelete: chokeHoldGiLossItem)
                vm.chokeHoldLossGiStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (chokeHoldConstant, winConstant, noGiConstant):
                print("Delete Chokehold Win NoGi")
                let chokeHoldNoGiWinItem = vm.chokeHoldWinsStruct[0]
                vm.deleteChokeWinStats(chokeWinStatsToDelete: chokeHoldNoGiWinItem)
                vm.chokeHoldWinsStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (chokeHoldConstant, lossConstant, noGiConstant):
                print("Delete Chokehold Loss NoGi")
                let chokeHoldNoGiLossItem = vm.chokeHoldLossStruct[0]
                vm.deleteChokeLossStats(chokeLossStatsToDelete: chokeHoldNoGiLossItem)
                vm.chokeHoldLossStruct.removeFirst()
                self.vm.fetchAllStats()
                //End of Chokehold cases
            //MARK: - CASES TO COVER ALL OLD SAVED SUBMISSIONS(This is before I added Gi and NoGi tag to subs)
            case (chokeHoldConstant, winConstant, _):
                print("Delete Old Chokehold Win")
                let chokeHoldOldData = vm.chokeHoldWinsStruct[0]
                vm.deleteChokeWinStats(chokeWinStatsToDelete: chokeHoldOldData)
                vm.chokeHoldWinsStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (chokeHoldConstant, lossConstant, _):
                print("Delete Old Chokehold Loss")
                let chokeHoldOldDataLoss = vm.chokeHoldLossStruct[0]
                vm.deleteChokeLossStats(chokeLossStatsToDelete: chokeHoldOldDataLoss)
                vm.chokeHoldLossStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (upperBodyConstant, winConstant, _):
                print("Delete Old Upper Body Win")
                let upperBodyItem = vm.upperBodyWinsStruct[0]
                vm.deleteUpperWinStats(upperWinStatsToDelete: upperBodyItem)
                vm.upperBodyWinsStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (upperBodyConstant, lossConstant, _):
                print("Delete Old Upper Body Loss")
                let upperBodyLossItem = vm.upperBodyLossStruct[0]
                vm.deleteUpperLossStats(upperLossStatsToDelete: upperBodyLossItem)
                vm.upperBodyLossStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (lowerBodyConstant, winConstant, _):
                print("Delete Old Lower Body Win")
                let lowerBodyItem = vm.lowerBodyWinsStruct[0]
                vm.deleteLowerWinStats(lowerWinStatsToDelete: lowerBodyItem)
                vm.lowerBodyWinsStruct.removeFirst()
                self.vm.fetchAllStats()
                
            case (lowerBodyConstant, lossConstant, _):
                print("Delete Old Lower Body Loss")
                let lowerBodyLossItem = vm.lowerBodyLossStruct[0]
                vm.deleteLowerLossStats(lowerLossStatsToDelete: lowerBodyLossItem)
                vm.lowerBodyLossStruct.removeFirst()
                self.vm.fetchAllStats()
            //End of Deleting old data, with out the gi or nogi label.
            default:
                print("UNKNOWN DELETE Was unable to find a case to delete.")
            }
//
//            if submissionItem.giOrNoGi == "Gi"{
//                if submissionItem.upperLowerChoke == "Upper Body" && submissionItem.winOrLoss == "Win" {
//                    let upperBodyItem = vm.upperBodyWinsStruct[0]
//                    vm.deleteUpperWinStats(upperWinStatsToDelete: upperBodyItem)
//                    vm.upperBodyWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//
//                else if submissionItem.upperLowerChoke == "Chokehold" && submissionItem.winOrLoss == "Win" {
//                    let chokeHoldItem = vm.chokeHoldWinsStruct[0]
//                    vm.deleteChokeWinStats(chokeWinStatsToDelete: chokeHoldItem)
//                    vm.chokeHoldWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//
//                else if submissionItem.upperLowerChoke == "Lower Body" && submissionItem.winOrLoss == "Win" {
//                    let lowerBodyItem = vm.lowerBodyWinsStruct[0]
//                    vm.deleteLowerWinStats(lowerWinStatsToDelete: lowerBodyItem)
//                    vm.lowerBodyWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//
//                else if submissionItem.upperLowerChoke == "Lower Body" && submissionItem.winOrLoss == "Loss" {
//                    let lowerBodyLossItem = vm.lowerBodyLossStruct[0]
//                    vm.deleteLowerLossStats(lowerLossStatsToDelete: lowerBodyLossItem)
//                    vm.lowerBodyLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//
//                else if submissionItem.upperLowerChoke == "Upper Body" && submissionItem.winOrLoss == "Loss" {
//                    let upperBodyLossItem = vm.upperBodyLossStruct[0]
//                    vm.deleteUpperLossStats(upperLossStatsToDelete: upperBodyLossItem)
//                    vm.upperBodyLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//                else if submissionItem.upperLowerChoke == "Chokehold" && submissionItem.winOrLoss == "Loss" {
//                    let chokeHoldLossItem = vm.chokeHoldLossStruct[0]
//                    vm.deleteChokeLossStats(chokeLossStatsToDelete: chokeHoldLossItem)
//                    vm.chokeHoldLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//
//            }
//            else if submissionItem.giOrNoGi == "NoGi" {
//                if submissionItem.upperLowerChoke == "Upper Body" && submissionItem.winOrLoss == "Win" {
//                    let upperBodyItem = vm.upperBodyWinsStruct[0]
//                    vm.deleteUpperWinStats(upperWinStatsToDelete: upperBodyItem)
//                    vm.upperBodyWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//
//                else if submissionItem.upperLowerChoke == "Chokehold" && submissionItem.winOrLoss == "Win" {
//                    let chokeHoldItem = vm.chokeHoldWinsStruct[0]
//                    vm.deleteChokeWinStats(chokeWinStatsToDelete: chokeHoldItem)
//                    vm.chokeHoldWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//
//                else if submissionItem.upperLowerChoke == "Lower Body" && submissionItem.winOrLoss == "Win" {
//                    let lowerBodyItem = vm.lowerBodyWinsStruct[0]
//                    vm.deleteLowerWinStats(lowerWinStatsToDelete: lowerBodyItem)
//                    vm.lowerBodyWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//
//                else if submissionItem.upperLowerChoke == "Lower Body" && submissionItem.winOrLoss == "Loss" {
//                    let lowerBodyLossItem = vm.lowerBodyLossStruct[0]
//                    vm.deleteLowerLossStats(lowerLossStatsToDelete: lowerBodyLossItem)
//                    vm.lowerBodyLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//
//                else if submissionItem.upperLowerChoke == "Upper Body" && submissionItem.winOrLoss == "Loss" {
//                    let upperBodyLossItem = vm.upperBodyLossStruct[0]
//                    vm.deleteUpperLossStats(upperLossStatsToDelete: upperBodyLossItem)
//                    vm.upperBodyLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//                else if submissionItem.upperLowerChoke == "Chokehold" && submissionItem.winOrLoss == "Loss" {
//                    let chokeHoldLossItem = vm.chokeHoldLossStruct[0]
//                    vm.deleteChokeLossStats(chokeLossStatsToDelete: chokeHoldLossItem)
//                    vm.chokeHoldLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//            }
//            else {
//                if submissionItem.upperLowerChoke == "Upper Body" && submissionItem.winOrLoss == "Win" {
//                    let upperBodyItem = vm.upperBodyWinsStruct[0]
//                    vm.deleteUpperWinStats(upperWinStatsToDelete: upperBodyItem)
//                    vm.upperBodyWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//
//                else if submissionItem.upperLowerChoke == "Chokehold" && submissionItem.winOrLoss == "Win" {
//                    let chokeHoldItem = vm.chokeHoldWinsStruct[0]
//                    vm.deleteChokeWinStats(chokeWinStatsToDelete: chokeHoldItem)
//                    vm.chokeHoldWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//
//                else if submissionItem.upperLowerChoke == "Lower Body" && submissionItem.winOrLoss == "Win" {
//                    let lowerBodyItem = vm.lowerBodyWinsStruct[0]
//                    vm.deleteLowerWinStats(lowerWinStatsToDelete: lowerBodyItem)
//                    vm.lowerBodyWinsStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//
//                else if submissionItem.upperLowerChoke == "Lower Body" && submissionItem.winOrLoss == "Loss" {
//                    let lowerBodyLossItem = vm.lowerBodyLossStruct[0]
//                    vm.deleteLowerLossStats(lowerLossStatsToDelete: lowerBodyLossItem)
//                    vm.lowerBodyLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//
//                else if submissionItem.upperLowerChoke == "Upper Body" && submissionItem.winOrLoss == "Loss" {
//                    let upperBodyLossItem = vm.upperBodyLossStruct[0]
//                    vm.deleteUpperLossStats(upperLossStatsToDelete: upperBodyLossItem)
//                    vm.upperBodyLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//
//                }
//                else if submissionItem.upperLowerChoke == "Chokehold" && submissionItem.winOrLoss == "Loss" {
//                    let chokeHoldLossItem = vm.chokeHoldLossStruct[0]
//                    vm.deleteChokeLossStats(chokeLossStatsToDelete: chokeHoldLossItem)
//                    vm.chokeHoldLossStruct.removeFirst()
//                    self.vm.fetchAllStats()
//                }
//
//            }
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
