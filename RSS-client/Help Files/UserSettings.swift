//
//  UserSettings.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//

import Foundation

class UserSettings {
    
    enum Keys: String {
        case viewedKey = "viewedNews"
        case sourcesKey = "sources"
    }
    
    static let shared = UserSettings()
    
    private init() {
        createFirstsSources()
    }
    
    func getViewedNewsNames() -> [String] {
        guard let names = UserDefaults.standard.value(forKey: Keys.viewedKey.rawValue) as? [String] else { return [] }
        return names
    }
    
    func saveNews(model: NewsListViewModel.NewsListModel) {
        var savedNames = getViewedNewsNames()
        savedNames.append(model.title)
        UserDefaults.standard.setValue(savedNames, forKey: Keys.viewedKey.rawValue)
    }
    
    func getNewsFeedSources() -> [NewsListViewModel.NewsFeedSource] {
        return getObjects(type: [NewsListViewModel.NewsFeedSource].self, key: Keys.sourcesKey.rawValue)
    }
    
    func createNewsFeedSource(source: NewsListViewModel.NewsFeedSource) {
        createObjectAndSave(model: source, key: Keys.sourcesKey.rawValue)
    }
}

private extension UserSettings {
    
    func createFirstsSources() {
        let sources = getNewsFeedSources()
        if sources.isEmpty {
            createNewsFeedSource(source: NewsListViewModel.NewsFeedSource(url: "https://www.finam.ru/net/analysis/conews/rsspoint", userNamed: "Finam"))
            createNewsFeedSource(source: NewsListViewModel.NewsFeedSource(url: "https://www.banki.ru/xml/news.rss", userNamed: "Banki.ru"))
        }
    }
    
    func getObjects<T:NSObject&NSCoding>(type: [T].Type, key: String) -> [T] {
        guard let savedData = UserDefaults.standard.object(forKey: key) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [T] else { return [] }
        return decodedModel
    }
    
    func createObjectAndSave<T:NSObject&NSCoding>(model: T, key: String) {
        var objects = getObjects(type: [T].self, key: key)
        objects.append(model)
        guard let savedData = try? NSKeyedArchiver.archivedData(withRootObject: objects, requiringSecureCoding: false) else { fatalError() }
        UserDefaults.standard.set(savedData, forKey: key)
    }
}
