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
    public let libraries = Library.libraries
    public let appName: String

    public required init(bundle: Bundle = Bundle.main) {
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
