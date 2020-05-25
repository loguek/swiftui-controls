//
//  ContentView.swift
//  radical-controls
//
//  Created by Kevin Logue on 25/05/2020.
//  Copyright © 2020 Kevin Logue. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
               .fill(LinearGradient(
                   gradient: Gradient(colors: [
                       Color.init(
                                 red: 58 / 255,
                                 green: 47 / 255,
                                 blue: 118 / 255
                             ),
                             Color.init(
                                 red: 27 / 255,
                                 green: 21 / 255,
                                 blue: 62 / 255
                             )
                   ]), startPoint: .top, endPoint: .bottom))
            HStack {
                RadicalGauge(currentValue: 25, minValue: 0, maxValue: 100)
                .foregroundColor(Color.white)
                .font(Font.system(size: 50, weight: .bold, design: .monospaced))
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.init(
                            red: 104 / 255,
                            green: 57 / 255,
                            blue: 121 / 255
                        ),
                        Color.init(
                            red: 104 / 255,
                            green: 57 / 255,
                            blue: 121 / 255,
                            opacity: 0
                        )
                    ]),
                    center: .center,
                    startRadius: 2,
                    endRadius: 200)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
