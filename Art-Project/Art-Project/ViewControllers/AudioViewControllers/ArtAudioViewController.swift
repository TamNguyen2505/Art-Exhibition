//
//  ArtAudioViewController.swift
//  TableGit
//
//  Created by MINERVA on 08/08/2022.
//

import UIKit
import AVFoundation

class ArtAudioViewController: BaseViewController {
    //MARK: Properties
    private let scrollView: UIScrollView = {
        let width = UIScreen.main.bounds.width
        let height = CGFloat.greatestFiniteMagnitude
        
        let view = UIScrollView()
        view.contentSize = CGSize(width: width, height: height)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let artImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 5.0
        iv.image = UIImage(named: "signup-background")
        return iv
    }()
    
    private let artTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .darkText
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let artDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "music"
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let arrowImage = UIImage(named: "next")?.rotate(radians: .pi/2)
    
    private lazy var arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = arrowImage
        return iv
    }()
    
    private let intervalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "label"
        return label
    }()
    
    private let remainderTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "label"
        return label
    }()
    
    private let audioSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    private lazy var backwardButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_orchadio_bacward_sec"), for: .normal)
        return btn
    }()
    
    private lazy var previousButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_orchadio_go_to_previous"), for: .normal)
        return btn
    }()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_orchadio_play"), for: .normal)
        return btn
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_orchadio_go_Next"), for: .normal)
        return btn
    }()
    
    private lazy var forwardButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_orchadio_go_forward_sec"), for: .normal)
        return btn
    }()
    
    private var audioPlayer: AVAudioPlayer?
        
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
            
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{ make in
            
            make.edges.width.equalToSuperview()
            
        }
        
        contentView.addSubview(artImageView)
        artImageView.snp.makeConstraints{ make in
            
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(200)
            
        }
        
        contentView.addSubview(artTitleLabel)
        artTitleLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(artImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            
        }
        
        contentView.addSubview(artDescriptionLabel)
        artDescriptionLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(artTitleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().inset(45)
            
        }
        
        contentView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints{ make in
            
            make.bottom.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(20)
            
        }
        
        let audioView = UIView()
        
        audioView.addSubview(intervalLabel)
        intervalLabel.snp.makeConstraints{ make in
            
            make.top.leading.equalToSuperview()
            
            
        }
        
        audioView.addSubview(remainderTimeLabel)
        remainderTimeLabel.snp.makeConstraints{ make in
            
            make.centerY.equalTo(intervalLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualTo(intervalLabel.snp.trailing)
            
        }
        
        audioView.addSubview(audioSlider)
        audioSlider.snp.makeConstraints{ make in
            
            make.top.equalTo(intervalLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
            
        }
        
        let hStackView = UIStackView(arrangedSubviews: [backwardButton, previousButton, playButton, nextButton, forwardButton])
        hStackView.axis = .horizontal
        hStackView.spacing = 10
        hStackView.alignment = .center
        hStackView.distribution = .fillProportionally
        
        audioView.addSubview(hStackView)
        hStackView.snp.makeConstraints{ make in
            
            make.top.equalTo(audioSlider.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            
        }
        
        view.addSubview(audioView)
        audioView.snp.makeConstraints{ make in
            
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
            
        }
        
        
    }
    
        
    
}
