// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let video = try Video(json)

import Foundation


enum DownloadStatus: String, Codable {
    case Download
    case Downloading
    case Downloaded
}

// MARK: - Video
class Video: Codable {
    var id: Int?
    var videoDescription: String?
    var sources: [String]?
    var subtitle: String?
    var thumb, title: String?
    var isDownloadingProcess: DownloadStatus = .Download

    enum CodingKeys: String, CodingKey {
        case id
        case videoDescription = "description"
        case sources, subtitle, thumb, title
    }

    init(id: Int?, videoDescription: String?, sources: [String]?, subtitle: String?, thumb: String?, title: String?) {
        self.id = id
        self.videoDescription = videoDescription
        self.sources = sources
        self.subtitle = subtitle
        self.thumb = thumb
        self.title = title
    }
    
    func getMediaUrl() -> URL? {
        let mediaUrlString = self.sources?.first ?? ""
        let url = URL(string: mediaUrlString)
        let mediaLastComponent = url?.lastPathComponent ?? "\(UUID().uuidString).mp4"
        
        if self.isDownloadingProcess == .Downloaded {
            var documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            documentsPathURL = documentsPathURL?.appending(component: mediaLastComponent)
            return documentsPathURL
        }else{
            return URL(string: mediaUrlString)
        }
    }
}

// MARK: Video convenience initializers and mutators

extension Video {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Video.self, from: data)
        self.init(id: me.id, videoDescription: me.videoDescription, sources: me.sources, subtitle: me.subtitle, thumb: me.thumb, title: me.title)
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
        id: Int?? = nil,
        videoDescription: String?? = nil,
        sources: [String]?? = nil,
        subtitle: String?? = nil,
        thumb: String?? = nil,
        title: String?? = nil
    ) -> Video {
        return Video(
            id: id ?? self.id,
            videoDescription: videoDescription ?? self.videoDescription,
            sources: sources ?? self.sources,
            subtitle: subtitle ?? self.subtitle,
            thumb: thumb ?? self.thumb,
            title: title ?? self.title
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


extension Int64 {
    func covertToFileString() -> (str: String,size: Double) {
        var convertedValue: Double = Double(self)
        var multiplyFactor = 0
        let tokens = ["B", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue >= 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return (str: String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor]),size:convertedValue)
    }
}

extension URL {
    func getFileSize() -> Int64? {
        do {
            let resources = try self.resourceValues(forKeys:[.fileSizeKey])
            let fileSize: Int64 = Int64(resources.fileSize ?? 0)
            print ("\(fileSize)")
            return fileSize
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
