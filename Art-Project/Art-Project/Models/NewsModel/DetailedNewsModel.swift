//
//  DetailedNewsModel.swift
//  TableGit
//
//  Created by MINERVA on 04/08/2022.
//

import Foundation

struct DetailedNewsModel: Codable {
    var objectid: Int?
    var provenance: String?
    var colors: [DetailedNewsColors]?
    var contextualtext: DetailedNewsText?
    var images: [DetailedNewsImages]?
}

struct DetailedNewsColors: Codable {
    var color: String?
    var percent: Double?
}

struct DetailedNewsText: Codable {
    var context: String?
    var text: String?
}

struct DetailedNewsImages: Codable {
    var date: String?
    var idsid: Int?
    var description: String?
    var iiifbaseuri: String?
}


