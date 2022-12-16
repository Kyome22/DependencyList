//
//  SwiftTree.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

struct SwiftTree {
    enum RuledLine {
        static let root       = "."
        static let stem       = "│  "
        static let branch     = "├──"
        static let lastBranch = "└──"
        static let space      = "   "
    }

    enum Parent {
        case none
        case array
        case dictionary
    }

    static func print(_ obj: Any?) {
        let output = SwiftTree.makeTree(obj: obj).joined(separator: "\n")
        Swift.print(output)
    }

    private static func makeTree(
        obj: Any?,
        parent: Parent = .none,
        isLast: Bool = false,
        prefix: [String] = []
    ) -> [String] {
        var result = [String]()
        if let dict = obj as? [String: Any?] { // Dictionay
            let array: [(key: String, value: Any?)] = dict.sorted { $0.key < $1.key }
            if parent == .array, array.count == 1, let first = array.first {
                result.append(contentsOf: makeTree(obj: first.key,
                                                   parent: .array,
                                                   isLast: isLast,
                                                   prefix: prefix))
                let valuePrefix = prefix + [isLast ? RuledLine.space : RuledLine.stem]
                result.append(contentsOf: makeTree(obj: first.value,
                                                   parent: .dictionary,
                                                   isLast: true,
                                                   prefix: valuePrefix))
            } else {
                if parent == .none {
                    result.append(RuledLine.root)
                } else if parent == .array {
                    result.append(contentsOf: makeTree(obj: RuledLine.root,
                                                       parent: .array,
                                                       isLast: isLast,
                                                       prefix: prefix))
                }
                for i in (0 ..< array.count) {
                    let isLastValue: Bool = (i == array.count - 1)
                    var keyPrefix = prefix
                    if parent == .array {
                        keyPrefix.append(isLast ? RuledLine.space : RuledLine.stem)
                    }
                    result.append(contentsOf: makeTree(obj: array[i].key,
                                                       parent: .dictionary,
                                                       isLast: isLastValue,
                                                       prefix: keyPrefix))
                    let valuePrefix = keyPrefix + [isLastValue ? RuledLine.space : RuledLine.stem]
                    result.append(contentsOf: makeTree(obj: array[i].value,
                                                       parent: .dictionary,
                                                       isLast: true,
                                                       prefix: valuePrefix))
                }
            }
        } else if let array = obj as? [Any?] { // Array
            if array.isEmpty {
                let isLastValue: Bool = (parent == .dictionary ? true : isLast)
                result.append(contentsOf: makeTree(obj: "empty",
                                                   parent: .array,
                                                   isLast: isLastValue,
                                                   prefix: prefix))
            } else if parent == .array, array.count == 1, let first = array.first {
                result.append(contentsOf: makeTree(obj: first,
                                                   parent: .array,
                                                   isLast: isLast,
                                                   prefix: prefix))
            } else {
                if parent == .none {
                    result.append(RuledLine.root)
                } else if parent == .array {
                    result.append(contentsOf: makeTree(obj: RuledLine.root,
                                                       parent: .array,
                                                       isLast: isLast,
                                                       prefix: prefix))
                }
                for i in (0 ..< array.count) {
                    let isLastValue: Bool = i == (array.count - 1)
                    var valuePrefix = prefix
                    if parent == .array {
                        valuePrefix.append(isLast ? RuledLine.space : RuledLine.stem)
                    }
                    result.append(contentsOf: makeTree(obj: array[i],
                                                       parent: .array,
                                                       isLast: isLastValue,
                                                       prefix: valuePrefix))
                }
            }
        } else { // Element
            let valuePrefix = prefix + [isLast ? RuledLine.lastBranch : RuledLine.branch]
            let line = (valuePrefix + ["\(obj ?? "nil")"]).joined(separator: " ")
            result.append(line)
        }
        return result
    }
}
