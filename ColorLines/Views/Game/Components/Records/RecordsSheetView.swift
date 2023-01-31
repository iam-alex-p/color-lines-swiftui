//
//  RecordsSheetView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/25/23.
//

import SwiftUI
import CoreData

struct RecordsSheetView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isPresentingConfirm = false
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: [NSSortDescriptor(key: "score", ascending: false)])
    private var records: FetchedResults<Record>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("High Scores")
                    .font(hSizeClass == .regular ? .largeTitle : .title3)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .padding(.bottom, hSizeClass == .compact ? 20 : 40)
                Divider()
                if records.isEmpty {
                    Text("It seems like you haven't played much 🤔\nIt's time to start a New Game 😎")
                        .font(hSizeClass == .regular ? .title3 : .headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                        .multilineTextAlignment(.center)
                } else {
                    RecordsTableView(records: records)
                }
                Spacer()
            }
            .toolbar {
                Button(role: .destructive) {
                    isPresentingConfirm.toggle()
                } label: {
                    Image(systemName: "pip.remove")
                }
                .buttonStyle(.borderedProminent)
                .disabled(records.isEmpty)
                .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                    Button("Remove all Records?", role: .destructive) {
                        DispatchQueue.main.async {
                            records.forEach { viewContext.delete($0) }
                            PersistenceController.instance.saveContext()
                        }
                    }
                }
            }
        }
    }
}

struct RecordsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsSheetView()
    }
}
