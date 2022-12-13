// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let media = try Media(json)

import Foundation
import Alamofire

// MARK: - Media
class Media: Codable {
    var categories: [Category]?

    init(categories: [Category]?) {
        self.categories = categories
    }
}

// MARK: Media convenience initializers and mutators

extension Media {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Media.self, from: data)
        self.init(categories: me.categories)
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
        categories: [Category]?? = nil
    ) -> Media {
        return Media(
            categories: categories ?? self.categories
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// API CALLS
extension Media {
    class func getMediaDataAPI(completion: ((Media?,Error?)->())? ){
        
        var dicParam = [String: Any]()
        dicParam["id"] = "1FEOTw_ioZ4SR4Iq5UxqsqcEgKAg3bNtX"
        let url = "https://drive.google.com/uc"
        AF.request(url, method: .get, parameters: dicParam).responseDecodable(of: Media.self) { response in
            switch response.result {
            case .success(let mainResponse):
                
                if response.response?.statusCode == 200 {
                    completion?(mainResponse,nil)
                }else{
                    // Error
                    let error = NSError(domain:"", code: response.response?.statusCode ?? 404 , userInfo:[ NSLocalizedDescriptionKey: "Data not found." ]) as Error
                    completion?(nil,error)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil,error)
                break
            }
        }
    }
}

