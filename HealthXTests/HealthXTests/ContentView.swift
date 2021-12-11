//
//  ContentView.swift
//  HealthXTests
//
//  Created by Siddharth M. Bhatia on 12/11/21.
//

import SwiftUI
import Health_X

struct ContentView: View {
    @StateObject var interface = HXInterface()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
        Text(interface.stats.stepCount?.description ?? "--")
        Button("Steps") {
            Task {
                await interface.updateAll()
                print(interface.stats.stepCount)
            }
        }
        .onChange(of: interface.stats.stepCount, perform: {val in
            print("Stepcount changed: \(val)")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
