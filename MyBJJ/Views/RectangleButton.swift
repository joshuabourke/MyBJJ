//
//  RectangleButton.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/4/22.
//

import SwiftUI

struct RectangleButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button(action: {}) {
            HStack{
                Spacer()
                configuration.label.foregroundColor(.white)
                Spacer()
            }
        }
        //Make all taps go to the original button
        .allowsHitTesting(false)
        .padding()
        .background(Color.accentColor.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
}

struct RedRectangleButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button(action: {}) {
            HStack{
                Spacer()
                configuration.label.foregroundColor(.white)
                Spacer()
            }
        }
        //Make all taps go to the original button
        .allowsHitTesting(false)
        .padding()
        .background(Color.red.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
}
