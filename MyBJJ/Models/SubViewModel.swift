//
//  SubViewModel.swift
//  MyBJJ
//
//  Created by Josh Bourke on 28/4/22.
//

import Foundation
import SwiftUI



class SubViewModel {
    //MARK: - CORE DATA

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: SavedRolls.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \SavedRolls.subDate, ascending: false)])
    
    
    var savedSubs: FetchedResults<SavedRolls>
    
    //MARK: - PIE GRAPH
    //MARK: - WINS
    @AppStorage("chokeholdCount") var chokeholdCount = 0
    @AppStorage("lowerBodyCount") var lowerBodyCount = 0
    @AppStorage("upperBodyCount") var upperBodyCount = 0
    @AppStorage("graphMoreThanZero") var graphMoreThanZero = false
    //MARK: - LOSSES
    @AppStorage("chokeholdCountLoss") var chokeholdCountLoss = 0
    @AppStorage("lowerBodyCountLoss") var lowerBodyCountLoss = 0
    @AppStorage("upperBodyCountLoss") var upperBodyCountLoss = 0
    @AppStorage("graphMoreThanZeroLoss") var graphMoreThanZeroLoss = false
    //MARK: - PAGING STATS VIEW
    @State var currentPage = 0
    var colors = [Color.green, Color.mint.opacity(0.5), Color.green.opacity(0.3)]
    var colorsLoss = [Color.red, Color.orange.opacity(0.5), Color.yellow.opacity(0.5)]
    var names = ["Chokehold", "Upperbody", "Lowerbody"]


    

    

}
