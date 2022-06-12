//
//  Extension.swift
//  MyBJJ
//
//  Created by Josh Bourke on 20/4/22.
//

import SwiftUI
//MARK: - Custom View Property Extensions
extension View {
    //MARK: - Building a Custom Modifier for Custom Popup navigation View
    func popupNavigationView<Content: View>(horizontalPadding: CGFloat = 40, show: Binding<Bool>, @ViewBuilder content: @escaping ()->Content)-> some View {
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay{
                if show.wrappedValue {
                    //MARK: - Geometry Reader for reading Container Frame
                    GeometryReader { proxy in
                        
                        Color.primary.opacity(0.15).ignoresSafeArea()
                        
                        let size = proxy.size
                        
                        NavigationView{
                            content()
                        }//: NAVIGATION
                        .frame(width: size.width - horizontalPadding , height: size.height / 1, alignment: .center)
                        //Corner Radius
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
            }//: OVERLAY
    }
}


extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM,EEEE, yyyy")
        return dateFormatter.string(from: self)
    }
    
    func dateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d")
        return dateFormatter.string(from: self)
    }

}
