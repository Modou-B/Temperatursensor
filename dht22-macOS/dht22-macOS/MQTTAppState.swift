//
//  MQTTAppState.swift
//  SwiftUI_MQTT
//
//  Created by Anoop M on 2021-01-19.
//

import Combine
import Foundation

enum MQTTAppConnectionState {
    case connected
    case disconnected
    case connecting
    case connectedSubscribed
    case connectedUnSubscribed

    var description: String {
        switch self {
        case .connected:
            return "Connected"
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .connectedSubscribed:
            return "Subscribed"
        case .connectedUnSubscribed:
            return "Connected Unsubscribed"
        }
    }
    var isConnected: Bool {
        switch self {
        case .connected, .connectedSubscribed, .connectedUnSubscribed:
            return true
        case .disconnected,.connecting:
            return false
        }
    }
    
    var isSubscribed: Bool {
        switch self {
        case .connectedSubscribed:
            return true
        case .disconnected,.connecting, .connected,.connectedUnSubscribed:
            return false
        }
    }
}

final class MQTTAppState: ObservableObject {
    @Published var appConnectionState: MQTTAppConnectionState = .disconnected
    @Published var historyText: String = ""
    @Published var currentProcess: String = ""
    @Published var currentPositions: String = ""
    @Published var currentTemps: String = ""
    @Published var currentHumidity: String = ""
    
    private var receivedMessage: String = ""
    private var temps: String = ""
    private var humidity: String = ""
    
    
    func setTemps(text: String) {
        currentTemps = text
    }
    
    func setHumidity(text: String) {
        currentHumidity = text
    }
    
    
    
    

    func setPositions(text: String) {
        currentPositions = text
    }
    
    func setProcess(text: String) {
        currentProcess = text
    }
    
    
    func setReceivedMessage(text: String) {
        historyText = text
        
    }

    func clearData() {
        receivedMessage = ""
        currentProcess = ""
    }

    func setAppConnectionState(state: MQTTAppConnectionState) {
        appConnectionState = state
    }
}
