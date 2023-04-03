//
//  Cell.swift
//  m15
//
//  Created by Nursultan Konspayev on 25.03.2023.
//

import SnapKit
import UIKit

//MARK: - Creating cell components
class Cell: UITableViewCell {
    static let identifier = "Cell"
    
    private let block: UILabel = {
        let block = UILabel()
        block.backgroundColor = Constants.Color.Gray02
        block.contentMode = .scaleAspectFill
        block.clipsToBounds = true
        block.layer.cornerRadius = 8
        return block
    }()
    
    private let header: UILabel = {
        let header = UILabel()
        header.text = Constants.Text.header
        header.textColor = Constants.Color.BW
        header.font = Constants.Font.header
        return header
    }()
    
    private let text: UILabel = {
        let text = UILabel()
        text.text = Constants.Text.text
        text.textColor = Constants.Color.BW
        text.font = Constants.Font.text
        text.numberOfLines = 0
        return text
    }()
    
    private let ago: UILabel = {
        let ago = UILabel()
        ago.text = Constants.Text.ago
        ago.textColor = Constants.Color.Gray01
        ago.font = Constants.Font.ago
        return ago
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(block)
        contentView.addSubview(header)
        contentView.addSubview(text)
        contentView.addSubview(ago)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//MARK: - Using SnapKit for AutoLayout
        block.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(50)
        }
    
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(block.snp.right).offset(16)
            make.width.equalTo(57)
            make.height.equalTo(19)
        }
        
        text.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(8)
            make.left.equalTo(block.snp.right).offset(16)
            make.width.equalTo(264)
            make.height.equalTo(34)
        }
        
        ago.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalTo(header.snp.right).offset(170)
            make.width.equalTo(50)
            make.height.equalTo(17)
        }
    }
}
