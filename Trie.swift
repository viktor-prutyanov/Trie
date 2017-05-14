class TrieNode<T: Equatable> {
    var value: T
    var children: [TrieNode<T>]

    var isLeaf: Bool {
        return children.count == 0
    }

    init(value: T) {
        self.value = value
        self.children = []
    }

    func findChildBy(val: T) -> TrieNode? {
        for node in children {
            if (node.value == val) {
                return node
            }
        }
        return nil
    }

    func addChild(node: TrieNode) {
        children.append(node)
    }

    func addChild(val: T) -> TrieNode {
        let newNode = TrieNode<T>(value: val)
        self.addChild(node: newNode)
        return newNode
    }

    func addUniqueChild(val: T) -> TrieNode {
        for node in children {
            if (node.value == val) {
                return node
            }
        }
        return addChild(val: val)
    }
}

class WordTrie {
    private var root: TrieNode<Character>

    init() {
        self.root = TrieNode(value: "_")
    }

    func add(word: String) {
        var currentNode = root
        for char in word.lowercased().characters {
            let nextNode = currentNode.addUniqueChild(val: char)
            currentNode = nextNode
        }
    }

    func findNodeByPrefix(word: String) -> TrieNode<Character>? {
        var currentNode = root
        for char in word.lowercased().characters {
            if let nextNode = currentNode.findChildBy(val: char) {
                currentNode = nextNode
            } else {
                return nil
            }
        }
        return currentNode
    }
    
    func findCompletions(word: String) -> [String] {
        var result: [String] = []
        if let subRoot = findNodeByPrefix(word: word) {
            WordTrie.subFind(root: subRoot, wordPrefix: word, wordSuffix: "", result: &result)
        }
        return result
    }

    private static func subFind(root: TrieNode<Character>, wordPrefix: String, wordSuffix: String, result: inout [String]) {
        if root.isLeaf {
            result.append(wordPrefix + wordSuffix)
        } else {
            for node in root.children {
                let nextWordSuffix : String = wordSuffix + String(node.value)
                subFind(root: node, wordPrefix: wordPrefix, wordSuffix: nextWordSuffix, result: &result)
            }
        }
    }
}