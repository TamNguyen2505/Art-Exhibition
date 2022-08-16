//
//  NewsTableCellViewModel.swift
//  TableGit
//
//  Created by MINERVA on 10/08/2022.
//

import Foundation

struct NewsTableCellViewModel {
    //MARK: Properties
    private var model: HardvardMuseumObjectRecord

    //MARK: Init
    init(model: HardvardMuseumObjectRecord) {

        self.model = model

    }

    //MARK: Expected output
    var imageUrl: URL? {

        guard let id = model.images?.first?.iiifbaseuri, let url = URL(string: id + "/full/full/0/default.jpg") else {return nil}
        return url

    }

    var titleImage: String {

        return model.title ?? ""

    }

    var widthValue: String {

        if let width = model.images?.first?.width {

            return String(width)

        } else {

            return "None"

        }

    }

    var heightValue: String {

        if let height = model.images?.first?.height {

            return String(height)

        } else {

            return "None"

        }
    }

    var dateValue: String {

        return model.images?.first?.date?.formatDateToString(format: DateFormatterType.DDMMYYYY) ?? "None"

    }
    
    
}
