import Foundation
struct SearchFilmResponse : Codable {
	let docs : [Film]?
	let total : Int?
	let limit : Int?
	let page : Int?
	let pages : Int?

	enum CodingKeys: String, CodingKey {

		case docs = "docs"
		case total = "total"
		case limit = "limit"
		case page = "page"
		case pages = "pages"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		docs = try values.decodeIfPresent([Film].self, forKey: .docs)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
		limit = try values.decodeIfPresent(Int.self, forKey: .limit)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		pages = try values.decodeIfPresent(Int.self, forKey: .pages)
	}

}
