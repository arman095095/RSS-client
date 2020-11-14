//
//  Builder.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//

import UIKit

class Builder {
    static func dataFetcher() -> NetworkDataFetcher {
        let network = NetworkServiceUS()
        let networkService = NetworkServiceUSAdapter(networkService: network)
        let dataFetcher = NetworkDataFetcher(networkService: networkService)
        return dataFetcher
    }
    
    static func newsDetailVc(model: NewsDetailViewModelType) -> NewsDetailViewController {
        let vc = NewsDetailViewController(model: model)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func mainWindow(scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        let vc = NewsListViewController()
        vc.newsListViewModel = NewsListViewModel.init(models: [])
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        return window
    }
}
