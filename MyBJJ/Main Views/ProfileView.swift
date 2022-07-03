//
//  ProfileView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/6/2022.
//

import SwiftUI

struct LocalReminders {
    var id = UUID()
    var hours: Int
    var mintues: Int
    var dayOfTheWeek: Int
}

struct ProfileView: View {
    //MARK: - PROPERTIES
    
    @State var hours: Int = 0
    @State var mintues: Int = 0
    @State var dayOfTheWeek: Int = 0
    
    @EnvironmentObject var subListVM: SubListViewModel
    @Binding var closeProfileView: Bool
    @State var didTapAddReminders: Bool = false
    
    //MARK: - TESTING
    @State var didChangeBeltColour: Color = .blue
    @State var didChangeBeltStripes = [Color.white, Color.black, Color.black, Color.black]
    @State var didChangeStipeBackGround: Color = .black
    //MARK: - BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack{
                    Text("Rank")
                        .font(.system(size: 22))
                        .bold()
                        .padding()
                    //MARK: - BELT RANK VIEW
                    //This view is just to display the users belt rank. I havent started collecting data based on the belt rank but that is a possibility in the future.
                BeltViewMenu(beltColor: didChangeBeltColour, beltStripColors: didChangeBeltStripes, stripeBackGroundColor: didChangeStipeBackGround)
                //Context menu is tap and hold to show a menu. I am looking into just turning the belt view into a menu so then the user can select what belt rank they are with a tap, rather than having to hold down.
                        .contextMenu {
                            Button {
                                didChangeBeltColour = .white
                                didChangeBeltStripes = [Color.white, Color.white, Color.white, Color.white]
                                print("Change Belt Settings")
                            } label: {
                                Label("Change belt", systemImage: "person")
                            }
                        }
                    Spacer()
                HStack {
                    Text("REMINDERS")
                            .font(.system(size:22))
                        .bold()
                        .padding()
                    
                }//: HSTACK
                    //MARK: - LIST OF REMINDERS
                    //Thinking of using this list to display to the user what reminders they have active at the moment.
                    Group{
                       
                        List{
                            ForEach(0..<5) { text in
                                Text("Testing Something")
                            }
                        }//: LIST
                        .frame(height: 300)
                        .cornerRadius(30)
                        .listStyle(.inset)
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
                        .padding()
                        
                    }//: GROUP

                    Spacer()
                //MARK: - REMOVE REMINDERS BUTTON
                //This button below is for removing all of the added reminders that the user has set. It currently only removes all of them not just a specific one.
                Button {
                    print("Remove all added notifications *Pressed*")
                    NotificationManager.instance.cancelAllNotifications()
                } label: {
                    Image(systemName: "bell.slash")
                        .font(.body.bold())
                    Text("Delete reminders")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .buttonStyle(RedRectangleButton())
                .frame(width: 220, height: 45)
                .padding()
                
                //MARK: - LOG OUT BUTTON
                //The button below handles the users log out and stops displaying all of the users data.
                    Button {
                        print("Log out")
                        subListVM.handleSignOut()
                        withAnimation {
                            closeProfileView.toggle()
                        }
                    } label: {
                        Text("Log Out")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(RedRectangleButton())
                    .frame(width: 150, height: 45)
                    .padding()
                }//: VSTACK
                .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $didTapAddReminders) {
                NotificationSettingsView(hours: $hours, mintues: $mintues, dayOfTheWeek: $dayOfTheWeek)
            }
        }//: Scroll
        
    }
}
    //MARK: - PREVIEW
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(closeProfileView: .constant(false))
    }
}
