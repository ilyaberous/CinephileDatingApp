import Foundation


struct Film : Codable {
	let id : Int?
	let name : String?
	let alternativeName : String?
	let enName : String?
	let type : String?
	let year : Int?
	let description : String?
	let shortDescription : String?
	let movieLength : Int?
	let isSeries : Bool?
	let ticketsOnSale : Bool?
	let totalSeriesLength : Int?
	let seriesLength : Int?
	let ratingMpaa : String?
	let ageRating : Int?
	let top10 : Int?
	let top250 : Int?
	let typeNumber : Int?
	let status : String?
	let names : [Names]?
	let externalId : ExternalId?
	let logo : Logo?
	let poster : Poster?
	let backdrop : Backdrop?
	let rating : Rating?
	let votes : Votes?
	let genres : [Genres]?
	let countries : [Countries]?
	let releaseYears : [Release]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case alternativeName = "alternativeName"
		case enName = "enName"
		case type = "type"
		case year = "year"
		case description = "description"
		case shortDescription = "shortDescription"
		case movieLength = "movieLength"
		case isSeries = "isSeries"
		case ticketsOnSale = "ticketsOnSale"
		case totalSeriesLength = "totalSeriesLength"
		case seriesLength = "seriesLength"
		case ratingMpaa = "ratingMpaa"
		case ageRating = "ageRating"
		case top10 = "top10"
		case top250 = "top250"
		case typeNumber = "typeNumber"
		case status = "status"
		case names = "names"
		case externalId = "externalId"
		case logo = "logo"
		case poster = "poster"
		case backdrop = "backdrop"
		case rating = "rating"
		case votes = "votes"
		case genres = "genres"
		case countries = "countries"
		case releaseYears = "releaseYears"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		alternativeName = try values.decodeIfPresent(String.self, forKey: .alternativeName)
		enName = try values.decodeIfPresent(String.self, forKey: .enName)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		year = try values.decodeIfPresent(Int.self, forKey: .year)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)
		movieLength = try values.decodeIfPresent(Int.self, forKey: .movieLength)
		isSeries = try values.decodeIfPresent(Bool.self, forKey: .isSeries)
		ticketsOnSale = try values.decodeIfPresent(Bool.self, forKey: .ticketsOnSale)
		totalSeriesLength = try values.decodeIfPresent(Int.self, forKey: .totalSeriesLength)
		seriesLength = try values.decodeIfPresent(Int.self, forKey: .seriesLength)
		ratingMpaa = try values.decodeIfPresent(String.self, forKey: .ratingMpaa)
		ageRating = try values.decodeIfPresent(Int.self, forKey: .ageRating)
		top10 = try values.decodeIfPresent(Int.self, forKey: .top10)
		top250 = try values.decodeIfPresent(Int.self, forKey: .top250)
		typeNumber = try values.decodeIfPresent(Int.self, forKey: .typeNumber)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		names = try values.decodeIfPresent([Names].self, forKey: .names)
		externalId = try values.decodeIfPresent(ExternalId.self, forKey: .externalId)
		logo = try values.decodeIfPresent(Logo.self, forKey: .logo)
		poster = try values.decodeIfPresent(Poster.self, forKey: .poster)
		backdrop = try values.decodeIfPresent(Backdrop.self, forKey: .backdrop)
		rating = try values.decodeIfPresent(Rating.self, forKey: .rating)
		votes = try values.decodeIfPresent(Votes.self, forKey: .votes)
		genres = try values.decodeIfPresent([Genres].self, forKey: .genres)
		countries = try values.decodeIfPresent([Countries].self, forKey: .countries)
		releaseYears = try values.decodeIfPresent([Release].self, forKey: .releaseYears)
	}

}

struct Release: Codable {
    let start: Int?
    let end: Int?
}
