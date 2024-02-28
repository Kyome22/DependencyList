//
//  DependencyListView.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import SwiftUI

struct DependencyListView<DVM: DependencyListViewModel>: View {
    @StateObject var viewModel: DVM

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("acknowledgments\(viewModel.appName)", bundle: .module)
                ForEach(viewModel.libraries) { library in
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
    }
}

#Preview {
    DependencyListView(viewModel: DependencyListViewModelPreviewMock())
}
