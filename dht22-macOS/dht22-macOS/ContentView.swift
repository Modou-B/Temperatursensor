//
//  ContentView.swift
//  dht22-macOS
//
//  Created by Modou on 25.06.23.
//

import SwiftUI
import CocoaMQTT

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
