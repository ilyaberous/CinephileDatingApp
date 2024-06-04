import Foundation
struct ExternalId : Codable {
	let imdb : String?
	let tmdb : Int?
	let kpHD : String?

	enum CodingKeys: String, CodingKey {

		case imdb = "imdb"
		case tmdb = "tmdb"
		case kpHD = "kpHD"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		imdb = try values.decodeIfPresent(String.self, forKey: .imdb)
		tmdb = try values.decodeIfPresent(Int.self, forKey: .tmdb)
		kpHD = try values.decodeIfPresent(String.self, forKey: .kpHD)
	}

}
