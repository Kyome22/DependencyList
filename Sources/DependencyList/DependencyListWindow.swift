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
        title = String(localized: "licenses", bundle: .module)
        titlebarAppearsTransparent = true
        hasShadow = true
        contentView = NSHostingView(rootView: DependencyListView())
    }

    override public var canBecomeKey: Bool { true }

    override public var canBecomeMain: Bool { true }

    override public func cancelOperation(_ sender: Any?) { close() }
}
