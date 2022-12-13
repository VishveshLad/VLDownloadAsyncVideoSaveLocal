// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let category = try Category(json)

import Foundation

// MARK: - Category
class Category: Codable {
    var name: String?
    var videos: [Video]?

    init(name: String?, videos: [Video]?) {
        self.name = name
        self.videos = videos
    }
}

// MARK: Category convenience initializers and mutators

extension Category {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Category.self, from: data)
        self.init(name: me.name, videos: me.videos)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        name: String?? = nil,
        videos: [Video]?? = nil
    ) -> Category {
        return Category(
            name: name ?? self.name,
            videos: videos ?? self.videos
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
