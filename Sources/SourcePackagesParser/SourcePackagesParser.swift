//
//  SourcePackagesParser.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import ArgumentParser
import SourcePackagesParserKit

struct SourcePackagesParser: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "pbxproj-parser",
        abstract: "A tool to parse pbxproj and output a dependency plist.",
        version: "0.0.1"
    )

    @Option(
        name: [.customShort("o"), .customLong("output-path")],
        help: "Output path of the dependency-list.plist"
    )
    var outputPath: String

    @Option(
        name: [.customShort("s"), .customLong("source-packages-path")],
        help: "Path of the SourcePackages directory"
    )
    var sourcePackagesPath: String

    mutating func run() throws {
        try SPPMain().run(self.outputPath, self.sourcePackagesPath)
    }
}
