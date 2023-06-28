//
//  settings.swift
//  dht22-macOS
//
//  Created by Modou on 28.06.23.
//

import SwiftUI

struct settings: View {
    @StateObject var mqttManager = MQTTManager.shared()
    
    var body: some View {
        VStack {
            Button("Start") {
                mqttManager.publish(topic: "dht/start", with: "1")
            }
//            .foregroundColor(.white)
//            .frame(width: 300, height: 50)
//            .background(Color.blue)
//            .cornerRadius(10)
//            .shadow(radius: 1)
//
            
            //            Spacer()
            //                .frame(height: 50)
            
            Button("Stop") {
                mqttManager.publish(topic: "dht/stop", with: "1")
            }
//            .foregroundColor(.white)
//            .frame(width: 300, height: 50)
//            .background(Color.blue)
//            .cornerRadius(10)
//            .shadow(radius: 1)
            
            //            Spacer()
            //                .frame(height: 50)
            
            Button("Restart") {
                mqttManager.publish(topic: "dht/restart", with: "1")
            }
//            .foregroundColor(.white)
//            .frame(width: 300, height: 50)
//            .background(Color.blue)
//            .cornerRadius(10)
//            .shadow(radius: 1)
            
            
            Spacer()
                .frame(height: 50)
            
            
            Button("Init Server") {
                mqttManager.initializeMQTT(host: "192.168.178.38", identifier: UUID().uuidString)
            }
//            .foregroundColor(.white)
//            .frame(width: 300, height: 50)
//            .background(Color.blue)
//            .cornerRadius(10)
//            .shadow(radius: 1)
            
            Button("Connect to Server") {
                mqttManager.connect()
//                Task {
//                    try? await Task.sleep(nanoseconds: 100000000 )
//                    subscribeTemps()
//                    if (mqttManager.isSubscribed()) {
//                        print("subscribed")
//                    }
//                }
            }
//            .foregroundColor(.white)
//            .frame(width: 300, height: 50)
//            .background(Color.blue)
//            .cornerRadius(10)
//            .shadow(radius: 1)
            
            Button("Subscribe") {
                    
                if (!mqttManager.isSubscribed()) {
                    subscribeTemps()
                    subscribeHumidity()
                } else {
                    print("subscribed")
                }
            }
//            .foregroundColor(.white)
//            .frame(width: 300, height: 50)
//            .background(Color.blue)
//            .cornerRadius(10)
//            .shadow(radius: 1)
        }
        .padding()
        .frame(width: 640, height: 400)
    }
    func subscribeTemps() {
        mqttManager.subscribe(topic: "dht/temp")
    }
    func subscribeHumidity() {
        mqttManager.subscribe(topic: "dht/humidity")
    }
}

#Preview {
    settings()
        .environmentObject(MQTTManager.shared())
}
