//
//  LibraryView.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import SwiftUI

public struct LibraryView: View {
    @State private var showDetail = false
    @State private var attributedLicenseBody = AttributedString(stringLiteral: "")
    public var library: Library

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(library.name)
                .font(.title)
            Button {
                if let url = URL(string: library.repositoryURL) {
                    NSWorkspace.shared.open(url)
                }
            } label: {
                Text(library.repositoryURL)
            }
            .buttonStyle(.link)
            Toggle(isOn: $showDetail) {
                EmptyView()
            }
            .toggleStyle(DetailToggleStyle(licenseType: library.licenseType))
            .labelsHidden()
            if showDetail {
                ScrollView(.horizontal) {
                    Text(attributedLicenseBody)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
        }
        .onAppear {
            attributedLicenseBody = attribute(library.licenseBody)
        }
    }

    private func attribute(_ inputText: String) -> AttributedString {
        var attributedText = AttributedString(inputText)
        let urls: [URL?] = inputText.match(URL.regexPattern)
            .map { URL(string: String(inputText[$0])) }
        let ranges = attributedText.match(URL.regexPattern)
        for case (let range, let url?) in zip(ranges, urls) {
            attributedText[range].link = url
        }
        return attributedText
    }
}
