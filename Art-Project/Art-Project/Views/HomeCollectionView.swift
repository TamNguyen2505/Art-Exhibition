//
//  HomeCollectionView.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import UIKit

protocol HomeCollectionViewDelegate: AnyObject {
    
    func didTapOnImage(from: HomeCollectionView, withImage: UIImage)
    
}

class HomeCollectionView: UICollectionViewCell {
    //MARK: Properties
    private let artImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "signup-background")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var tapOnImage: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventFromTapOnImage(_:)))
        return tap
    }()
    
    weak var delegate: HomeCollectionViewDelegate?
    
    //MARK: View cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func handleEventFromTapOnImage(_ sender: UITapGestureRecognizer) {
        
        guard let image = artImageView.image else {return}
        
        delegate?.didTapOnImage(from: self, withImage: image)
        
    }
    
    //MARK: Helpers
    private func setupUI() {
                        
        contentView.addSubview(artImageView)
        artImageView.snp.makeConstraints{ make in
        
            make.edges.equalToSuperview().inset(5)
                        
        }
         
        artImageView.addGestureRecognizer(tapOnImage)
        
    }
    
    func setupImage(image: UIImage?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            
            self.artImageView.image = image
            
        }
                
    }
    
}
