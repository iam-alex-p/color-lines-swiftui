//
//  GameRulesView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/26/23.
//

import SwiftUI

struct GameRule: Identifiable {
    var id = UUID()
    let symbolName: String
    let caption: String
    let rule: String
}

struct GameRulesView: View {
    @Environment(\.horizontalSizeClass) var hSizeClass
    
    private let rules = [
        GameRule(symbolName: "move.3d", caption: "MOVE", rule: "Move one Ball per turn either horizontally or vertically"),
        GameRule(symbolName: "point.topleft.down.curvedto.point.bottomright.up.fill", caption: "BUILD", rule: "Build either horizontal, vertical or diagnoal lines of five or more Balls of the same color"),
        GameRule(symbolName: "lessthan.circle.fill", caption: "REDUCE", rule: "If a line of at least five same-colored Balls was built, it disappears from the Field"),
        GameRule(symbolName: "plus.square.fill.on.square.fill", caption: "EARN", rule: "Earn Points after forming a line of at least five same-colored Balls"),
        GameRule(symbolName: "soccerball", caption: "MORE BALLS", rule: "If same-colored line was not formed, three new Balls of random color are added to the Field"),
        GameRule(symbolName: "arrowshape.turn.up.backward.circle.fill", caption: "REVERT", rule: "You can revert a move if same-colored line was not formed"),
        GameRule(symbolName: "list.bullet.rectangle.fill", caption: "SCORE", rule: "Table with High Scores is available with Player Name from Settings")
    ]
    
    var body: some View {
        ScrollView {
            Text("Introducing\nBalls of Lines".uppercased())
                .foregroundColor(.accentColor)
                .fontWeight(.bold)
                .font(hSizeClass == .regular ? .title2 : .title3)
                .padding(.bottom, 15)
                .multilineTextAlignment(.center)
                .tracking(2)
            
            ForEach(rules) { rule in
                RuleView(rule: rule)
            }
        }
        .padding()
        Spacer()
    }
}

struct GameRulesView_Previews: PreviewProvider {
    static var previews: some View {
        GameRulesView()
    }
}
