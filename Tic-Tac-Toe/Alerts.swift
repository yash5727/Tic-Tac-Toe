//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Yash Thakkar on 2023-04-21.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}
struct AlertContext{
    static let humanWin = AlertItem(title: Text("You win"), message: Text("You are so smart."), buttonTitle: Text("Hell yeah!"))
    static let computerWin = AlertItem(title: Text("You lost"), message: Text("You are so loser."), buttonTitle: Text("Play again"))
    static let draw = AlertItem(title: Text("Draw"), message: Text("Nice game."), buttonTitle: Text("Try again"))
}
