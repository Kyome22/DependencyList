//
//  DependencyListWindow.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import AppKit
import SwiftUI

public class DependencyListWindow: NSWindow {
    public init() {
        super.init(
            contentRect: .zero,
            styleMask: [.closable, .resizable, .titled],
            backing: .buffered,
            defer: false
        )
        self.title = String(localized: "licenses", bundle: .module)
        self.titlebarAppearsTransparent = true
        self.hasShadow = true
        let dependencyListViewModel = DependencyListViewModelImpl()
        let dependencyListView = DependencyListView(viewModel: dependencyListViewModel)
        self.contentView = NSHostingView(rootView: dependencyListView)
    }

    public override func cancelOperation(_ sender: Any?) {
        self.close()
    }
}
