
import Foundation

func getData() -> [String: Any] {
    guard let data = FileManager.default.contents(atPath: "/Users/srx147/Developer/Source/trelloExport/test.json") else { return [:] }
    return (try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)) as? [String: Any] ?? [:]
}

let cards: [[String: Any]] = getData()["cards"] as! [[String: Any]]

let strings: [(title: String, desc: String)] = cards.flatMap { card in
    guard let title = card["name"] as? String, let desc = card["desc"] as? String else { return nil }

    return (title, desc.replacingOccurrences(of: "\n", with: " "))
}

let combined = strings.reduce("Title,Address\n") { result, current in
    return result + "\"" + current.title + "\",\"" + current.desc + "\"\n"
}

let newData = combined.data(using: .utf8)
FileManager.default.createFile(atPath: "/Users/srx147/Developer/Source/trelloExport/attempt\(Date().description).csv", contents: newData, attributes: nil)
