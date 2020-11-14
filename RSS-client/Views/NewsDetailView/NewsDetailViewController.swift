//
//  NewsDetailView.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//

import UIKit

protocol NewsDetailViewModelType {
    var title: String { get }
    var date: String { get }
    var description: String { get }
}

class NewsDetailViewController: UIViewController {
    
    var stackView: UIStackView!
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 26)
        return label
    }()
    var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.italicSystemFont(ofSize: 18)
        return label
    }()
    var descriptionLabel: UITextView = {
        let label = UITextView()
        label.showsVerticalScrollIndicator = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.isEditable = false
        label.font = UIFont.italicSystemFont(ofSize: 16)
        return label
    }()
    
    init(model: NewsDetailViewModelType) {
        super.init(nibName: nil, bundle: nil)
        configure(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupViews()
        setupConstreints()
    }
    
    private func configure(model: NewsDetailViewModelType) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        descriptionLabel.text = model.description
    }
    
}

// MARK: UI Setup
private extension NewsDetailViewController {
    
    func setupViews() {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        stackView = UIStackView(arrangedSubviews: [titleLabel,dateLabel])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        self.view.addSubview(descriptionLabel)
    }
    
    func setupConstreints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 12)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12),
            descriptionLabel.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15 )
        ])
    }
}
