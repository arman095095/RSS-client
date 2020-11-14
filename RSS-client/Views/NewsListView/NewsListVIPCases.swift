//
//  NewsListVIPCases.swift
//  RSS-client
//
//  Created by Arman Davidoff on 12.11.2020.
//

import Foundation

enum NewsList {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsList(_: NewsListViewModel.NewsFeedSource)
                case getNewsListWithNewSource(_: NewsListViewModel.NewsFeedSource)
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsList(responseModels: [ResponseNewsModel])
                case presentNewsListWithNewSource(responseModels: [ResponseNewsModel], _: NewsListViewModel.NewsFeedSource)
                case presentError(error: String)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsList(models: [NewsListViewModel.NewsListModel])
                case displayNewsListWithNewSource(models: [NewsListViewModel.NewsListModel], _: NewsListViewModel.NewsFeedSource)
                case displayError(error: String)
            }
        }
    }
    
}
