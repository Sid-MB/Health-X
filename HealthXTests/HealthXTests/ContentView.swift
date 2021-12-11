//
//  ContentView.swift
//  HealthXTests
//
//  Created by Siddharth M. Bhatia on 12/11/21.
//

import SwiftUI
import Health_X

struct ContentView: View {
    @StateObject var stats = HXStats()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
        Text(stats.stepCount?.description ?? "--")
        Button("Steps") {
            Task {
                await stats.update()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
