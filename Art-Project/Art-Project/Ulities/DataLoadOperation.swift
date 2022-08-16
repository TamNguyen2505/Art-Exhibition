//
//  DataLoadOperation.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 25/06/2022.
//

import UIKit

class DataLoadOperation: AsyncOperation {
    //MARK: Properties
    var image: UIImage?
    private let url: URL
    private var downloadTask: URLSessionDownloadTask?
    
    //MARK: Init
    init(url: URL) {
        
        self.url = url
        
    }
    
    convenience init?(url: String) {
        
        guard let url = URL(string: url) else {return nil}
        
        self.init(url: url)
        
    }
    
    override func main() {
        super.main()
        if isCancelled {return}
                
        let session = URLSession.shared
        downloadTask = session.downloadTask(with: url) { [weak self] url, response, error in
            guard error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data), let self = self else {return}
            defer { self.state = .finished }
            
            self.image = image
                
        }
        
        downloadTask?.resume()
        
    }
    
}

