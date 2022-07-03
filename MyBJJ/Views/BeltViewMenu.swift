//
//  TestingMenu.swift
//  MyBJJ
//
//  Created by Josh Bourke on 3/7/2022.
//

import SwiftUI

struct BeltViewMenu: View {
    //MARK: - PROPERTIES
    
    //All of the belt  attributes
    //Belt Colour
    @State var beltColor: Color = .accentColor
    //Array of colours to display the stripes e.g (white,white,white,black) will display 3 stripes
    @State var beltStripColors = [Color.white, Color.black, Color.black, Color.black]
    //This only had to be implemented for black belts. The area where stipes live on a black belt are traditionally red not black.
    @State var stripeBackGroundColor: Color = .black
    
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
                .shadow(radius: 8)
        }
    }
    
    //MARK: - FUNCTIONS
    
    
    //MARK: - DIFFERENT COLORED BELT FUNCTIONS
    
    
    //This might look pretty scuffed, but all it is doing is changing the colours of the belt with each button pressed. Either adding a stripe or changing a belt colour. All of these functions do the same thing.
    //MARK: - WHITE BELT
    func whiteBelt() {
        self.beltColor = .white
        self.beltStripColors = [.black, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func whiteBelt1Stripe() {
        self.beltColor = .white
        self.beltStripColors = [.white, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func whiteBelt2Stripe() {
        self.beltColor = .white
        self.beltStripColors = [.white, .white, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func whiteBelt3Stripe() {
        self.beltColor = .white
        self.beltStripColors = [.white, .white, .white, .black]
        self.stripeBackGroundColor = Color.black
    }
    func whiteBelt4Stripe() {
        self.beltColor = .white
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.black
    }
    //MARK: - BLUE BELT
    func blueBelt() {
        self.beltColor = .accentColor
        self.beltStripColors = [.black, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func blueBelt1Stripe() {
        self.beltColor = .accentColor
        self.beltStripColors = [.white, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func blueBelt2Stripe() {
        self.beltColor = .accentColor
        self.beltStripColors = [.white, .white, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func blueBelt3Stripe() {
        self.beltColor = .accentColor
        self.beltStripColors = [.white, .white, .white, .black]
        self.stripeBackGroundColor = Color.black
    }
    func blueBelt4Stripe() {
        self.beltColor = .accentColor
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.black
    }
    //MARK: - PURPLE BELT
    func purpleBelt() {
        self.beltColor = .purple
        self.beltStripColors = [.black, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func purpleBelt1Stripe() {
        self.beltColor = .purple
        self.beltStripColors = [.white, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func purpleBelt2Stripe() {
        self.beltColor = .purple
        self.beltStripColors = [.white, .white, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func purpleBelt3Stripe() {
        self.beltColor = .purple
        self.beltStripColors = [.white, .white, .white, .black]
        self.stripeBackGroundColor = Color.black
    }
    func purpleBelt4Stripe() {
        self.beltColor = .purple
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.black
    }
    //MARK: - BROWN BELT
    func brownBelt() {
        self.beltColor = .brown
        self.beltStripColors = [.black, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func brownBelt1Stripe() {
        self.beltColor = .brown
        self.beltStripColors = [.white, .black, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func brownBelt2Stripe() {
        self.beltColor = .brown
        self.beltStripColors = [.white, .white, .black, .black]
        self.stripeBackGroundColor = Color.black
    }
    func brownBelt3Stripe() {
        self.beltColor = .brown
        self.beltStripColors = [.white, .white, .white, .black]
        self.stripeBackGroundColor = Color.black
    }
    func brownBelt4Stripe() {
        self.beltColor = .brown
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.black
    }
    //MARK: - BLACK BELT
    func blackBelt() {
        self.beltColor = .black
        self.beltStripColors = [.red, .red, .red, .red]
        self.stripeBackGroundColor = Color.red
    }
    func blackBelt1Stripe() {
        self.beltColor = .black
        self.beltStripColors = [.white, .red, .red, .red]
        self.stripeBackGroundColor = Color.red
    }
    func blackBelt2Stripe() {
        self.beltColor = .black
        self.beltStripColors = [.white, .white, .red, .red]
        self.stripeBackGroundColor = Color.red
    }
    func blackBelt3Stripe() {
        self.beltColor = .black
        self.beltStripColors = [.white, .white, .white, .red]
        self.stripeBackGroundColor = Color.red
    }
    func blackBelt4Stripe() {
        self.beltColor = .black
        self.beltStripColors = [.white, .white, .white, .white]
        self.stripeBackGroundColor = Color.red
    }
}
    //MARK: - PREVIEW
struct BeltViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        BeltViewMenu()
    }
}
