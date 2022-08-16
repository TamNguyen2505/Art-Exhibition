//
//  AudioModel.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import Foundation

struct Audio: Codable {
    
    let id, audioid, fileid: Int?
    let audioDescription, copyright: String?
    let primaryurl: String?
    let transcripturl: String?
    let duration: Int?
    let lastupdate: Date?

    enum CodingKeys: String, CodingKey {
        case id, audioid, fileid
        case audioDescription = "description"
        case copyright, primaryurl, transcripturl, duration, lastupdate
    }
    
}
