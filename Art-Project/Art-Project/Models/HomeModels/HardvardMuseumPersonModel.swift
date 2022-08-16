//
//  HardvardMuseumPersonModel.swift
//  TableGit
//
//  Created by MINERVA on 10/08/2022.


import Foundation

// MARK: - HardvardMuseumPerson
struct HardvardMuseumPerson: Codable {
    var personid: Int?
    var displayname: String?
    var datebegin, dateend: Int?
    var displaydate, culture, gender: String?
    var birthplace, deathplace: JSONNull?
    var alphasort: String?
    var url: String?
    var objectcount, id: Int?
    var lastupdate: String?
    var ulanID, viafID, wikidataID: String?
    var names: [Name]?

    enum CodingKeys: String, CodingKey {
        case personid, displayname, datebegin, dateend, displaydate, culture, gender, birthplace, deathplace, alphasort, url, objectcount, id, lastupdate
        case ulanID = "ulan_id"
        case viafID = "viaf_id"
        case wikidataID = "wikidata_id"
        case names
    }
}

// MARK: - Name
struct Name: Codable {
    var displayname, type: String?
}



