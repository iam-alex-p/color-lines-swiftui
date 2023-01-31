//
//  SettingsView.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/26/23.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.requestReview) private var requestReview
    
    @AppStorage("playerName") private var playerName = ""
    @AppStorage("isSoundOn") private var isSoundOn = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Settings")) {
                        HStack {
                            MenuImageView(imageName: "square.and.pencil.circle.fill")
                            TextField("Enter your Name for High Scores", text: $playerName)
                                .onReceive(playerName.publisher.collect()) {
                                    self.playerName = String($0.prefix(14))
                                }
                        }
                        HStack {
                            MenuImageView(imageName: "volume.2.fill")
                            Toggle("Enable Sound", isOn: $isSoundOn)
                        }
                    }
                    Section(header: Text("About")) {
                        HStack {
                            MenuImageView(imageName: "list.bullet.clipboard.fill")
                            NavigationLink(destination: GameRulesView()) {
                                Text("Game Rules")
                            }
                        }
                    }
                    Section(header: Text("Feedback")) {
                        ShareLink(item: "I'm playing Lines of Balls! Can you beat me at it?\nhttps://apps.apple.com/app/id1667124057")
                        HStack {
                            MenuImageView(imageName: "star.square.fill")
                            Button("Rate in App Store") {
                                DispatchQueue.main.async {
                                    requestReview()
                                }
                            }
                        }
                        HStack {
                            MenuImageView(imageName: "envelope.fill")
                            Link("Contact Creator", destination: URL(string: "https://twitter.com/iam_aleks_p")!)
                        }
                    }
                    Text(.init("CREATED WITH ☕️ BY [ALEKSEI POKOLEV](https://www.linkedin.com/in/apokolev/)"))
                        .font(hSizeClass == .regular ? .caption : .caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Lines of Balls")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct MenuImageView: View {
    let imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(.accentColor)
    }
}
