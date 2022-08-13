//
//  NewSkillView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/4/22.
//

import SwiftUI
import Firebase


struct NewSkillView: View {
    //MARK: - PROPERTIES
    var subVM = SubViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var newSubmission: String = ""


    @StateObject var newSubVM: AddingNewSubViewModel
    
    //MARK: - UPDATING DATA
    @State var fileName: String = ""
    @State var fileItem: Int = 0
    
    //MARK: - WIN/LOSS PICKER
    var pickerWinOrLoss = ["Win", "Loss"]
    //MARK: - SUB PICKER
    var pickerSubmissions = ["Chokehold", "Upper Body", "Lower Body"]
    //MARK: - NOGI OR GI PICKER
    var pickerNoGiOrGi = ["NoGi", "Gi"]
    @State var selectedSub: String = ""
    @State var pickerWinOrLossIndex: String = "Win"
    @State var pickerSelectionIndex: String = "Chokehold"
    @State var pickerGiorNoGiIndex: String = "NoGi"
    
    @Binding var isNewSubmissionOpen: Bool
    @State var completedSubmissions = subsData
    
    //This is for the user to select either gi or no gi This will then be passed into the sublistView. Then it will see if either gi or nogi was selected. Then it will add a new list item that will show either gi or no gi.
    @Binding var noGiOrGiSelection: Bool
    
    //MARK: - ALERT
    @State var showAlert = false
    
    
    //MARK: - NEW SUBMISSION LISTS(ARRAYS)
    //They where on their own before as kind of a global var. Changing them to be in the actual fine of new sub.
    //Reason being is because I am trying to fix a visual problem where when changing to a different sub type it flickers.
    
    //Add more subs here to expand on the new sub lists.
    var chokeHolds = ["Rear Naked", "Arm Triangle", "Triangle" ,"Guillotine", "Ezekiel", "Baseball bat", "D'arce", "North South", "Crucifix" ,"Anaconda", "Gogoplata", "Von Fluke", "Bulldog Choke", "Inverted Triangle", "Back Triangle"].sorted()

    var upperBody = ["Arm Bar", "Wrist Lock", "Americana", "Kimura", "Arm Crush"].sorted()

    var lowerBody = ["Straight Leg Lock", "Toe Hold", "Knee Bar" ,"Calf Slicer", "Inside Heel Hook", "Outside Heel Hook"].sorted()
    //MARK: - BODY
    var body: some View {
        VStack{
            HStack(spacing: 10){
                Button {
                    presentationMode.wrappedValue.dismiss()
                    isNewSubmissionOpen = false
                    print("Close Window")
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.bold())
                        .foregroundColor(.accentColor)
                       
                }

                Spacer()
                Text(getCurrentTime())
                    .font(.headline)
                    .padding()
                    
            }//: HSTACK
            .padding(10)
            HStack(spacing: 10){
                Text("New Submission")
                    .font(.largeTitle.bold())
                    .padding(10)
                Spacer()
            }//: HSTACK
            
            //MARK: - WIN/LOSS PICKER
            //This is for the user to pick whether or not they wont or they lost.
            Picker("Win or Loss", selection: $pickerWinOrLossIndex) {
                ForEach(pickerWinOrLoss, id:\.self) {
                    Text($0)
                }
            }//: PICKER WIN/LOSS
            
            .pickerStyle(.segmented)
            .padding()
            
            //MARK: - GI OR NO-GI PICKER
            //This will allow the user to see if the submission was with Gi or nogi
            Picker("NoGi or Gi", selection: $pickerGiorNoGiIndex) {
                ForEach(pickerNoGiOrGi, id:\.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: pickerGiorNoGiIndex) { newValue in
                selectedSub = ""
            }
            
            //MARK: - SUB TYPE PICKER
            //This picker is so the user can pick what area on the body the sub occured
            Picker("New Submission", selection: $pickerSelectionIndex){
                ForEach(pickerSubmissions, id:\.self) {
                    Text($0)
                }
            }//: PICKER
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: pickerSelectionIndex) { newValue in
                selectedSub = ""
            }

            List{
                if pickerSelectionIndex == "Chokehold" {
                    ForEach(chokeHolds, id: \.self) { chokehold in
                        CustomRowSelectionTest(title: chokehold, selectedItem: $selectedSub) { title in
                            print(title)
                        }
                        .padding()
                    }
                } else if pickerSelectionIndex == "Upper Body"{
                    ForEach(upperBody, id:\.self) { upperbody in
                        CustomRowSelectionTest(title: upperbody, selectedItem: $selectedSub){ title in
                            print(title)
                        }
                        .padding()
                    }
                } else if pickerSelectionIndex == "Lower Body" {
                    ForEach(lowerBody, id:\.self) { lowerbody in
                        CustomRowSelectionTest(title: lowerbody, selectedItem: $selectedSub) { title in
                            print(title)
                        }
                        .padding()
                    }
                }
                
            }
            .cornerRadius(30)
            Spacer()
            //MARK: - ADD BUTTON
            Button (action: {
                print("ADD Button")
                
                if selectedSub == "" {
                    showAlert = true
                } else {
                    //1.
                    newSubVM.addDataSubmissions(winOrLoss: pickerWinOrLossIndex, subType: pickerSelectionIndex, sub: selectedSub, giOrNoGi: pickerGiorNoGiIndex)
                    //2.
                    increaseSubs(subArea: pickerSelectionIndex, WinOrLoss: pickerWinOrLossIndex, GiOrNoGi: pickerGiorNoGiIndex)
                    //3.
                    newSubVM.getDataSubmissions()
                    //4.
                    newSubVM.fetchAllStats()
                    //5.
                    presentationMode.wrappedValue.dismiss()

                }
            }, label: {
                Text("Add")
                    .fontWeight(.bold)
            }).buttonStyle(RectangleButton())
                .frame(width: 100, height: 45)
                .padding()
                .alert(isPresented: $showAlert) { () -> Alert in
                    Alert(title: Text("Select A Sub"))
                }

        }//: VSTACK

    }
    
    //MARK: - FUNCTION
    
    func increaseSubs(subArea: String, WinOrLoss: String, GiOrNoGi: String){
        
        //MARK: - SWITCH
        //Here I am looking to make a switch statement over these values instead of having to keep making more if else.
         let result = (subArea,WinOrLoss,GiOrNoGi)
        
        switch result {
        //MARK: - SWITCH LOWER BODY CASE
        case ("Lower Body", "Win", "Gi"):
            print("increasesubs switch Result: Lower Body, Win, Gi")
            newSubVM.addLowerGiWin(lowerWin: 1)
            //I will be adding in more graphs for these
            
        case ("Lower Body", "Loss", "Gi"):
            print("increasesubs switch Result: Lower Body, Loss, Gi")
            newSubVM.addLowerGiLoss(lowerLoss: 1)
            //I will be adding in more graphs for these
            
        case ("Lower Body", "Win", "NoGi"):
            print("increasesubs switch Result: Lower Body, Win, NoGi")
            newSubVM.addLowerWin(lowerWin: 1)
            subVM.graphMoreThanZero = true
            
        case ("Lower Body", "Loss", "NoGi"):
            print("increasesubs switch Result: Lower Body, Loss, NoGi")
            newSubVM.addLowerLoss(lowerLoss: 1)
            subVM.graphMoreThanZeroLoss = true
        //End of Lower Body cases
            
        //MARK: - SWITCH UPPER BODY CASE
        case ("Upper Body", "Win", "Gi"):
            print("increasesubs switch Result: Upper Body, Win, Gi")
            newSubVM.addUpperGiWin(upperWin: 1)
            //I will be adding in more graphs for these

        case ("Upper Body", "Loss", "Gi"):
            print("increasesubs switch Result: Upper Body, Loss, Gi")
            newSubVM.addUpperGiLoss(upperLoss: 1)
            //I will be adding in more graphs for these
            
        case ("Upper Body", "Win", "NoGi"):
            print("increasesubs switch Result: Upper Body, Win, NoGi")
            newSubVM.addUpperWin(upperWin: 1)
            subVM.graphMoreThanZero = true
        
        case ("Upper Body", "Loss", "NoGi"):
            print("increasesubs switch Result: Upper Body, Loss, NoGi")
            newSubVM.addUpperLoss(upperLoss: 1)
            subVM.graphMoreThanZeroLoss = true
        //End of Upper Body cases
            
        //MARK: - SWITCH CHOKE HOLD CASE
        case ("Chokehold", "Win", "Gi"):
            print("increasesubs switch Result: Chokehold, Win, Gi")
            newSubVM.addChokeGiWin(chokeWin: 1)
            //I will be adding in more graphs for these
            
        case ("Chokehold", "Loss", "Gi"):
            print("increasesubs switch Result: Chokehold, Loss, Gi")
            newSubVM.addChokeGiLoss(chokeLoss: 1)
            //I will be adding in more graphs for these
            
        case ("Chokehold", "Win", "NoGi"):
            print("increasesubs switch Result: Chokehold, Win, NoGi")
            newSubVM.addChokeWin(chokeWin: 1)
            subVM.graphMoreThanZero = true
        
        case ("Chokehold", "Loss", "NoGi"):
            print("increasesubs switch Result: Chokehold, Loss, NoGi")
            newSubVM.addChokeLoss(chokeLoss: 1)
            subVM.graphMoreThanZeroLoss = true
        //End of Chokehold cases
        default:
            print("UNKNOWN was unable to find a case to add")
        }
         
        //This is the old way of adding submissions to the list. Above is the new way I am trying out!
        //MARK: - WINS
//        if pickerSelectionIndex == "Lower Body" && pickerWinOrLossIndex == "Win"{
//            newSubVM.addLowerWin(lowerWin: 1)
//            subVM.graphMoreThanZero = true
//        }
//        else if pickerSelectionIndex == "Upper Body" && pickerWinOrLossIndex == "Win"{
//            newSubVM.addUpperWin(upperWin: 1)
//            subVM.graphMoreThanZero = true
//        }
//        else if pickerSelectionIndex == "Chokehold" && pickerWinOrLossIndex == "Win" {
//            newSubVM.addChokeWin(chokeWin: 1)
//            subVM.graphMoreThanZero = true
//        }
//
//        //MARK: - LOSSES
//        if pickerSelectionIndex == "Lower Body" && pickerWinOrLossIndex == "Loss"{
//            newSubVM.addLowerLoss(lowerLoss: 1)
//            subVM.graphMoreThanZeroLoss = true
//        }
//        else if pickerSelectionIndex == "Upper Body" && pickerWinOrLossIndex == "Loss"{
//            newSubVM.addUpperLoss(upperLoss: 1)
//            subVM.graphMoreThanZeroLoss = true
//        }
//        else if pickerSelectionIndex == "Chokehold" && pickerWinOrLossIndex == "Loss" {
//            newSubVM.addChokeLoss(chokeLoss: 1)
//            subVM.graphMoreThanZeroLoss = true
//        }
        
        print("WINS -> Picker Selection Index:\(pickerSelectionIndex), WinLoss Picker Index: \(pickerWinOrLossIndex),UpperBodyCount:\(subVM.upperBodyCount),LowerBodyCount:\(subVM.lowerBodyCount),ChokeholdCount:\(subVM.chokeholdCount)")
        
        print("LOSS -> Picker Selection Index:\(pickerSelectionIndex), WinLoss Picker Index: \(pickerWinOrLossIndex),UpperBodyCount:\(subVM.upperBodyCountLoss),LowerBodyCount:\(subVM.lowerBodyCountLoss),ChokeholdCount:\(subVM.chokeholdCountLoss)")

    }

}

struct FirebaseConstants {
    //These are constants for the firebase to id what is what, this is done via strings. It is easier for me to make them constants so there isnt any confusion to be had while coding.
    //MARK: - TO SAVE INFO FOR THE LIST ITEMS
    static let userId = "userId"
    static let winOrLoss = "WinOrLoss"
    static let subType = "SubType"
    static let giOrNoGi = "giOrNoGi"
    static let sub = "Sub"
    
    //MARK: - TO SAVE STATS TO USERS
    
    //MARK: - Saved Win Data
    static let upperBodyWins = "upperBodyWins"
    static let chokeholdWins = "chokeholdWins"
    static let lowerBodyWins = "lowerBodyWins"
    
    //MARK: - Saved Loss Data
    static let upperBodyLoss = "upperBodyLoss"
    static let chokeholdLoss = "chokeholdLoss"
    static let lowerBodyLoss = "lowerBodyLoss"
    
    //MARK: - COLLECTION NAMES
    static let submissionCollection = "submissions"
    static let userSubmissionsCollection = "userSubmissions"
    static let userSubStats = "userSubStats"
    
    //MARK: - NO GI CONSTANTS
    static let upperWins = "upperWins"
    static let chokeWins = "chokeWins"
    static let lowerWins = "lowerWins"
    
    static let upperLoss = "upperLoss"
    static let chokeLoss = "chokeLoss"
    static let lowerLoss = "lowerLoss"
    
    //MARK: - GI CONSTANTS
    static let upperGiWins = "upperGiWins"
    static let chokeGiWins = "chokeGiWins"
    static let lowerGiWins = "lowerGiWins"
    
    static let upperGiLoss = "upperGiLoss"
    static let chokeGiLoss = "chokeGiLoss"
    static let lowerGiLoss = "lowerGiLoss"
    
    //MARK: - Saved Win Gi Data
    static let upperBodyGiWins = "upperBodyGiWins"
    static let chokeholdGiWins = "chokeholdGiWins"
    static let lowerBodyGiWins = "lowerBodyGiWins"
    
    //MARK: - Saved Loss Gi Data
    static let upperBodyGiLoss = "upperBodyGiLoss"
    static let chokeholdGiLoss = "chokeholdGiLoss"
    static let lowerBodyGiLoss = "lowerBodyGiLoss"
    
}

struct Submissions: Identifiable {
    var id: String
    var upperLowerChoke: String
    var sub: String
    var giOrNoGi: String
    var date: Timestamp
    var winOrLoss: String
}

struct UpperWinsStruct: Identifiable {
    var id: String
    var upperWins: Int
    var giOrNoGi: String
}

struct ChokeWinsStruct: Identifiable {
    var id: String
    var chokeWins: Int
    var giOrNoGi: String
}

struct LowerWinsStruct: Identifiable {
    var id: String
    var lowerWins: Int
    var giOrNoGi: String
}

struct UpperLossStruct: Identifiable {
    var id: String
    var upperLoss: Int
    var giOrNoGi: String
}

struct ChokeLossStruct: Identifiable {
    var id: String
    var chokeLoss: Int
    var giOrNoGi: String
}

struct LowerLossStruct: Identifiable {
    var id: String
    var lowerLoss: Int
    var giOrNoGi: String
}
struct UpperWinsGiStruct: Identifiable {
    var id: String
    var upperWins: Int
    var giOrNoGi: String
}

struct ChokeWinsGiStruct: Identifiable {
    var id: String
    var chokeWins: Int
    var giOrNoGi: String
}

struct LowerWinsGiStruct: Identifiable {
    var id: String
    var lowerWins: Int
    var giOrNoGi: String
}

struct UpperLossGiStruct: Identifiable {
    var id: String
    var upperLoss: Int
    var giOrNoGi: String
}

struct ChokeLossGiStruct: Identifiable {
    var id: String
    var chokeLoss: Int
    var giOrNoGi: String
}

struct LowerLossGiStruct: Identifiable {
    var id: String
    var lowerLoss: Int
    var giOrNoGi: String
}


class AddingNewSubViewModel: ObservableObject {
    
    @Published var errorMessage: String = ""
    
//    @Published var addedSubmissions = [FirebaseSavedSubs]()
//    @Published var firebaseSubStats = [FirebaseSavedSubs]()

    @Published var submissions = [Submissions]()
    @Published var searchResults = [Submissions]()
    
    //MARK: - NOGI SUBMISSIONS
    @Published var upperBodyWinsStruct = [UpperWinsStruct]()
    @Published var chokeHoldWinsStruct = [ChokeWinsStruct]()
    @Published var lowerBodyWinsStruct = [LowerWinsStruct]()
    
    @Published var upperBodyLossStruct = [UpperLossStruct]()
    @Published var chokeHoldLossStruct = [ChokeLossStruct]()
    @Published var lowerBodyLossStruct = [LowerLossStruct]()
    
    
    //MARK: - GI SUBMISSIONS
    @Published var upperBodyWinsGiStruct = [UpperWinsGiStruct]()
    @Published var chokeHoldWinsGiStruct = [ChokeWinsGiStruct]()
    @Published var lowerBodyWinsGiStruct = [LowerWinsGiStruct]()
    
    @Published var upperBodyLossGiStruct = [UpperLossGiStruct]()
    @Published var chokeHoldLossGiStruct = [ChokeLossGiStruct]()
    @Published var lowerBodyLossGiStruct = [LowerLossGiStruct]()
    
    let myBJJUser: MyBJJUser?
    
    init(myBJJUser: MyBJJUser?) {
        self.myBJJUser = myBJJUser
//        fetchAddedSubs()
//        fetchSubStats()
        getDataSubmissions()
        fetchAllStats()
    }

    func fetchAllStats() {
        //MARK: - GET NOGI STATS
        getUpperWinStats()
        getChokeWinStats()
        getLowerWinStats()
        
        getUpperLossStats()
        getChokeLossStats()
        getLowerLossStats()
        
        //MARK: - GET GI STATS
        getChokeWinGiStats()
        getLowerWinGiStats()
        getUpperWinGiStats()
        
        getChokeLossGiStats()
        getLowerLossGiStats()
        getUpperLossGiStats()
    }
    

    //---------------------------------------------------------------------------------------------------
    //MARK: - GET SUB STATS (NOGI)
    //---------------------------------------------------------------------------------------------------

    func getUpperWinStats() {
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperWins).getDocuments { queryUpperWin, error in
            if error == nil {
                //No Errors
                
                if let queryUpperWin = queryUpperWin {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.upperBodyWinsStruct = queryUpperWin.documents.map({ queryDocumentSnapshot in
                            return UpperWinsStruct(id: queryDocumentSnapshot.documentID, upperWins: queryDocumentSnapshot[FirebaseConstants.upperWins] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetUpperWinStats
    
    func getChokeWinStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeWins).getDocuments { queryChokeWin, error in
            if error == nil {
                //No Errors
                
                if let queryChokeWin = queryChokeWin {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.chokeHoldWinsStruct = queryChokeWin.documents.map({ queryDocumentSnapshot in
                            return ChokeWinsStruct(id: queryDocumentSnapshot.documentID, chokeWins: queryDocumentSnapshot[FirebaseConstants.chokeWins] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetChokeWinStats
    
    func getLowerWinStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerWins).getDocuments { queryLowerWin, error in
            if error == nil {
                //No Errors
                
                if let queryLowerWin = queryLowerWin {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.lowerBodyWinsStruct = queryLowerWin.documents.map({ queryDocumentSnapshot in
                            return LowerWinsStruct(id: queryDocumentSnapshot.documentID, lowerWins: queryDocumentSnapshot[FirebaseConstants.lowerWins] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetLowerWinStats
    
    func getUpperLossStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperLoss).getDocuments { queryUpperLoss, error in
            if error == nil {
                //No Errors
                
                if let queryUpperLoss = queryUpperLoss {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.upperBodyLossStruct = queryUpperLoss.documents.map({ queryDocumentSnapshot in
                            return UpperLossStruct(id: queryDocumentSnapshot.documentID, upperLoss: queryDocumentSnapshot[FirebaseConstants.upperLoss] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
        
    }//:GetUpperLossStats
    
    func getChokeLossStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeLoss).getDocuments { queryChokeLoss, error in
            if error == nil {
                //No Errors
                
                if let queryChokeLoss = queryChokeLoss {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.chokeHoldLossStruct = queryChokeLoss.documents.map({ queryDocumentSnapshot in
                            return ChokeLossStruct(id: queryDocumentSnapshot.documentID, chokeLoss: queryDocumentSnapshot[FirebaseConstants.chokeLoss] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetChokeLossStats
    
    func getLowerLossStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerLoss).getDocuments { queryLowerLoss, error in
            if error == nil {
                //No Errors
                
                if let queryLowerLoss = queryLowerLoss {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.lowerBodyLossStruct = queryLowerLoss.documents.map({ queryDocumentSnapshot in
                            return LowerLossStruct(id: queryDocumentSnapshot.documentID, lowerLoss: queryDocumentSnapshot[FirebaseConstants.lowerLoss] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetLowerLossStats
    //---------------------------------------------------------------------------------------------------
    //MARK: - GET SUB STATS (GI)
    //---------------------------------------------------------------------------------------------------
    func getUpperWinGiStats() {
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperGiWins).getDocuments { queryUpperWin, error in
            if error == nil {
                //No Errors
                
                if let queryUpperWin = queryUpperWin {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.upperBodyWinsGiStruct = queryUpperWin.documents.map({ queryDocumentSnapshot in
                            return UpperWinsGiStruct(id: queryDocumentSnapshot.documentID, upperWins: queryDocumentSnapshot[FirebaseConstants.upperGiWins] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetUpperWinGiStats
    
    func getChokeWinGiStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeGiWins).getDocuments { queryChokeWin, error in
            if error == nil {
                //No Errors
                
                if let queryChokeWin = queryChokeWin {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.chokeHoldWinsGiStruct = queryChokeWin.documents.map({ queryDocumentSnapshot in
                            return ChokeWinsGiStruct(id: queryDocumentSnapshot.documentID, chokeWins: queryDocumentSnapshot[FirebaseConstants.chokeGiWins] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetChokeWinGiStats
    
    func getLowerWinGiStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerGiWins).getDocuments { queryLowerWin, error in
            if error == nil {
                //No Errors
                
                if let queryLowerWin = queryLowerWin {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.lowerBodyWinsGiStruct = queryLowerWin.documents.map({ queryDocumentSnapshot in
                            return LowerWinsGiStruct(id: queryDocumentSnapshot.documentID, lowerWins: queryDocumentSnapshot[FirebaseConstants.lowerGiWins] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetLowerWinGiStats
    
    func getUpperLossGiStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperGiLoss).getDocuments { queryUpperLoss, error in
            if error == nil {
                //No Errors
                
                if let queryUpperLoss = queryUpperLoss {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.upperBodyLossGiStruct = queryUpperLoss.documents.map({ queryDocumentSnapshot in
                            return UpperLossGiStruct(id: queryDocumentSnapshot.documentID, upperLoss: queryDocumentSnapshot[FirebaseConstants.upperGiLoss] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
        
    }//:GetUpperLossGiStats
    
    func getChokeLossGiStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeGiLoss).getDocuments { queryChokeLoss, error in
            if error == nil {
                //No Errors
                
                if let queryChokeLoss = queryChokeLoss {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.chokeHoldLossGiStruct = queryChokeLoss.documents.map({ queryDocumentSnapshot in
                            return ChokeLossGiStruct(id: queryDocumentSnapshot.documentID, chokeLoss: queryDocumentSnapshot[FirebaseConstants.chokeGiLoss] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetChokeLossGiStats
    
    func getLowerLossGiStats(){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerGiLoss).getDocuments { queryLowerLoss, error in
            if error == nil {
                //No Errors
                
                if let queryLowerLoss = queryLowerLoss {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.lowerBodyLossGiStruct = queryLowerLoss.documents.map({ queryDocumentSnapshot in
                            return LowerLossGiStruct(id: queryDocumentSnapshot.documentID, lowerLoss: queryDocumentSnapshot[FirebaseConstants.lowerGiLoss] as? Int ?? 0, giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "N/A")
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetLowerLossGiStats
    
    //---------------------------------------------------------------------------------------------------
    //MARK: - GET LIST OF SUBS
    //---------------------------------------------------------------------------------------------------
    func getDataSubmissions() {
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let db = Firestore.firestore()

        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubmissionsCollection).order(by: "timestamp", descending: true).getDocuments { querySnapshot, error in
            if error == nil{
                //No Errors
                if let querySnapshot = querySnapshot {
                    //Running on the main thread for updating the view
                    DispatchQueue.main.async {
                        self.submissions = querySnapshot.documents.map({ queryDocumentSnapshot in
                            //Create a submission item for each document to return
                            return Submissions(id: queryDocumentSnapshot.documentID, upperLowerChoke: queryDocumentSnapshot[FirebaseConstants.subType] as? String ?? "", sub: queryDocumentSnapshot[FirebaseConstants.sub] as? String ?? "", giOrNoGi: queryDocumentSnapshot[FirebaseConstants.giOrNoGi] as? String ?? "", date: queryDocumentSnapshot["timestamp"] as? Timestamp ?? Timestamp(), winOrLoss: queryDocumentSnapshot[FirebaseConstants.winOrLoss] as? String ?? "")
                        })
                    }
                }
            } else{
                //Handle Error
            }
        }
        
    }//GetDataSubmission
    
    //---------------------------------------------------------------------------------------------------
    //MARK: - ADD SUB STATS
    //MARK: - ADD NOGI SUBMISSIONS
    //---------------------------------------------------------------------------------------------------
    func addUpperWin(upperWin: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperWins).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.upperBodyWins: upperWin,"timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getUpperWinStats()
            } else {
                
            }
        }
    }//: Add Upper Win
    
    func addUpperLoss(upperLoss: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperLoss).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.upperBodyLoss: upperLoss,"timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getUpperLossStats()
            } else {
                
            }
        }
    }//: Add Upper Loss
    
    func addChokeWin(chokeWin: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeWins).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.chokeholdWins: chokeWin,"timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getChokeWinStats()
            } else {
                
            }
        }
    }//: Add Choke Win
    
    func addChokeLoss(chokeLoss: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeLoss).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.chokeholdLoss: chokeLoss,"timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getChokeLossStats()
            } else {
                
            }
        }
    }//: Add Choke Loss
    
    func addLowerWin(lowerWin: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerWins).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.lowerBodyWins: lowerWin, "timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getLowerWinStats()
            } else {
                
            }
        }
    }//: Add Lower Win
    
    func addLowerLoss(lowerLoss: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerLoss).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.lowerBodyLoss: lowerLoss, "timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getLowerLossStats()
            } else {
                
            }
        }
    }//: Add Lower Win
    //---------------------------------------------------------------------------------------------------
    //MARK: - ADD GI SUBMISSIONS
    //---------------------------------------------------------------------------------------------------
    func addUpperGiWin(upperWin: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperGiWins).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.upperBodyGiWins: upperWin,"timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getUpperWinStats()
            } else {
                
            }
        }
    }//: Add UpperGi Win
    
    func addUpperGiLoss(upperLoss: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperGiLoss).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.upperBodyGiLoss: upperLoss,"timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getUpperLossStats()
            } else {
                
            }
        }
    }//: Add UpperGi Loss
    
    func addChokeGiWin(chokeWin: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeGiWins).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.chokeholdGiWins: chokeWin,"timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getChokeWinStats()
            } else {
                
            }
        }
    }//: Add ChokeGi Win

    func addChokeGiLoss(chokeLoss: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeGiLoss).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.chokeholdGiLoss: chokeLoss,"timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getChokeLossStats()
            } else {
                
            }
        }
    }//: Add ChokeGi Loss
    
    func addLowerGiWin(lowerWin: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerGiWins).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.lowerBodyGiWins: lowerWin, "timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getLowerWinStats()
            } else {
                
            }
        }
    }//: Add LowerGi Win
    
    func addLowerGiLoss(lowerLoss: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerGiLoss).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.lowerBodyGiLoss: lowerLoss, "timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getLowerLossStats()
            } else {
                
            }
        }
    }//: Add LowerGi Win
    //---------------------------------------------------------------------------------------------------
    //MARK: - ADD SUBMISSION TO LIST
    //---------------------------------------------------------------------------------------------------
    func addDataSubmissions(winOrLoss: String, subType: String, sub: String, giOrNoGi: String){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubmissionsCollection).addDocument(data: [FirebaseConstants.userId : userId,FirebaseConstants.subType : subType, FirebaseConstants.winOrLoss : winOrLoss, FirebaseConstants.sub : sub,FirebaseConstants.giOrNoGi : giOrNoGi, "timestamp": Timestamp()]) { error in
            //Check for Errors
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getDataSubmissions()
            } else {
                //Handle the errors
            }
        }
    }//AddDataSubmission
    //---------------------------------------------------------------------------------------------------
    
    
    
    //MARK: - DELETE (NOGI) SUBMISSION FROM LIST
    //---------------------------------------------------------------------------------------------------
    func deleteDataSubmissions(submissionToDelete: Submissions) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubmissionsCollection).document(submissionToDelete.id).delete { error in
            //Check for errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the submission that was just deleted
                    self.submissions.removeAll { submission in
                        //Check for the submission to remove
                        return submission.id == submissionToDelete.id
                    }
                }
            } else {
                //Handle any errors here
            }
        }
    }//DeleteDataSubmissions
    
    func deleteUpperWinStats(upperWinStatsToDelete: UpperWinsStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperWins).document(upperWinStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.upperBodyWinsStruct.removeAll { upperWinStat in
                        //Check for the stat to remove
                        return upperWinStat.id == upperWinStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteUpperWin
    
    func deleteChokeWinStats(chokeWinStatsToDelete: ChokeWinsStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeWins).document(chokeWinStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.chokeHoldWinsStruct.removeAll { chokeWinStat in
                        //Check for the stat to remove
                        return chokeWinStat.id == chokeWinStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteChokeWin
    
    func deleteLowerWinStats(lowerWinStatsToDelete: LowerWinsStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerWins).document(lowerWinStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.lowerBodyWinsStruct.removeAll { lowerWinStat in
                        //Check for the stat to remove
                        return lowerWinStat.id == lowerWinStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteLowerWin
    
    func deleteUpperLossStats(upperLossStatsToDelete: UpperLossStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperLoss).document(upperLossStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.upperBodyLossStruct.removeAll { upperLossStat in
                        //Check for the stat to remove
                        return upperLossStat.id == upperLossStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteUpperLoss
    
    func deleteChokeLossStats(chokeLossStatsToDelete: ChokeLossStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeLoss).document(chokeLossStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.chokeHoldLossStruct.removeAll { chokeLossStat in
                        //Check for the stat to remove
                        return chokeLossStat.id == chokeLossStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteChokeLoss
    
    func deleteLowerLossStats(lowerLossStatsToDelete: LowerLossStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerLoss).document(lowerLossStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.lowerBodyLossStruct.removeAll { lowerLossStat in
                        //Check for the stat to remove
                        return lowerLossStat.id == lowerLossStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteLowerLoss
    //---------------------------------------------------------------------------------------------------
    //MARK: - DELETE (GI) SUBMISSION FROM LIST
    //---------------------------------------------------------------------------------------------------
    func deleteUpperWinGiStats(upperWinStatsToDelete: UpperWinsGiStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperGiWins).document(upperWinStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.upperBodyWinsGiStruct.removeAll { upperWinStat in
                        //Check for the stat to remove
                        return upperWinStat.id == upperWinStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteUpperGiWinGi
    
    func deleteChokeWinGiStats(chokeWinStatsToDelete: ChokeWinsGiStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeGiWins).document(chokeWinStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.chokeHoldWinsGiStruct.removeAll { chokeWinStat in
                        //Check for the stat to remove
                        return chokeWinStat.id == chokeWinStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteChokeWinGi
    
    func deleteLowerWinGiStats(lowerWinStatsToDelete: LowerWinsGiStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerGiWins).document(lowerWinStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.lowerBodyWinsGiStruct.removeAll { lowerWinStat in
                        //Check for the stat to remove
                        return lowerWinStat.id == lowerWinStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteLowerWinGi
    
    func deleteUpperLossGiStats(upperLossStatsToDelete: UpperLossGiStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperGiLoss).document(upperLossStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.upperBodyLossGiStruct.removeAll { upperLossStat in
                        //Check for the stat to remove
                        return upperLossStat.id == upperLossStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteUpperLossGi
    
    func deleteChokeLossGiStats(chokeLossStatsToDelete: ChokeLossGiStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeGiLoss).document(chokeLossStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.chokeHoldLossGiStruct.removeAll { chokeLossStat in
                        //Check for the stat to remove
                        return chokeLossStat.id == chokeLossStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteChokeLossGi
    
    func deleteLowerLossGiStats(lowerLossStatsToDelete: LowerLossGiStruct) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.lowerGiLoss).document(lowerLossStatsToDelete.id).delete { error in
            //Check for Errors
            if error == nil {
                //No Errors
                //Update the ui from the main thread
                DispatchQueue.main.async {
                    //Remove the stat that was just deleted
                    self.lowerBodyLossGiStruct.removeAll { lowerLossStat in
                        //Check for the stat to remove
                        return lowerLossStat.id == lowerLossStatsToDelete.id
                    }
                }
            }
        }
    }//DeleteLowerLossGi
    //---------------------------------------------------------------------------------------------------
    //MARK: - UPDATE SUB DATA
    //---------------------------------------------------------------------------------------------------
    func updateDataSubmisisons(submissionToUpdate: Submissions, subType: String, winOrLoss: String, sub: String) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get a reference to database
        let db = Firestore.firestore()
        
        //Set the data to update
        
        //This will remove all of the data and replace it with what ever is in the dictionary(Overriding basically instead of updating) (But adding merge instead of overriding it will combine)
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubmissionsCollection).document(submissionToUpdate.id).setData([FirebaseConstants.subType : subType, FirebaseConstants.sub : sub, FirebaseConstants.winOrLoss : winOrLoss], merge: true) { error in
            //Check for errors
            if error == nil {
                //Get the new data
                self.getDataSubmissions()
            } else {
                //Handle Errors
            }
        }
        
    }//: Update Data Submissions
    //---------------------------------------------------------------------------------------------------
}


    //MARK: - PREVIEW
//struct NewSkillView_Previews: PreviewProvider {
//    static var previews: some View {
////        NewSkillView(winMoreThanZero:.constant(false), lossMoreThanZero: .constant(false), isNewSubmissionOpen: .constant(true))
//    }
//}
