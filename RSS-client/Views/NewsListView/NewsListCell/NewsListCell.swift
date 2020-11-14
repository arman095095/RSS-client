//
//  NewsListCell.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//

import UIKit

protocol NewsListCellModelType {
    var title: String { get }
    var date: String { get }
    var viewed: Bool { set get }
}

class NewsListCell: UITableViewCell {
    
    static let id = "NewsListCell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.italicSystemFont(ofSize: 14)
        return label
    }()
    var stackView: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstreints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: NewsListCellModelType) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        self.backgroundColor = model.viewed ? #colorLiteral(red: 1, green: 1, blue: 0.7554045377, alpha: 1) : .white
    }
}

// MARK: Setup UI
private extension NewsListCell {
    
    func setupViews() {
        stackView = UIStackView(arrangedSubviews: [titleLabel,dateLabel])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
    }
    
    func setupConstreints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}
