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
        commandName: "source-packages-parser",
        abstract: "A tool to parse workspace-state.json and output a dependency list.",
        version: "0.0.1"
    )

    @Option(
        name: [.customShort("o"), .customLong("output-path")],
        help: "Output path of the DependencyList.swift"
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
