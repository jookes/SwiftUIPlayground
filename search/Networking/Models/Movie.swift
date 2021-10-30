import Foundation
import CoreData

struct MovieModel: Codable, Identifiable {
    let id: Int
    let title: String
    
    let genre: String
    
    let imageUrl: String
    let description: String?
    
    var price: String {
        if let trackPrice = trackPrice {
            return "\(String(format: "%.2f", trackPrice)) \(currency)"
        }
        
        return "FREE"
    }
    
    private let trackPrice: Double?
    private let currency: String

    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case title = "trackName"
        case trackPrice
        case currency
        case genre = "primaryGenreName"
        case imageUrl = "artworkUrl60"
        case description = "longDescription"
    }
    
    init(title: String, price: Double, genre: String) {
        self.id = 1
        self.currency = "AUD"
        self.title = title
        self.trackPrice = price
        self.genre = genre
        self.imageUrl = "https://example.com"
        self.description = ""
    }
    
    init(withDbModel model: Movie) {
        self.id = Int(model.itunes_id)
        self.title = model.title ?? ""
        self.genre = model.genre ?? ""
        self.imageUrl = model.image_url ?? "https://example.com"
        self.description = model.long_description
        self.trackPrice = model.price
        self.currency = "AUD"
    }
    
    func convertToDBModel(withViewContext viewContext: NSManagedObjectContext) -> Movie {
        let newMovieDBModel =  Movie(context: viewContext)
        newMovieDBModel.itunes_id = Int64(self.id)
        newMovieDBModel.title = self.title
        newMovieDBModel.genre = self.genre
        newMovieDBModel.image_url = self.imageUrl
        
        if let description = description {
            newMovieDBModel.long_description = description
        }
        
        if let trackPrice = trackPrice {
            newMovieDBModel.price = trackPrice
        }
        
        return newMovieDBModel
    }
}
