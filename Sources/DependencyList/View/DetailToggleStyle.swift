//
//  DetailToggleStyle.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import SwiftUI

struct DetailToggleStyle: ToggleStyle {
    var licenseType: String

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            Image(systemName: "triangle.fill")
                .font(.callout)
                .rotationEffect(Angle(degrees: configuration.isOn ? 180 : 90))
            Text(licenseType)
                .font(.headline)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                configuration.isOn.toggle()
            }
        }
    }
}
