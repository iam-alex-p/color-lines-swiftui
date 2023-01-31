//
//  RuleView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/26/23.
//

import SwiftUI

struct RuleView: View {
    @Environment(\.horizontalSizeClass) var hSizeClass
    var rule: GameRule
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: rule.symbolName)
                .foregroundColor(.accentColor)
            VStack {
                Text(rule.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .font(hSizeClass == .regular ? .title2 : .headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tracking(1)
                    .padding(.bottom, 1)
                Text(rule.rule)
                    .foregroundColor(.gray)
                    .font(hSizeClass == .regular ? .title3 : .subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .padding(.bottom, hSizeClass == .compact ? 15 : 30)
        }
        .padding(.leading, 10)
    }
}

struct RuleView_Previews: PreviewProvider {
    static var previews: some View {
        let rule = GameRule(symbolName: "move.3d", caption: "Test Caption", rule: "Table with High Scores is available with Player Name from Settings")
        RuleView(rule: rule)
    }
}
