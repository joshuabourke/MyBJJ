//
//  ProfileView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/6/2022.
//

import SwiftUI
import CoreData

//This is going to be used to make the new reminders list using coredata
struct LocalReminders {
    var id = UUID()
    var hours: Int
    var mintues: Int
    var dayOfTheWeek: Int
}

//MARK: - THINGS TO DO
//1.
//Need to make a delete user button. The users should be able to delete their accounts and all their data if they want to. Gives them more freedom in what happens with their data
//THIS HAS BEEN ACHEIVED!!!

//2.
//Also might need to set to the user a number for thier belt rank. That way i can save their belt rank to the users id, whilest also logging subs to their belt rank
//Thinking about this one ^ could make a function that takes in a number and returns a beltView.
//I will need to write out all the possible outcomes for the for the beltView
//e.g white, white 1 stripe, white 2 stripe, white 3 stripe and soo on. with all the different combinations of belt.

//Also need to find a way to get more into this view, as in anything I have tried to add recently has been throwing an error.
//FIXED THIS PROBLEM (extracted the view and also grouped everything.)

//3. Wanting to add a background color to the grouping on the profile view kinda like how i have done in fructus.
struct ProfileView: View {
    
    //MARK: - CORE DATA FOR REMINDERS
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: UserReminders.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \UserReminders.reminderDay, ascending: true)])
    
    
    var savedReminders: FetchedResults<UserReminders>
    
    //MARK: - PROPERTIES
    @State var hours: Int = 0
    @State var mintues: Int = 0
    @State var dayOfTheWeek: Int = 0

    @EnvironmentObject var newSubVM: AddingNewSubViewModel
    
    @EnvironmentObject var subListVM: SubListViewModel
    @Binding var closeProfileView: Bool
    @State var didTapAddReminders: Bool = false
    @State var didTapDeleteAccountButton: Bool = false
    

    @State var beltRankNumber: Int = 0
    //MARK: - BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            profileView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(colorScheme == .dark ? Color.black: Color(UIColor.secondarySystemBackground))
                .ignoresSafeArea()
            
            .sheet(isPresented: $didTapAddReminders) {
                NotificationSettingsView(hours: $hours, mintues: $mintues, dayOfTheWeek: $dayOfTheWeek)
            }//: Sheet
        }//: Scroll
        .onAppear(){
            newSubVM.getBeltRankData()
            checkForBeltRank()
        }
        .onDisappear(){
            newSubVM.getBeltRankData()
        }

    }
    
    //MARK: - EXTRACTED VIEWS
    private var profileView: some View {
        VStack{
            Group {
                VStack {
                    HStack {
                        Text("Rank")
                            .font(.title)
                            .bold()
                        Spacer()
                        Image(systemName: "figure.stand")
                            .font(.body.bold())
                    }//: HSTACK
                    HStack {
                        Text("Tap to select your Brazilian Jiu jitsu belt rank")
                            .font(.caption)
                            .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical,4)
                //MARK: - BELT RANK VIEW
                //This view is just to display the users belt rank. I havent started collecting data based on the belt rank but that is a possibility in the future.
                    BeltViewMenu(beltRankNumber: $beltRankNumber)
                //This beltview menu in the profile view will allow users to change their belt rank. By tapping on the belt in the profile view it will present them with a menu where they can change their belt rank.
                    .contextMenu {
                        Button {
                            
                            print("Change Belt Settings")
                        } label: {
                            Label("Change belt", systemImage: "person")
                        }
                    }
                }//: VSTACK
            }//: BELTVIEW GROUPING
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            Spacer()
            Group{
                VStack{
                    HStack {
                        Text("Reminders")
                            .font(.title)
                            .bold()
                        Spacer()
                        Image(systemName: "bell")
                            .font(.body.bold())
                    }//: HSTACK
                    HStack {
                        Text("Reminders can be set to help remind you on when you should log your BJJ progress")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical,4)
            //MARK: - LIST OF REMINDERS
            //Thinking of using this list to display to the user what reminders they have active at the moment.
                List{
                    ForEach(savedReminders, id:\.self.reminderID) { reminders in
                        ReminderListViewItem(hours: reminders.reminderHours, minutes: reminders.reminderMinutes, dayOfTheWeek: reminders.reminderDay)
                    }
                    .onDelete(perform: removeFromCoreData)
                }//: LIST
                .frame(height: 300)
                .cornerRadius(30)
                .listStyle(.insetGrouped)
                .padding(.bottom)
                //MARK: - ADD REMINDERS - BUTTON
                //This button displays a sheet that the user can then select a time and day of the week they would like to be reminded to log their progress.
                Button{
                    print("Add new notification")
                    didTapAddReminders.toggle()
                } label: {
                    Image(systemName: "bell")
                        .font(.body.bold())
                    Text("Add Reminder")
                        .bold()
                }
                .buttonStyle(RectangleButton())
                .frame(width: 220, height: 45)
                }//: VSTACK
            }//: REMINDER GROUP WITH LIST
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))

            //MARK: - REMOVE REMINDERS BUTTON
            //This button below is for removing all of the added reminders that the user has set. It currently only removes all of them not just a specific one.
            //                Button {
            //                    print("Remove all added notifications *Pressed*")
            //                    NotificationManager.instance.cancelAllNotifications()
            //                } label: {
            //                    Image(systemName: "bell.slash")
            //                        .font(.body.bold())
            //                    Text("Delete reminders")
            //                        .fontWeight(.bold)
            //                        .foregroundColor(.white)
            //                }
            //                .buttonStyle(RedRectangleButton())
            //                .frame(width: 220, height: 45)
            //                .padding()
            //THIS IS COMMENTED OUT FOR THE TIME BEING. I would also like this to remove all the saved items in the list above this.
            Group {
                VStack {
                    HStack {
                        Text("Support")
                            .font(.title)
                            .bold()
                        Spacer()
                        Image(systemName: "ant")
                            .font(.body.bold())
                    }//: HSTACK
                    HStack{
                        Text("If you come across any bugs or issues with MyBJJ, feel free to send an email through to support.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical,4)
                    //MARK: - MAILTO LINK
                    //This link below should send the user to their default email application. Once they are there it will prefill a support ticket for them as in the subject of the email and the emial address.
                    Button  {
                        print("Feedback button pressed")
                        sendEmailToSupport()
                    } label: {
                        Image(systemName: "ant")
                            .font(.body.bold())
                        Text("Help!")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(RectangleButton())
                    .frame(width: 220, height: 45)
                }//: VSTACK
            }//: FEEDBACK GROUP
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            Group{
                VStack{
                    HStack {
                        Text("User Options")
                            .font(.title)
                            .bold()
                        Spacer()
                        Image(systemName: "person.fill")
                            .font(.body.bold())
                    }//: HSTACK
                    HStack{
                        Text("Log out of MyBJJ, all submissions and progress will be saved to your account.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical,4)

                //MARK: - LOG OUT BUTTON
                //The button below handles the users log out and stops displaying all of the users data.
                Button {
                    print("Log out")
                    subListVM.handleSignOut()
                    withAnimation {
                        closeProfileView.toggle()
                    }
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.body.bold())
                    Text("Log Out")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .buttonStyle(RedRectangleButton())
                .frame(width: 220, height: 45)
                }//: VSTACK
            }//: LOGOUT GROUPING
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            Group{
                VStack {
                    HStack {
                        Text("Delete Account")
                            .font(.title)
                            .bold()
                        Spacer()
                        Image(systemName: "trash")
                            .font(.body.bold())
                    }//: HSTACK
                    HStack{
                        Text("The button below will remove your account from MyBJJ completely. You will need to create a new account after performing this action.")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical, 4)
                //MARK: - DELETE ACCOUNT BUTTON.
                //This button is so if the user would like to remove all thier account data from the firestore.
                Button {
                    print("Account Delete Button pressed")
                    didTapDeleteAccountButton.toggle()
//                    withAnimation {
//                        closeProfileView.toggle()
//                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.body.bold())
                    Text("Delete Account")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .buttonStyle(RedRectangleButton())
                .frame(width: 220, height: 45)
                //This deleted the account but also need the update the list view and the stat view.
                //
                }//: VSTACK
            }//DELETE ACCOUNT GROUPING
            .padding()
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            .actionSheet(isPresented: $didTapDeleteAccountButton, content: {
                .init(title: Text("WAIT!"),message: Text("Are you sure you would like to delete your MyBJJ account permanently"), buttons: [.default(Text("No").bold(),action: {
                    didTapDeleteAccountButton = false
                }), .destructive(Text("Yes"),action: {
                    subListVM.handleAccountDeletion()
                    subListVM.isUserCurrentlyLoggedOut.toggle()
                })])
            })
        }//: VSTACK
        .padding()

    }//: EXTRACTED PROFILE VIEW.
    
    
    //MARK: - FUNCTIONS
    //MARK: - MAILTO FUNC
    //This function should either open up the mail app or.. It should open the default mail app the user has set on their phone. It will prefill the email section with the support email whilst also filling the subject field with "MyBJJ feeback form"
    func sendEmailToSupport() {
        let mailtoString = "mailto:mybjj.apphelp@gmail.com?subject=MyBJJ Feedback Form".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoURL = URL(string: mailtoString!)!
        if UIApplication.shared.canOpenURL(mailtoURL) {
            UIApplication.shared.open(mailtoURL, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: - CHECK FOR USERS BELT RANK
    func checkForBeltRank() {
        let beltRank = newSubVM.beltRankStruct.first?.beltRank

        switch beltRank {
        case 1:
            beltRankNumber = 1
            print("Belt rank 1")
            
        case 2:
            beltRankNumber = 2
            print("Belt Rank 2")

        case 3:
            beltRankNumber = 3
            print("Belt Rank 3")

        case 4:
            beltRankNumber = 4
            print("Belt Rank 4")
            
        case 5:
            beltRankNumber = 5
            print("Belt Rank 5")
            
        case 6:
            beltRankNumber = 6
            print("Belt Rank 6")
            
        case 7:
            beltRankNumber = 7
            print("Belt Rank 7")
            
        case 8:
            beltRankNumber = 8
            print("Belt Rank 8")
            
        case 9:
            beltRankNumber = 9
            print("Belt Rank 9")
            
        case 10:
            beltRankNumber = 10
            print("Belt Rank 10")
            
        case 11:
            beltRankNumber = 11
            print("Belt Rank 11")
            
        case 12:
            beltRankNumber = 12
            print("Belt Rank 12")
            
        case 13:
            beltRankNumber = 13
            print("Belt Rank 13")
            
        case 14:
            beltRankNumber = 14
            print("Belt Rank 14")
            
        case 15:
            beltRankNumber = 15
            print("Belt Rank 15")
            
        case 16:
            beltRankNumber = 16
            print("Belt Rank 16")
            
        case 17:
            beltRankNumber = 17
            print("Belt Rank 17")
            
        case 18:
            beltRankNumber = 18
            print("Belt Rank 18")
            
        case 19:
            beltRankNumber = 19
            print("Belt Rank 19")
            
        case 20:
            beltRankNumber = 20
            print("Belt Rank 20")
            
        case 21:
            beltRankNumber = 21
            print("Belt Rank 21")
            
        case 22:
            beltRankNumber = 22
            print("Belt Rank 22")
            
        case 23:
            beltRankNumber = 23
            print("Belt Rank 23")
            
        case 24:
            beltRankNumber = 24
            print("Belt Rank 24")
            
        case 25:
            beltRankNumber = 25
            print("Belt Rank 25")
            
        default:
            print("Couldnt find belt rank number")
        }
        
        

    }//checkForBeltRank.

    

    
    //MARK: - CORE DATA FUNCTIONS
    //Here are the Coredata functions ill be using.
    //1. addItem just creates a new Reminders item and saves it into coredata under Reminders.
    //2. save bascially just saves the changes to coredata
    //3. removeFromCoreData removes an item at a specific offset or index in a list. It will also be removed from coredata.
    func save() throws {
        try self.moc.save()
    }//:SAVE
    
    func removeFromCoreData(at offsets: IndexSet) {
        for index in offsets {
            let storedReminders = savedReminders[index]
            moc.delete(storedReminders)
            NotificationManager.instance.cancelSpecificNotification(notificationID: storedReminders.reminderID.uuidString)
            do{
            try save()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }//: REMOVE FROM CORE DATA
    
}

    //MARK: - PREVIEW
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(closeProfileView: .constant(false))
            .preferredColorScheme(.dark)
            
    }
}
