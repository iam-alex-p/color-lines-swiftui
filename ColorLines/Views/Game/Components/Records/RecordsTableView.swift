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
            TableColumn("Name") {
                if hSizeClass == .compact {
                    let recordModel = RecordModel(playerName: $0.name ?? Misc.emptyPlayerName, score: String($0.score), date: dateFormatter.string(from: $0.date ?? Date()))
                    RecordTableRowView(record: recordModel)
                } else {
                    Text($0.name ?? Misc.emptyPlayerName)
                }
            }
            TableColumn("Score") {
                Text(String($0.score))
            }
            TableColumn("Date") {
                Text(dateFormatter.string(from: $0.date ?? Date()))
            }
        }
    }
}

extension RecordsTableView {
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        return dateFormatter
    }
}
