//
//  DependencyListView.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import SwiftUI

struct DependencyListView: View {
    @State var appName = ""
    private var libraries = Library.libraries

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("acknowledgments\(appName)", bundle: .module)
                ForEach(libraries) { library in
                    Divider()
                    LibraryView(library: library)
                }
            }
            .padding(20)
        }
        .frame(
            minWidth: 500,
            idealWidth: 500,
            maxWidth: 700,
            minHeight: 400,
            idealHeight: 400,
            maxHeight: 700,
            alignment: .leading
        )
        .onAppear {
            let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            appName = bundleName ?? String(localized: "unknownApp", bundle: .module)
        }
    }
}

#Preview {
    DependencyListView()
}
