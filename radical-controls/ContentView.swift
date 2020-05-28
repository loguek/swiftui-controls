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
                    ColorManager.backgroundLight,
                    ColorManager.backgroundDark
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
                        ColorManager.backgroundHighlight,
                        ColorManager.backgroundHighlight.opacity(0)
                    ]),
                    center: .center,
                    startRadius: 20,
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
