//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Yash Thakkar on 2023-04-21.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Picker("Select a difficulty Level", selection: $viewModel.difficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { level in
                        Text(level.stringValue())
                    }
                }
                .pickerStyle(.menu)
                .disabled(viewModel.isGameStarted)
                Button(action: {
                    viewModel.isGameStarted.toggle()
                    if !viewModel.isGameStarted{ viewModel.resetGame() }
                }){
                    Text(!viewModel.isGameStarted ? "Start" : "Stop")
                }
                GameBoardView(viewModel: viewModel, proxy: geometry)
            }
        }
    }
}

enum Player{
    case human, computer
}

enum Difficulty: Int, CaseIterable{
    case easy,medium,hard
    func stringValue() -> String {
        switch(self) {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
}

struct Move{
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.red).opacity(0.6)
            .frame(width: proxy.size.width / 3 - 15,
                   height: proxy.size.width / 3 - 15)
    }
}

struct PlayerIndicator: View {
    var systeImageName: String
    var body: some View {
        Image(systemName: systeImageName)
            .resizable()
            .frame(width: 40,height: 40)
            .foregroundColor(.white)
    }
}

struct GameBoardView: View {
    @StateObject var viewModel: GameViewModel
    var proxy: GeometryProxy
    var body: some View {
        VStack{
            Spacer()
            LazyVGrid(columns: viewModel.columns,spacing: 5){
                ForEach(0..<9){i in
                    ZStack{
                        GameSquareView(proxy: proxy)
                        
                        PlayerIndicator(systeImageName: viewModel.moves[i]?.indicator ?? "")
                    }
                    .onTapGesture {
                        viewModel.processPlayerMove(for: i)
                    }
                }
            }
            Spacer()
        }
        .disabled(viewModel.isGameBoardDisbaled || !viewModel.isGameStarted)
        .padding()
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame()})
            )
        })
    }
}
