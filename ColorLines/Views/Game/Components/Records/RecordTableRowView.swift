//
//  RecordTableRowView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/28/23.
//

import SwiftUI

struct RecordTableRowView: View {
    var record: RecordModel
    
    var body: some View {
        HStack {
            Text(record.playerName)
                .frame(width: 150, alignment: .leading)
            Text(record.score)
            Spacer()
            Text(record.date)
        }
    }
}

struct RecordTableRowView_Previews: PreviewProvider {
    static var previews: some View {
        RecordTableRowView(record: RecordModel(playerName: "Test Player", score: "50", date: "02/19/1990"))
    }
}
