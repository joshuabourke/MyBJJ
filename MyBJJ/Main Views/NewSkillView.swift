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
    //MARK: - WIN/LOSS PICKER
    var pickerWinOrLoss = ["Win", "Loss"]

    @StateObject var newSubVM: AddingNewSubViewModel
    
    //MARK: - UPDATING DATA
    @State var fileName: String = ""
    @State var fileItem: Int = 0
    
    //MARK: - SUB PICKER
    var pickerSubmissions = ["Chokehold", "Upper Body", "Lower Body"]
    @State var selectedSub: String = ""
    @State var pickerWinOrLossIndex: String = "Win"
    @State var pickerSelectionIndex: String = "Chokehold"
    
    @Binding var isNewSubmissionOpen: Bool
    @State var completedSubmissions = subsData

    @State var chokeholdCountWin = 0
    @State var lowerBodyCountWin = 0
    @State var upperBodyCountWin = 0
    @State var chokeholdCountLoss = 0
    @State var lowerBodyCountLoss = 0
    @State var upperBodyCountLoss = 0
    
    //MARK: - ALERT
    @State var showAlert = false

    //MARK: - CORE DATA
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: SavedRolls.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SavedRolls.subDate, ascending: true)])
    
    
    var savedSubs: FetchedResults<SavedRolls>
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
            Picker("Win or Loss", selection: $pickerWinOrLossIndex) {
                ForEach(pickerWinOrLoss, id:\.self) {
                    Text($0)
                }
            }//: PICKER WIN/LOSS
            .pickerStyle(.segmented)
            .padding(30)
            
            
            //MARK: - SUB TYPE PICKER
            Picker("New Submission", selection: $pickerSelectionIndex){
                ForEach(pickerSubmissions, id:\.self) {
                    Text($0)
                }
            }//: PICKER
            .pickerStyle(.segmented)
            .padding(30)
            .onChange(of: pickerSelectionIndex) { newValue in
                selectedSub = ""
            }
//            Text("Area: \(pickerSelectionIndex)")
//                .font(.title2.bold())
            
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
                    newSubVM.addDataSubmissions(winOrLoss: pickerWinOrLossIndex, subType: pickerSelectionIndex, sub: selectedSub)
                    //2.
                    increaseSubs()
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
    
     func increaseSubs(){
        
        //MARK: - WINS
        if pickerSelectionIndex == "Lower Body" && pickerWinOrLossIndex == "Win"{
            lowerBodyCountLoss += 1
            newSubVM.addLowerWin(lowerWin: lowerBodyCountWin)
            subVM.graphMoreThanZero = true
        }
        else if pickerSelectionIndex == "Upper Body" && pickerWinOrLossIndex == "Win"{
            upperBodyCountWin += 1
            newSubVM.addUpperWin(upperWin: upperBodyCountWin)
            subVM.graphMoreThanZero = true
        }
        else if pickerSelectionIndex == "Chokehold" && pickerWinOrLossIndex == "Win" {
            chokeholdCountWin += 1
            newSubVM.addChokeWin(chokeWin: chokeholdCountWin)
            subVM.graphMoreThanZero = true
        }
        
        //MARK: - LOSSES
        if pickerSelectionIndex == "Lower Body" && pickerWinOrLossIndex == "Loss"{
            lowerBodyCountLoss += 1
            newSubVM.addLowerLoss(lowerLoss: lowerBodyCountLoss)
            subVM.graphMoreThanZeroLoss = true
        }
        else if pickerSelectionIndex == "Upper Body" && pickerWinOrLossIndex == "Loss"{
            upperBodyCountLoss += 1
            newSubVM.addUpperLoss(upperLoss: upperBodyCountLoss)
            subVM.graphMoreThanZeroLoss = true
        }
        else if pickerSelectionIndex == "Chokehold" && pickerWinOrLossIndex == "Loss" {
            chokeholdCountLoss += 1
            newSubVM.addChokeLoss(chokeLoss: chokeholdCountLoss)
            subVM.graphMoreThanZeroLoss = true
        }
        
        print("WINS -> Picker Selection Index:\(pickerSelectionIndex), WinLoss Picker Index: \(pickerWinOrLossIndex),UpperBodyCount:\(subVM.upperBodyCount),LowerBodyCount:\(subVM.lowerBodyCount),ChokeholdCount:\(subVM.chokeholdCount)")
        
        print("LOSS -> Picker Selection Index:\(pickerSelectionIndex), WinLoss Picker Index: \(pickerWinOrLossIndex),UpperBodyCount:\(subVM.upperBodyCountLoss),LowerBodyCount:\(subVM.lowerBodyCountLoss),ChokeholdCount:\(subVM.chokeholdCountLoss)")

    }

}

struct FirebaseConstants {
    //MARK: - TO SAVE INFO FOR THE LIST ITEMS
    static let userId = "userId"
    static let winOrLoss = "WinOrLoss"
    static let subType = "SubType"
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
    
    
    static let upperWins = "upperWins"
    static let chokeWins = "chokeWins"
    static let lowerWins = "lowerWins"
    
    static let upperLoss = "upperLoss"
    static let chokeLoss = "chokeLoss"
    static let lowerLoss = "lowerLoss"
}

struct Submissions: Identifiable {
    var id: String
    var upperLowerChoke: String
    var sub: String
    var date: Timestamp
    var winOrLoss: String
}

struct UpperWinsStruct: Identifiable {
    var id: String
    var upperWins: Int
}

struct ChokeWinsStruct: Identifiable {
    var id: String
    var chokeWins: Int
}

struct LowerWinsStruct: Identifiable {
    var id: String
    var lowerWins: Int
}

struct UpperLossStruct: Identifiable {
    var id: String
    var upperLoss: Int
}

struct ChokeLossStruct: Identifiable {
    var id: String
    var chokeLoss: Int
}

struct LowerLossStruct: Identifiable {
    var id: String
    var lowerLoss: Int
}

class AddingNewSubViewModel: ObservableObject {
    
    @Published var errorMessage: String = ""
    
//    @Published var addedSubmissions = [FirebaseSavedSubs]()
//    @Published var firebaseSubStats = [FirebaseSavedSubs]()

    @Published var submissions = [Submissions]()
    
    @Published var upperBodyWinsStruct = [UpperWinsStruct]()
    @Published var chokeHoldWinsStruct = [ChokeWinsStruct]()
    @Published var lowerBodyWinsStruct = [LowerWinsStruct]()
    
    @Published var upperBodyLossStruct = [UpperLossStruct]()
    @Published var chokeHoldLossStruct = [ChokeLossStruct]()
    @Published var lowerBodyLossStruct = [LowerLossStruct]()
    
    let myBJJUser: MyBJJUser?
    
    init(myBJJUser: MyBJJUser?) {
        self.myBJJUser = myBJJUser
//        fetchAddedSubs()
//        fetchSubStats()
        getDataSubmissions()
        fetchAllStats()
    }

    func fetchAllStats() {
        getUpperWinStats()
        getChokeWinStats()
        getLowerWinStats()
        
        getUpperLossStats()
        getChokeLossStats()
        getLowerLossStats()
    }
    

    //---------------------------------------------------------------------------------------------------
    //MARK: - GET SUB STATS
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
                            return UpperWinsStruct(id: queryDocumentSnapshot.documentID, upperWins: queryDocumentSnapshot[FirebaseConstants.upperWins] as? Int ?? 0)
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }
    
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
                            return ChokeWinsStruct(id: queryDocumentSnapshot.documentID, chokeWins: queryDocumentSnapshot[FirebaseConstants.chokeWins] as? Int ?? 0)
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }
    
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
                            return LowerWinsStruct(id: queryDocumentSnapshot.documentID, lowerWins: queryDocumentSnapshot[FirebaseConstants.lowerWins] as? Int ?? 0)
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }
    
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
                            return UpperLossStruct(id: queryDocumentSnapshot.documentID, upperLoss: queryDocumentSnapshot[FirebaseConstants.upperLoss] as? Int ?? 0)
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
        
    }
    
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
                            return ChokeLossStruct(id: queryDocumentSnapshot.documentID, chokeLoss: queryDocumentSnapshot[FirebaseConstants.chokeLoss] as? Int ?? 0)
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }
    
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
                            return LowerLossStruct(id: queryDocumentSnapshot.documentID, lowerLoss: queryDocumentSnapshot[FirebaseConstants.lowerLoss] as? Int ?? 0)
                        })
                    }
                } else {
                    //Handle Errors
                }
            }
        }
    }//GetLowerLossStats
    
    //---------------------------------------------------------------------------------------------------
    //MARK: - GET LIST OF SUBS
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
                            return Submissions(id: queryDocumentSnapshot.documentID, upperLowerChoke: queryDocumentSnapshot[FirebaseConstants.subType] as? String ?? "", sub: queryDocumentSnapshot[FirebaseConstants.sub] as? String ?? "", date: queryDocumentSnapshot["timestamp"] as? Timestamp ?? Timestamp(), winOrLoss: queryDocumentSnapshot[FirebaseConstants.winOrLoss] as? String ?? "")
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
    func addUpperWin(upperWin: Int) {
        //Gettting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a Collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperWins).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.upperBodyWins: upperWin, "timestamp": Timestamp()]) { error in
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
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.upperLoss).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.upperBodyLoss: upperLoss, "timestamp": Timestamp()]) { error in
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
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeWins).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.chokeholdWins: chokeWin, "timestamp": Timestamp()]) { error in
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
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubStats).document(userId).collection(FirebaseConstants.chokeLoss).addDocument(data: [FirebaseConstants.userId : userId, FirebaseConstants.chokeholdLoss: chokeLoss, "timestamp": Timestamp()]) { error in
            //Check for Error
            if error == nil {
                //No Errors
                
                //Call get data to retreive latest Data
                self.getChokeLossStats()
            } else {
                
            }
        }
    }//: Add Choke Win
    
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
    //MARK: - ADD SUBMISSION TO LIST
    func addDataSubmissions(winOrLoss: String, subType: String, sub: String){
        //Getting the users ID
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        //Get reference to the data base
        let db = Firestore.firestore()
        
        //Add a document to a collection
        db.collection(FirebaseConstants.submissionCollection).document(userId).collection(FirebaseConstants.userSubmissionsCollection).addDocument(data: [FirebaseConstants.userId : userId,FirebaseConstants.subType : subType, FirebaseConstants.winOrLoss : winOrLoss, FirebaseConstants.sub : sub, "timestamp": Timestamp()]) { error in
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
    
    //MARK: - DELETE SUBMISSION FROM LIST
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
    }
    
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
    }
    
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
    }
    
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
    }
    
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
    }
    
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
    }
    
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
    
}


    //MARK: - PREVIEW
//struct NewSkillView_Previews: PreviewProvider {
//    static var previews: some View {
////        NewSkillView(winMoreThanZero:.constant(false), lossMoreThanZero: .constant(false), isNewSubmissionOpen: .constant(true))
//    }
//}
