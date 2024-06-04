import Foundation
struct Rating : Codable {
	let kp : Double?
	let imdb : Double?
	let filmCritics : Double?
	let russianFilmCritics : Double?
	let await_ : String?

	enum CodingKeys: String, CodingKey {

		case kp = "kp"
		case imdb = "imdb"
		case filmCritics = "filmCritics"
		case russianFilmCritics = "russianFilmCritics"
		case await_ = "await"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		kp = try values.decodeIfPresent(Double.self, forKey: .kp)
		imdb = try values.decodeIfPresent(Double.self, forKey: .imdb)
		filmCritics = try values.decodeIfPresent(Double.self, forKey: .filmCritics)
		russianFilmCritics = try values.decodeIfPresent(Double.self, forKey: .russianFilmCritics)
		await_ = try values.decodeIfPresent(String.self, forKey: .await_)
	}

}
