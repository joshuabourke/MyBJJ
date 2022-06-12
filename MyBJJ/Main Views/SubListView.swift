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
    
    var subVM = SubViewModel()
    @EnvironmentObject var vm: AddingNewSubViewModel
    @EnvironmentObject var subListVM: SubListViewModel
    
    
    @State var isNewBJJItemOpen: Bool = false
    @State var didTapProfileButton: Bool = false
    @State var ShouldShowLogOutOptions: Bool = false
    @State var didFinishLoginOrCreateAccount: Bool = false
    @State var presentSigninAlert: Bool = false
    
    //MARK: - TO UPDATE STATS VIEW FROM MAIN
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: SavedRolls.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \SavedRolls.subDate, ascending: false)])
    var savedSubs: FetchedResults<SavedRolls>
      
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack{
                if subListVM.isUserCurrentlyLoggedOut {
                    Button {
                        print("Sign up Button tapped")
                    } label: {
                        Text("This is just a test")
                    }

                } else {
                    List{
                        ForEach(vm.submissions) { submissions in
                            NavigationLink(destination: Text("This View will show details in future")) {
                                
                                SubmissionListRowChokes(submissionListModel: SubmissionListModel(upperLowerChoke: submissions.upperLowerChoke, sub: submissions.sub, date: formatTransactionTimestamp(submissions.date), winOrLoss: winOrLossIntoBool(winOrLoss: submissions.winOrLoss)))
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
            //MARK: - HANDLING WHEN USER TRIES TO ADD SUBMISSION WHEN THEY ARENT SIGNED IN
            .actionSheet(isPresented: $presentSigninAlert, content: {
                .init(title: Text("Sign In!"),message: Text("You must sign in before adding a new submission"), buttons: [.default(Text("Sign In"),action: {
                    didTapProfileButton = true
                }), .cancel()])
            })
            .navigationBarTitle("MyBJJ")
            .navigationBarItems(leading:
            HStack {
                let email = subListVM.myBJJUser?.email.replacingOccurrences(of: "@gmail.com", with: "")
                Button(action: {
                    print("GO TO LOGIN SCREEN BUTTON CLICKED")
                    if subListVM.isUserCurrentlyLoggedOut{
                        //If logged out allow user to open login/create account screen.
                        didTapProfileButton = true
                        
                    } else {
                        //Else the button will be a cog and allow the user to log out.
                        
                        ShouldShowLogOutOptions.toggle()
                    }
                }, label: {
                    Image(systemName: subListVM.isUserCurrentlyLoggedOut ? "person" : "person.fill")
                        .font(.system(size: 20).bold())
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
            }, label: {
                Image(systemName: "plus")
                    .font(.system(size: 20).bold())
            }))
            
        }//NAVIGATION
        .onAppear() {
                self.vm.getDataSubmissions()
                self.vm.fetchAllStats()
        }

        //MARK: - SIGN OUT ACTION SHEET.
        .actionSheet(isPresented: $ShouldShowLogOutOptions, content: {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [.destructive(Text("Sign Out"), action:{
                print("Handle Sign out")
                subListVM.handleSignOut()
            }), .cancel()])
        })
        //MARK: - NEW SKILL SHEET
        .sheet(isPresented: $isNewBJJItemOpen,onDismiss: {
            vm.getDataSubmissions()
            vm.fetchAllStats()
        }) {
            
            NewSkillView(newSubVM: AddingNewSubViewModel(myBJJUser: .init(data: ["uid": "bQsUeLnTOXg27Bp06PaUayRXQv82", "email" : "josh@gmail.com"])), isNewSubmissionOpen: $isNewBJJItemOpen)
        }
        //MARK: - FULL SCREEN LOG IN SCREEN / CREATE USER
        .fullScreenCover(isPresented: $didTapProfileButton) {
            LoginView(didFinishLoginProcess: {
                self.subListVM.isUserCurrentlyLoggedOut = false
                self.subListVM.fetchCurrentUser()
                
                
                if !subListVM.isUserCurrentlyLoggedOut{
                    didTapProfileButton = false
                }

            }, didFinishingLoggingIn: $didFinishLoginOrCreateAccount)
        }
    }


    
    //MARK: - FUNCTION
    func formatTransactionTimestamp(_ timestamp: Timestamp?) -> String {
        if let timestamp = timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            let date = timestamp.dateValue()
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
//        SubListView(vm: AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"])), lossMoreThanZero: .constant(false), winMoreThanZero: .constant(false))
        SubListView()
    }
}
