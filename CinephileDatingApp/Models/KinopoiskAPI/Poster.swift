import Foundation
struct Poster : Codable {
	let url : String?
	let previewUrl : String?

	enum CodingKeys: String, CodingKey {

		case url = "url"
		case previewUrl = "previewUrl"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		previewUrl = try values.decodeIfPresent(String.self, forKey: .previewUrl)
	}

}
