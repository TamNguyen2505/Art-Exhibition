//
//  HardvardMuseumObjectModel.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let hardvardMuseumObject = try? newJSONDecoder().decode(HardvardMuseumObject.self, from: jsonData)

import Foundation

// MARK: - HardvardMuseumObject
struct HardvardMuseumObject: Codable {
    var info: HardvardMuseumObjectInfo?
    var records: [HardvardMuseumObjectRecord]?
}

// MARK: - Info
struct HardvardMuseumObjectInfo: Codable {
    var totalrecordsperquery, totalrecords, pages, page: Int?
    var next: String?
}

// MARK: - Record
struct HardvardMuseumObjectRecord: Codable {
    var copyright: JSONNull?
    var contextualtextcount: Int?
    var creditline: String?
    var accesslevel: Int?
    var dateoflastpageview: JSONNull?
    var classificationid: Int?
    var division: String?
    var markscount, publicationcount, totaluniquepageviews: Int?
    var contact: String?
    var colorcount, rank: Int?
    var details: Details?
    var state: JSONNull?
    var id: Int?
    var verificationleveldescription, period: String?
    var images: [Image]?
    var worktypes: [Worktype]?
    var imagecount, totalpageviews, accessionyear: Int?
    var standardreferencenumber: String?
    var signed: JSONNull?
    var classification: String?
    var relatedcount, verificationlevel: Int?
    var primaryimageurl: String?
    var titlescount, peoplecount: Int?
    var style: JSONNull?
    var lastupdate: String?
    var commentary: JSONNull?
    var periodid: Int?
    var technique: String?
    var edition: JSONNull?
    var recordDescription, medium: String?
    var lendingpermissionlevel: Int?
    var title, accessionmethod: String?
    var colors: [Color]?
    var provenance: JSONNull?
    var groupcount: Int?
    var dated, department: String?
    var dateend: Int?
    var people: [Person]?
    var url: String?
    var dateoffirstpageview: JSONNull?
    var century: String?
    var objectnumber: String?
    var labeltext: JSONNull?
    var datebegin: Int?
    var culture: String?
    var exhibitioncount, imagepermissionlevel, mediacount, objectid: Int?
    var techniqueid: Int?
    var dimensions: String?
    var seeAlso: [SeeAlso]?

    enum CodingKeys: String, CodingKey {
        case copyright, contextualtextcount, creditline, accesslevel, dateoflastpageview, classificationid, division, markscount, publicationcount, totaluniquepageviews, contact, colorcount, rank, details, state, id, verificationleveldescription, period, images, worktypes, imagecount, totalpageviews, accessionyear, standardreferencenumber, signed, classification, relatedcount, verificationlevel, primaryimageurl, titlescount, peoplecount, style, lastupdate, commentary, periodid, technique, edition
        case recordDescription = "description"
        case medium, lendingpermissionlevel, title, accessionmethod, colors, provenance, groupcount, dated, department, dateend, people, url, dateoffirstpageview, century, objectnumber, labeltext, datebegin, culture, exhibitioncount, imagepermissionlevel, mediacount, objectid, techniqueid, dimensions, seeAlso
    }
}

// MARK: - Color
struct Color: Codable {
    var color, spectrum, hue: String?
    var percent: Double?
    var css3: String?
}

// MARK: - Details
struct Details: Codable {
    var coins: Coins?
}

// MARK: - Coins
struct Coins: Codable {
    var reverseinscription: String?
    var dieaxis: JSONNull?
    var metal, obverseinscription, denomination: String?
    var dateonobject: JSONNull?
}

// MARK: - Image
struct Image: Codable {
    var date, copyright: String?
    var imageid, idsid: Int?
    var format: String?
    var imageDescription, technique: JSONNull?
    var renditionnumber: String?
    var displayorder: Int?
    var baseimageurl: String?
    var alttext: JSONNull?
    var width: Int?
    var publiccaption: JSONNull?
    var iiifbaseuri: String?
    var height: Int?

    enum CodingKeys: String, CodingKey {
        case date, copyright, imageid, idsid, format
        case imageDescription = "description"
        case technique, renditionnumber, displayorder, baseimageurl, alttext, width, publiccaption, iiifbaseuri, height
    }
}

// MARK: - Person
struct Person: Codable {
    var role: String?
    var birthplace: JSONNull?
    var gender: String?
    var displaydate, personPrefix, culture: String?
    var displayname, alphasort, name: String?
    var personid: Int?
    var deathplace: JSONNull?
    var displayorder: Int?

    enum CodingKeys: String, CodingKey {
        case role, birthplace, gender, displaydate
        case personPrefix = "prefix"
        case culture, displayname, alphasort, name, personid, deathplace, displayorder
    }
}

// MARK: - SeeAlso
struct SeeAlso: Codable {
    var id: String?
    var type, format: String?
    var profile: String?
}

// MARK: - Worktype
struct Worktype: Codable {
    var worktypeid, worktype: String?
}

