//
//  ContentView.swift
//  GKSliderExample
//
//  Created by Gergely Kovacs on 2023. 11. 09..
//

import GKSlider
import SwiftUI

struct ContentView: View {
    @State var value = 0.0

    var body: some View {
        ZStack {
            Color.yellow
            VStack {

                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                Text("Hello, world!")
                    .padding(.bottom)

                Text("\(value)")

                GKSlider(range: -10..<10,
                         sliderValue: $value,
                         configuration: .init())
                .frame(width: 300, height: 20)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
