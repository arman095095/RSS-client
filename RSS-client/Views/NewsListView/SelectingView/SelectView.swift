//
//  SelectView.swift
//  Exschange
//
//  Created by Arman Davidoff on 26.10.2020.
//


import UIKit

protocol PresentTableViewProtocol: class {
    func addToSubview(_ view: UIView)
    func didSelect(source: NewsListViewModel.NewsFeedSource)
}

class SelectView: UIView {
    
    var sourcesModels: [NewsListViewModel.NewsFeedSource] {
        return UserSettings.shared.getNewsFeedSources()
    }
    var tableView = UITableView()
    var listButton = SourceButton()
    
    weak var delegate: PresentTableViewProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect,delegate: PresentTableViewProtocol) {
        self.init(frame: frame)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configure(source: sourcesModels.first!)
        setupListButton()
        setupTableView()
        backgroundColor = .white
    }
    
    func reloadList() {
        tableView.reloadData()
    }
    
    func setButtonTitle(source: NewsListViewModel.NewsFeedSource) {
        listButton.config(sourceName: source.userNamed)
    }

    func configure(source: NewsListViewModel.NewsFeedSource) {
        listButton.config(sourceName: source.userNamed)
        delegate.didSelect(source: source)
        tableView.isHidden = true
    }
}

// MARK: Setup UI
private extension SelectView {
    
    func setupListButton() {
        let frameForButton = CGRect(x: self.frame.width / 2 - ButtonSize.width.rawValue / 2, y: self.frame.height / 2 - ButtonSize.height.rawValue / 2, width: ButtonSize.width.rawValue, height: ButtonSize.height.rawValue)
        listButton.frame = frameForButton
        self.addSubview(listButton)
        listButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTableView)))
    }
        
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = CGRect(x: listButton.frame.origin.x, y: 0, width: listButton.frame.width, height: 0)
        delegate.addToSubview(tableView)
        tableView.isHidden = true
        tableView.layer.cornerRadius = TableViewSizes.cornerRadius.rawValue
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .systemGray6
    }
    
    @objc func showTableView() {
        tableView.isHidden.toggle()
        tableView.frame.size.height = CGFloat(tableView.numberOfRows(inSection: 0)) * TableViewSizes.rowHeight.rawValue
    }
}

// MARK: TableViewDelegate & DataSource
extension SelectView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = sourcesModels[indexPath.row]
        cell.textLabel?.text = model.userNamed
        cell.backgroundColor = tableView.backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewSizes.rowHeight.rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sourcesModels[indexPath.row]
        self.configure(source: model)
    }
}
