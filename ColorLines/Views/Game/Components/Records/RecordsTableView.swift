//
//  RecordsTableView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/28/23.
//

import SwiftUI

struct RecordModel {
    let playerName: String
    let score: String
    let date: String
}

struct RecordsTableView: View {
    @Environment(\.horizontalSizeClass) var hSizeClass
    var records: FetchedResults<Record>
    
    var body: some View {
        Table(records) {
            TableColumn("Player Name") {
                if hSizeClass == .compact {
                    let recordModel = RecordModel(playerName: $0.name ?? Misc.emptyPlayerName, score: String($0.score), date: $0.date ?? "")
                    RecordTableRowView(record: recordModel)
                } else {
                    Text($0.name ?? Misc.emptyPlayerName)
                }
            }
            TableColumn("Score") {
                Text(String($0.score))
            }
            TableColumn("Date") {
                Text($0.date ?? "")
            }
        }
    }
}
