//
//  NewsListPresenter.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsListPresentationLogic {
    func presentData(response: NewsList.Model.Response.ResponseType)
}

class NewsListPresenter: NewsListPresentationLogic {
    
    weak var viewController: NewsListDisplayLogic?
    let dateFormatManager = DateFormatManager()
    
    func presentData(response: NewsList.Model.Response.ResponseType) {
        switch response {
        case .presentNewsList(responseModels: let responseModels):
            let viewModels = convert(from: responseModels)
            viewController?.displayData(viewModel: .displayNewsList(models: viewModels))
        case .presentError(error: let error):
            viewController?.displayData(viewModel: .displayError(error: error))
        case .presentNewsListWithNewSource(responseModels: let responseModels, let source):
            let viewModels = convert(from: responseModels)
            viewController?.displayData(viewModel: .displayNewsListWithNewSource(models: viewModels, source))
        }
    }
}

// MARK: Convert from Response Model to View Model
private extension NewsListPresenter {
    func convert(from response: [ResponseNewsModel]) -> [NewsListViewModel.NewsListModel] {
        return response.map {
            let names = UserSettings.shared.getViewedNewsNames()
            let title = ($0.title ?? "").withoutHtml
            let viewed: Bool = names.contains(title)
            let description = ($0.description ?? "").withoutHtml
            let formatedDate = dateFormatManager.convertDate(from: $0.date ?? "")
            return NewsListViewModel.NewsListModel(title: title, date: formatedDate, description: description,viewed: viewed) }
    }
}
