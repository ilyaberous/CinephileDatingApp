import Foundation
struct Votes : Codable {
	let kp : Int?
	let imdb : Int?
	let filmCritics : Int?
	let russianFilmCritics : Int?
	let await_ : Int?

	enum CodingKeys: String, CodingKey {

		case kp = "kp"
		case imdb = "imdb"
		case filmCritics = "filmCritics"
		case russianFilmCritics = "russianFilmCritics"
		case await_ = "await"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		kp = try values.decodeIfPresent(Int.self, forKey: .kp)
		imdb = try values.decodeIfPresent(Int.self, forKey: .imdb)
		filmCritics = try values.decodeIfPresent(Int.self, forKey: .filmCritics)
		russianFilmCritics = try values.decodeIfPresent(Int.self, forKey: .russianFilmCritics)
		await_ = try values.decodeIfPresent(Int.self, forKey: .await_)
	}

}
