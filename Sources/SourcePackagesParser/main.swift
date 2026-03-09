//
//  main.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import ArgumentParser

struct Entry: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "source-packages-parser",
        abstract: "A tool to parse workspace-state.json and output a dependency list.",
        version: "1.0.0"
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
        try SourcePackagesParser(outputPath, sourcePackagesPath).run()
    }
}

Entry.main()
