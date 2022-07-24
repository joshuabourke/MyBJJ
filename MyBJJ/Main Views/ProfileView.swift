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
    
    @EnvironmentObject var subListVM: SubListViewModel
    @Binding var closeProfileView: Bool
    @State var didTapAddReminders: Bool = false
    @State var didTapDeleteAccountButton: Bool = false
    
    //MARK: - BELT COLOURS
    @State var didChangeBeltColour: Color = .blue
    @State var didChangeBeltStripes = [Color.white, Color.black, Color.black, Color.black]
    @State var didChangeStipeBackGround: Color = .black
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
                BeltViewMenu(beltColor: didChangeBeltColour, beltStripColors: didChangeBeltStripes, stripeBackGroundColor: didChangeStipeBackGround)
                //This beltview menu in the profile view will allow users to change their belt rank. By tapping on the belt in the profile view it will present them with a menu where they can change their belt rank.
                    .contextMenu {
                        Button {
                            didChangeBeltColour = .white
                            didChangeBeltStripes = [Color.white, Color.white, Color.white, Color.white]
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
