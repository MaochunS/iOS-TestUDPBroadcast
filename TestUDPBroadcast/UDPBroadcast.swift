//
//  UDPBroadcast.swift
//  TestUDPBroadcast
//
//  Created by maochun on 2023/3/1.
//

import CocoaAsyncSocket

class UDPBroadcast: NSObject{
    
    var socket: GCDAsyncUdpSocket?
     
    func startBroadcast(port:Int, data:Data) -> Bool{
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        guard let s = socket else{
            return false
        }
        s.setIPv6Enabled(false)

        do {
            try s.bind(toPort: UInt16(port), interface: "en0")
            try s.enableBroadcast(true)
            try s.beginReceiving()
        } catch {
            print("Error: \(error)")
            return false
        }
        
        s.send(data, toHost: "255.255.255.255", port: UInt16(port), withTimeout: -1, tag: 0)
        return true
    }
    
    func stopBroadcast(){
        socket?.close()
        socket = nil
    }
    
    func started() -> Bool{
        if socket != nil{
            return true
        }
        return false
    }

}

extension UDPBroadcast: GCDAsyncUdpSocketDelegate{
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        var host: NSString?
        var port: UInt16 = 0
        GCDAsyncUdpSocket.getHost(&host, port: &port, fromAddress: (address as Data?)!)
        
        let dataStr = data.reduce("") {$0 + String(format: "0x%02x ", $1)}
        print("Receive data from \(host ?? "N/A") \(port)")
        print(dataStr)
    }
    
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        print("socket close with error \(String(describing: error))")
    }
}
