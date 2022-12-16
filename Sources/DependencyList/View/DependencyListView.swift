//
//  DependencyListView.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import SwiftUI

struct DependencyListView<DVM: DependencyListViewModel>: View {
    @StateObject private var viewModel: DVM

    init(viewModel: DVM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

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
        .frame(minWidth: 500,
               idealWidth: 500,
               maxWidth: 700,
               minHeight: 400,
               idealHeight: 400,
               maxHeight: 700,
               alignment: .leading)
    }
}

struct DependencyListView_Previews: PreviewProvider {
    static var previews: some View {
        DependencyListView(viewModel: DependencyListViewModelPreviewMock())
    }
}
