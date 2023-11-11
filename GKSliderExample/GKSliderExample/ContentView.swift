//
//  ContentView.swift
//  GKSliderExample
//
//  Created by Gergely Kovacs on 2023. 11. 09..
//

import GKSlider
import SwiftUI

struct ContentView: View {
    @State var value = 1.1

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
                
                GKSlider(range: -10...10,
                         sliderValue: $value,
                         configuration: .init(axis: .horizontal), step: 2
                )
                .frame(width: 300, height: 300)

                Slider(value: $value, in: -10.0...10.0, step: 2)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
