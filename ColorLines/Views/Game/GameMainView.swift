//
//  GameMainView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI
import CoreData

struct GameMainView: View {
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: [NSSortDescriptor(key: "score", ascending: false)])
    private var records: FetchedResults<Record>
    
    @StateObject var viewModel = ColorLinesViewModel<Ball>()
    @State private var isSettingsPresent = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Lines of Balls")
                    .font(hSizeClass == .regular ? .largeTitle : .title)
                    .foregroundColor(.primary)
                    .fontWeight(.ultraLight)
                
                Divider()
                
                Text(!viewModel.isGameOver ? "Score: \(viewModel.gameModel.score)": "Well Played! You score: \(viewModel.gameModel.score)")
                    .font(hSizeClass == .regular ? .largeTitle : .title2)
                    .foregroundColor(viewModel.isGameOver ? .accentColor : .primary)
                    .fontWeight(.bold)
                    .padding(20)
                
                Spacer()
                
                Text("\(viewModel.gameModel.moveComment)")
                    .font(hSizeClass == .regular ? .largeTitle : .headline)
                    .foregroundColor(viewModel.isGameOver ? .primary : .accentColor)
                    .fontWeight(.semibold)
                    .tracking(hSizeClass == .regular ? 4 : 2)
                
                NextFiguresView(figures: viewModel.gameModel.nextFigures)
                    .padding()
                VStack(alignment: .center) {
                    GameFieldView(viewModel: viewModel)
                    GameButtonsView(viewModel: viewModel)
                        .padding(.top, 30)
                }
            }
            .toolbar {
                Button {
                    isSettingsPresent.toggle()
                } label: {
                    Image(systemName: "gear")
                        .imageScale(hSizeClass == .regular ? .medium : .small)
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $isSettingsPresent) {
                    SettingsView()
                }
            }
            .controlSize(hSizeClass == .regular ? .large : .regular)
            .padding()
            .onChange(of: viewModel.isGameOver) {
                if $0 && viewModel.gameModel.score != 0 {
                    let playerName = UserDefaults.standard.string(forKey: "playerName") ?? Misc.emptyPlayerName
                    DispatchQueue.main.async {
                        self.saveRecord(name: playerName.isEmpty ? Misc.emptyPlayerName : playerName, score: Int16(viewModel.gameModel.score), date: Date())
                    }
                }
            }
        }
    }
}

private extension GameMainView {
    func saveRecord(name: String, score: Int16, date: Date) {
        let record = Record(context: viewContext)
        record.name = name
        record.score = score
        record.date = date
        
        PersistenceController.instance.saveContext()
    }
}

struct GameMainView_Previews: PreviewProvider {
    static var previews: some View {
        GameMainView()
    }
}
