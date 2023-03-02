//
//  ContentView.swift
//  TestUDPBroadcast
//
//  Created by maochun on 2023/3/1.
//

import SwiftUI

struct ContentView: View {
    
    let udp = UDPBroadcast()
    
    @State var buttonTitle: String = "Start UDP Broadcast"
    var body: some View {
        VStack {
            Button(buttonTitle) {
                
                if udp.started(){
                    print("Stop UDP Broadcast")
                    udp.stopBroadcast()
                    buttonTitle = "Start UDP Broadcast"
                }else{
                    print("Start UDP Broadcast")
                    
                    let buf :[UInt8] = [0xdd, 0x80, 0x0b, 0x00,0x44, 0x52,0x41,0x59,0x54,0x45,0x4b,0x41,0x50,0x50,0x73]
                    let data = Data(buf)
                    
                    if udp.startBroadcast(port: 56415, data: data){
                        buttonTitle = "Stop UDP Broadcast"
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
