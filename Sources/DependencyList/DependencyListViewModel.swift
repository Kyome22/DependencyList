//
//  DependencyListViewModel.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

public protocol DependencyListViewModel: ObservableObject {
    var libraries: [Library] { get }
    var appName: String { get }

    init(bundle: Bundle)
}

public class DependencyListViewModelImpl: DependencyListViewModel {
    public let libraries: [Library]
    public let appName: String

    public required init(bundle: Bundle = Bundle.main) {
        guard let url = bundle.url(forResource: "dependency-list", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let dict = plist as? [String: Any]
        else {
            libraries = []
            appName = "Unknown App"
            return
        }
        libraries = (dict["libraries"] as? [[String: Any]])?
            .compactMap({ library -> Library? in
                guard let name = library["name"] as? String,
                      let url = library["repositoryURL"] as? String,
                      let type = library["licenseType"] as? String,
                      let body = library["licenseBody"] as? String
                else {
                    return nil
                }
                return Library(name: name,
                               repositoryURL: url,
                               licenseType: type,
                               licenseBody: body)
            }) ?? []
        appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown App"
    }
}

// MARK: - Preview Mock
final class DependencyListViewModelPreviewMock: DependencyListViewModel {
    let libraries: [Library] = [Library.mock, Library.mock, Library.mock]
    let appName: String = "Mock"

    init(bundle: Bundle) {}
    init() {}
}
