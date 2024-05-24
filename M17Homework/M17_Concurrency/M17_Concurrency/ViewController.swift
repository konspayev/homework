//
//  ViewController.swift
//  M17_Concurrency
//
//  Created by Maxim NIkolaev on 08.12.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let service = Service()
     
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 140, height: 140))
        view.style = .large
        view.hidesWhenStopped = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.centerY.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        activityIndicator.startAnimating()
        onLoad()
    }

    private func onLoad() {
        let imageGroup = DispatchGroup()
        var images: [UIImage] = []
        
        for _ in 0..<5 {
            imageGroup.enter()
            self.service.getImageURL { urlString, error in
                guard let urlString = urlString else {
                    imageGroup.leave()
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    if let image = self.service.loadImage(urlString: urlString) {
                        images.append(image)
                    }
                    imageGroup.leave()
                }
            }
        }
        
        imageGroup.notify(queue: DispatchQueue.main) {
            self.activityIndicator.stopAnimating()
            self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for image in images {
                self.addImage(image: image)
            }
        }
    }
    
    private func addImage(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.stackView.addArrangedSubview(imageView)
    }
}

