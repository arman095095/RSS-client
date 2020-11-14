//
//  NewsListViewController.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation

protocol NewsListDisplayLogic: class {
    func displayData(viewModel: NewsList.Model.ViewModel.ViewModelData)
}

class NewsListViewController: UIViewController, NewsListDisplayLogic {
    
    var interactor: NewsListBusinessLogic?
    var tableView: UITableView!
    var selectingView: SelectView!
    var activityIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(getNewsListRefresh), for: .valueChanged)
        return refresh
    }()
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsListInteractor()
        let presenter             = NewsListPresenter()
        viewController.interactor = interactor
        interactor.presenter      = presenter
        presenter.viewController  = viewController
    }
    
    // MARK: View lifecycle
    
    var newsListViewModel: NewsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setupSelectingView()
        setupActivityIndicator()
        setupBarButtonItem()
        DispatchQueue.main.async {
            self.setupViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func displayData(viewModel: NewsList.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewsList(models: let models):
            newsListViewModel.updateModels(models: models)
            updateUI()
        case .displayNewsListWithNewSource(models: let models, let source):
            newsListViewModel.addNewSource(source: source)
            newsListViewModel.updateModels(models: models)
            updateUI(with: source)
        case .displayError(error: let error):
            updateUI(with: error)
        }
    }
}

// MARK: Get NewsList Type
private extension NewsListViewController {
    @objc func getNewsListRefresh() {
        guard let source = newsListViewModel.currentSource else { return }
        interactor?.makeRequest(request: .getNewsList(source))
    }
    
    func getNewsListSelected(with source: NewsListViewModel.NewsFeedSource) {
        newsListViewModel.currentSource = source
        newsListViewModel.updateModels(models: [])
        tableView.reloadData()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        interactor?.makeRequest(request: .getNewsList(source))
    }
    
    func getNewsListNew(with newSource: NewsListViewModel.NewsFeedSource) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        interactor?.makeRequest(request: .getNewsListWithNewSource(newSource))
    }
}

// MARK: Updating UI
private extension NewsListViewController {
    
    func updateUI(with newSource: NewsListViewModel.NewsFeedSource) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            self.selectingView.reloadList()
            self.selectingView.setButtonTitle(source: newSource)
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            self.selectingView.reloadList()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func updateUI(with error: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
                self.createAlert(message: error)
            }
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.id, for: indexPath) as! NewsListCell
        let model = newsListViewModel.model(at: indexPath)
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = newsListViewModel.checkModel(at: indexPath)
        let vc = Builder.newsDetailVc(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UI Setup
private extension NewsListViewController {
    
    func setupTableView() {
        tableView = UITableView(frame: .zero)
        tableView.register(NewsListCell.self, forCellReuseIdentifier: NewsListCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupSelectingView() {
        selectingView = SelectView(frame: .zero, delegate: self)
        selectingView.reloadList()
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
    }
    
    @objc func presentAlert() {
        let alert = UIAlertController(title: "Добавление RSS-канала", message: "Введите URL канала", preferredStyle: .alert)
        alert.addTextField(configurationHandler:  {
            $0.placeholder = "Пользовательское имя для канала"
            $0.tag = 2
        })
        alert.addTextField(configurationHandler:  {
            $0.placeholder = "Введите URL канала"
            $0.tag = 1
        })
        let okAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            guard let textFields = alert.textFields else { return }
            let source = NewsListViewModel.NewsFeedSource(url: "", userNamed: "")
            textFields.forEach {
                guard let text = $0.text else { return }
                switch $0.tag {
                case 1:
                    source.url = text
                case 2:
                    source.userNamed = text
                default: break
                }
            }
            self.getNewsListNew(with: source)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setupBarButtonItem() {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAlert))
        navigationItem.setRightBarButtonItems([item], animated: true)
    }
    
    func setupViews() {
        overrideUserInterfaceStyle = .light
        title = "News List"
        view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
        self.tableView.addSubview(refreshControl)
        self.view.addSubview(selectingView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        selectingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            selectingView.topAnchor.constraint(equalTo: view.topAnchor,constant: self.topBarHeight),
            selectingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectingView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: selectingView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: PresentTableViewProtocol
extension NewsListViewController: PresentTableViewProtocol {
    func addToSubview(_ view: UIView) {
        DispatchQueue.main.async {
            self.view.addSubview(view)
            view.frame.origin.y = self.selectingView.frame.maxY
        }
    }
    
    func didSelect(source: NewsListViewModel.NewsFeedSource) {
        getNewsListSelected(with: source)
    }
}
