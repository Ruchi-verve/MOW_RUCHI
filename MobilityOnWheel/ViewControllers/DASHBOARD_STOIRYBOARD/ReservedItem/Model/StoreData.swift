//
//  StoreData.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 24/08/21.
//

import Foundation
struct StoreData: Codable {
    var name: String?
    var description: String?
    var producer: String?
    var thumb: String?
    var live: String?
    var banner: String?
    var id: String?
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case id = "ID"
        case description = "Description"
        case producer = "Producer"
        case thumb = "Thumb"
        case live = "Live"
        case banner = "Banner"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        producer = try values.decode(String.self, forKey: .producer)
        thumb = try values.decode(String.self, forKey: .thumb)
        live = try values.decode(String.self, forKey: .live)
        banner = try values.decode(String.self, forKey: .banner)
        id = try values.decode(String.self, forKey: .id)

    }

    func encode(to encoder: Encoder) throws {

    }
}

