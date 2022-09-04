//
//  TestingMenu.swift
//  MyBJJ
//
//  Created by Josh Bourke on 3/7/2022.
//

import SwiftUI

struct BeltViewMenu: View {
    //MARK: - PROPERTIES
    
    //Calling the class for setting and changing all of the belt ranks. This is an atempt to save the belt ranks of the users
    @StateObject var newSubVM = AddingNewSubViewModel(myBJJUser: .none)
    
    //All of the belt  attributes
    //Belt Colour
    @State var beltColor: Color = .white
    //Array of colours to display the stripes e.g (white,white,white,black) will display 3 stripes
    @State var beltStripColors = [Color.black, Color.black, Color.black, Color.black]
    //This only had to be implemented for black belts. The area where stipes live on a black belt are traditionally red not black.
    @State var stripeBackGroundColor: Color = .black
    
    @Binding var beltRankNumber: Int
    //MARK: - BODY
    var body: some View {
        //This is the belt view.
        //It is pretty much all hard coded at this point but it works. It allows the user to tap on the belt view found in profile view. Then it will present a drop down menu that the user can then choose their belt rank from white all the way up to black belt and 4 stripes.
        Menu {
            Menu("White Belt"){
                Button("White Belt", action: whiteBelt)
                Button("White 1 Stripe", action: whiteBelt1Stripe)
                Button("White 2 Stripe", action: whiteBelt2Stripe)
                Button("White 3 Stripe", action: whiteBelt3Stripe)
                Button("White 4 Stripe", action: whiteBelt4Stripe)
            }
            Menu("Blue Belt"){
                Button("Blue Belt", action: blueBelt)
                Button("Blue 1 Stripe", action: blueBelt1Stripe)
                Button("Blue 2 Stripe", action: blueBelt2Stripe)
                Button("Blue 3 Stripe", action: blueBelt3Stripe)
                Button("Blue 4 Stripe", action: blueBelt4Stripe)
            }
            Menu("Purple Belt") {
                Button("Purple Belt", action: purpleBelt)
                Button("Purple 1 Stripe", action: purpleBelt1Stripe)
                Button("Purple 2 Stripe", action: purpleBelt2Stripe)
                Button("Purple 3 Stripe", action: purpleBelt3Stripe)
                Button("Purple 4 Stripe", action: purpleBelt4Stripe)
            }
            Menu("Brown Belt") {
                Button("Brown Belt", action: brownBelt)
                Button("Brown 1 Stripe", action: brownBelt1Stripe)
                Button("Brown 2 Stripe", action: brownBelt2Stripe)
                Button("Brown 3 Stripe", action: brownBelt3Stripe)
                Button("Brown 4 Stripe", action: brownBelt4Stripe)
            }
            Menu("Black Belt") {
                Button("Black Belt", action: blackBelt)
                Button("Black 1 Stripe", action: blackBelt1Stripe)
                Button("Black 2 Stripe", action: blackBelt2Stripe)
                Button("Black 3 Stripe", action: blackBelt3Stripe)
                Button("Black 4 Stripe", action: blackBelt4Stripe)
            }
        } label: {
            BeltView(beltColor: beltColor, beltStripes: beltStripColors, stripeBackgroundColor: stripeBackGroundColor)
                .onAppear(){
                    checkForBeltRankAndColor()
                }
                .shadow(radius: 8)
        }
    }
    //MARK: - DIFFERENT COLORED BELT FUNCTIONS
    //This function is going over the beltranknumber
    //depeneding on the case it will change the function for each of the different numbers.
    func checkForBeltRankAndColor() {

        switch beltRankNumber {
        case 1:
            beltRankNumber = 1
            whiteBelt()
            print("Belt rank 1")
            
        case 2:
            beltRankNumber = 2
            whiteBelt1Stripe()
            print("Belt Rank 2")

        case 3:
            beltRankNumber = 3
            whiteBelt2Stripe()
            print("Belt Rank 3")

        case 4:
            beltRankNumber = 4
            whiteBelt3Stripe()
            print("Belt Rank 4")
            
        case 5:
            beltRankNumber = 5
            whiteBelt4Stripe()
            print("Belt Rank 5")
            
        case 6:
            beltRankNumber = 6
            blueBelt()
            print("Belt Rank 6")
            
        case 7:
            beltRankNumber = 7
            blueBelt1Stripe()
            print("Belt Rank 7")
            
        case 8:
            beltRankNumber = 8
            blueBelt2Stripe()
            print("Belt Rank 8")
            
        case 9:
            beltRankNumber = 9
            blueBelt3Stripe()
            print("Belt Rank 9")
            
        case 10:
            beltRankNumber = 10
            blueBelt4Stripe()
            print("Belt Rank 10")
            
        case 11:
            beltRankNumber = 11
            purpleBelt()
            print("Belt Rank 11")
            
        case 12:
            beltRankNumber = 12
            purpleBelt1Stripe()
            print("Belt Rank 12")
            
        case 13:
            beltRankNumber = 13
            purpleBelt2Stripe()
            print("Belt Rank 13")
            
        case 14:
            beltRankNumber = 14
            purpleBelt3Stripe()
            print("Belt Rank 14")
            
        case 15:
            beltRankNumber = 15
            purpleBelt4Stripe()
            print("Belt Rank 15")
            
        case 16:
            beltRankNumber = 16
            brownBelt()
            print("Belt Rank 16")
            
        case 17:
            beltRankNumber = 17
            brownBelt1Stripe()
            print("Belt Rank 17")
            
        case 18:
            beltRankNumber = 18
            brownBelt2Stripe()
            print("Belt Rank 18")
            
        case 19:
            beltRankNumber = 19
            brownBelt3Stripe()
            print("Belt Rank 19")
            
        case 20:
            beltRankNumber = 20
            brownBelt4Stripe()
            print("Belt Rank 20")
            
        case 21:
            beltRankNumber = 21
            blackBelt()
            print("Belt Rank 21")
            
        case 22:
            beltRankNumber = 22
            blackBelt1Stripe()
            print("Belt Rank 22")
            
        case 23:
            beltRankNumber = 23
            blackBelt2Stripe()
            print("Belt Rank 23")
            
        case 24:
            beltRankNumber = 24
            blackBelt3Stripe()
            print("Belt Rank 24")
            
        case 25:
            beltRankNumber = 25
            blackBelt4Stripe()
            print("Belt Rank 25")
            
        default:
            whiteBelt()
            print("Couldnt find belt rank number")
        }
        
        

    }//checkForBeltRank.
    
    //This might look pretty scuffed, but all it is doing is changing the colours of the belt with each button pressed. Either adding a stripe or changing a belt colour. All of these functions do the same thing.
    //MARK: - WHITE BELT
    func whiteBelt() {
        self.beltColor = .white
        self.beltStripColors = [.black, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 1)
    }
    func whiteBelt1Stripe() {
        self.beltColor = .white
        self.beltStripColors = [.white, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 2)
    }
    func whiteBelt2Stripe() {
        self.beltColor = .white
        self.beltStripColors = [.white, .white, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 3)
    }
    func whiteBelt3Stripe() {
        self.beltColor = .white
        self.beltStripColors = [.white, .white, .white, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 4)
    }
    func whiteBelt4Stripe() {
        self.beltColor = .white
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 5)
    }
    //MARK: - BLUE BELT
    func blueBelt() {
        self.beltColor = .accentColor
        self.beltStripColors = [.black, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 6)
    }
    func blueBelt1Stripe() {
        self.beltColor = .accentColor
        self.beltStripColors = [.white, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 7)
    }
    func blueBelt2Stripe() {
        self.beltColor = .accentColor
        self.beltStripColors = [.white, .white, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 8)
    }
    func blueBelt3Stripe() {
        self.beltColor = .accentColor
        self.beltStripColors = [.white, .white, .white, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 9)
    }
    func blueBelt4Stripe() {
        self.beltColor = .accentColor
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 10)
    }
    //MARK: - PURPLE BELT
    func purpleBelt() {
        self.beltColor = .purple
        self.beltStripColors = [.black, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 11)
    }
    func purpleBelt1Stripe() {
        self.beltColor = .purple
        self.beltStripColors = [.white, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 12)
    }
    func purpleBelt2Stripe() {
        self.beltColor = .purple
        self.beltStripColors = [.white, .white, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 13)
    }
    func purpleBelt3Stripe() {
        self.beltColor = .purple
        self.beltStripColors = [.white, .white, .white, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 14)
    }
    func purpleBelt4Stripe() {
        self.beltColor = .purple
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 15)
    }
    //MARK: - BROWN BELT
    func brownBelt() {
        self.beltColor = .brown
        self.beltStripColors = [.black, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 16)
    }
    func brownBelt1Stripe() {
        self.beltColor = .brown
        self.beltStripColors = [.white, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 17)
    }
    func brownBelt2Stripe() {
        self.beltColor = .brown
        self.beltStripColors = [.white, .white, .black, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 18)
    }
    func brownBelt3Stripe() {
        self.beltColor = .brown
        self.beltStripColors = [.white, .white, .white, .black]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 19)
    }
    func brownBelt4Stripe() {
        self.beltColor = .brown
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.black
        newSubVM.setOrUpdateBeltRank(beltRank: 20)
        
    }
    //MARK: - BLACK BELT
    func blackBelt() {
        self.beltColor = .black
        self.beltStripColors = [.red, .red, .red, .red]
        self.stripeBackGroundColor = Color.red
        newSubVM.setOrUpdateBeltRank(beltRank: 21)
    }
    func blackBelt1Stripe() {
        self.beltColor = .black
        self.beltStripColors = [.white, .red, .red, .red]
        self.stripeBackGroundColor = Color.red
        newSubVM.setOrUpdateBeltRank(beltRank: 22)
    }
    func blackBelt2Stripe() {
        self.beltColor = .black
        self.beltStripColors = [.white, .white, .red, .red]
        self.stripeBackGroundColor = Color.red
        newSubVM.setOrUpdateBeltRank(beltRank: 23)
    }
    func blackBelt3Stripe() {
        self.beltColor = .black
        self.beltStripColors = [.white, .white, .white, .red]
        self.stripeBackGroundColor = Color.red
        newSubVM.setOrUpdateBeltRank(beltRank: 24)
    }
    func blackBelt4Stripe() {
        self.beltColor = .black
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.red
        newSubVM.setOrUpdateBeltRank(beltRank: 25)
    }
}
    //MARK: - PREVIEW
struct BeltViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        BeltViewMenu(newSubVM: AddingNewSubViewModel.init(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"])), beltRankNumber: .constant(1))
    }
}
