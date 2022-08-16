//
//  NetworkMonitor.swift
//  TableGit
//
//  Created by MINERVA on 20/07/2022.
//

import Network

class NetworkMonitor {
    //MARK: Properties
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    var status: NWPath.Status = .requiresConnection
    var isReachable: Bool {
        status == .satisfied
    }
    
    //MARK: Init
    init() {
        startMonitoring()
    }
    
    //MARK: Helpers
    private func startMonitoring() {
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            
            self.status = path.status
            
        }
    
        monitor.start(queue: .global(qos: .background))
        
    }
    
    func stopMonitoring() {
        
        monitor.cancel()
        
    }
    
}
