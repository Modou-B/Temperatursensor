//
//  home.swift
//  dht22-iOS
//
//  Created by Modou on 25.06.23.
//

import SwiftUI

struct Temps: Codable {
    var temp: Double
    
    init(temps: Double = 0) {
        self.temp = temps
    }
}

struct Humidity: Codable {
    var humidity: Double
    
    init(humidity: Double = 0) {
        self.humidity = humidity
    }
}

struct home: View {
    @StateObject var mqttManager = MQTTManager.shared()
    
    @State private var temp: Temps = Temps()
    @State private var receivedTemps = ""
    
    @State private var humidity: Humidity = Humidity()
    @State private var receivedHumidity = ""
    
    @State private var settings = false
    
    var body: some View {
        
        NavigationStack() {
            HStack {
                VStack {
                    Text("Temperatur")
                     .font(.largeTitle)
                     .bold()
                     .padding()
                     .foregroundColor(.black)
                 
                     HStack {
                        Text("Temp:")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.blue)
 
                         Text(String(format: "%.2f", temp.temp))
                            .foregroundColor(.green)
                            .onChange(of: mqttManager.currentAppState.currentTemps) {_ in setTemps()
                            }
                     }
                    
                    HStack {
                       Text("Humidity:")
                           .font(.system(size: 20))
                           .bold()
                           .foregroundColor(.blue)

                        Text(String(format: "%.2f", humidity.humidity))
                           .foregroundColor(.green)
                           .onChange(of: mqttManager.currentAppState.currentHumidity) {_ in setHumidity()
                           }
                    }
                    
                    Spacer()
                        .frame(height: 100)
                    
                    Button("Settings") {
                        settings = true
                    }
                    .navigationDestination(
                        isPresented: $settings) {dht22_iOS.settings()}
                }
            }
        }
        .onAppear {
            settings = false
        }
    }
    
    func setTemps() {
        receivedTemps = mqttManager.currentAppState.currentTemps
        let jsonData = try? Data(receivedTemps.utf8)
        if jsonData == nil {
            return
        }
        let decodedResult = try? JSONDecoder().decode(Temps.self, from: jsonData ?? Data())
        if decodedResult == nil {
            return
        }
        temp = decodedResult ?? Temps()
        print("\(temp)")
        print("\(temp.temp)")
    }
    
    func setHumidity() {
        receivedHumidity = mqttManager.currentAppState.currentHumidity
        let jsonData = try? Data(receivedHumidity.utf8)
        if jsonData == nil {
            return
        }
        let decodedResult = try? JSONDecoder().decode(Humidity.self, from: jsonData ?? Data())
        if decodedResult == nil {
            return
        }
        humidity = decodedResult ?? Humidity()
        print("\(humidity)")
        print("\(humidity.humidity)")
    }
}

#Preview {
    home()
        .environmentObject(MQTTManager.shared())
}
