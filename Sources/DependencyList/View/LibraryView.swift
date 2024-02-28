//
//  File.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import SwiftUI

public struct LibraryView: View {
    @State private var showDetail: Bool = false
    public let library: Library

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(library.name)
                .font(.title)
            hyperLinkText(library.repositoryURL)
            Toggle("", isOn: $showDetail)
                .toggleStyle(DetailToggleStyle(licenseType: library.licenseType))
            if showDetail {
                ScrollView(.horizontal) {
                    VStack(spacing: 0) {
                        ForEach(library.sentences) { sentence in
                            if sentence.isHyperLink {
                                hyperLinkText(sentence.body)
                            } else {
                                Text(sentence.body)
                                    .font(.body)
                            }
                        }
                    }
                }
            }
        }
    }

    private func hyperLinkText(_ linkText: String) -> some View {
        Button {
            if let url = URL(string: linkText) {
                NSWorkspace.shared.open(url)
            }
        } label: {
            Text(linkText)
                .font(.body)
        }
        .buttonStyle(.link)
    }
}
