import Foundation
struct Logo : Codable {
	let url : String?

	enum CodingKeys: String, CodingKey {

		case url = "url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}
