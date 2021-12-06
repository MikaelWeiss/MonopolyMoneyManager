//
//  ContentView.swift
//  MonopolyMoneyManager
//
//  Created by Mikael Weiss on 12/23/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var players = Players()
    let rows: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    let values = [1, 5, 10, 20, 50, 100, 500]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(players.players, id: \.id) { player in
                    Spacer()
                    VStack {
                        Text("Player \(player.id)")
                        Text("$\(player.totalMoney)")
                    }
                    .padding()
                    .background(Color.green)
                    .border(Color(.darkGray), width: player.selected ? 5 : 0)
                    .onTapGesture {
                        players.togglePlayerWith(id: player.id)
                    }
                    Spacer()
                }
            }.padding()
            Spacer().frame(height: 16)
            HStack {
                LazyVGrid(columns: rows, alignment: .center, spacing: 16) {
                    ForEach(values, id: \.self) { value in
                        TextView(value, negative: false)
                            .onTapGesture {
                                players.updatePlayer(value: value)
                            }
                    }
                }
                LazyVGrid(columns: rows, alignment: .center, spacing: 16) {
                    ForEach(values, id: \.self) { value in
                        TextView(value, negative: true).onTapGesture {
                            players.updatePlayer(value: (-1 * value))
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Player: Identifiable {
    let id: Int
    var totalMoney = 0
    var selected = false
    
    init(id: Int) {
        self.id = id
    }
}

class Players: ObservableObject {
    @Published var players = [Player(id: 1), Player(id: 2)]
    
    func togglePlayerWith(id: Int) {
        let player = players.first(where: { $0.id == id })
        player?.selected.toggle()
    }
    
    func updatePlayer(value: Int) {
        for player in players {
            if player.selected {
                player.totalMoney += value
            }
        }
    }
}

struct TextView: View {
    let value: Int
    let negative: Bool
    
    init(_ value: Int, negative: Bool) {
        self.value = value
        self.negative = negative
    }
    
    var body: some View {
        Text("\(negative ? "-" : "")\(value)")
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .frame(width: 56, height: 56)
            .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundColor(.blue))
    }
}
