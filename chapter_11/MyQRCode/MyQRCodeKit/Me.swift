//
//  Me.swift
//  MyQRCodeKit
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation
import CoreImage

public struct Me: Codable {
    public let firstname: String?
    public let lastname: String?
    public let company: String?
    public let street: String?
    public let city: String?
    public let zipcode: String?
    public let country: String?
    public let phone: String?
    public let email: String?
    public let website: String?
    public let birthday: String?

    private static var userDefaults: UserDefaults {
        get {
            return UserDefaults(suiteName: "group.com.kishikawakatsumi.myqrcode")!
        }
    }
    let key = "me"

    public init(firstname: String?, lastname: String?, company: String?,
                street: String?, city: String?, zipcode: String?, country: String?,
                phone: String?, email: String?, website: String?,
                birthday: String?) {
        self.firstname = firstname
        self.lastname = lastname
        self.company = company
        self.street = street
        self.city = city
        self.zipcode = zipcode
        self.country = country
        self.phone = phone
        self.email = email
        self.website = website
        self.birthday = birthday
    }

    public func generateVisualCode() -> UIImage? {
        let parameters: [String : Any] = [
            "inputMessage": vCardRepresentation(),
            "inputCorrectionLevel": "L"
        ]
        let filter = CIFilter(name: "CIQRCodeGenerator", withInputParameters: parameters)

        guard let outputImage = filter?.outputImage else {
            return nil
        }

        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 6, y: 6))
        guard let cgImage = CIContext().createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }

    private func vCardRepresentation() -> Data! {
        var vCard = [String]()

        vCard += ["BEGIN:VCARD"]
        vCard += ["VERSION:3.0"]

        switch (firstname, lastname) {
        case let (firstname?, lastname?):
            vCard += ["N:\(lastname);\(firstname);"]
        case let (firstname?, nil):
            vCard += ["N:\(firstname);"]
        case let (nil, lastname?):
            vCard += ["N:\(lastname);"]
        case (nil, nil):
            break
        }

        if let company = company {
            vCard += ["ORG:\(company)"]
        }

        switch (street, city, zipcode, country) {
        case let (street?, city?, zipcode?, country?):
            vCard += ["ADR:;;\(street);\(city);;\(zipcode);\(country)"]
        case let (nil, city?, zipcode?, country?):
            vCard += ["ADR:;;;\(city);;\(zipcode);\(country)"]
        case let (street?, nil, zipcode?, country?):
            vCard += ["ADR:;;\(street);;;\(zipcode);\(country)"]
        case let (street?, city?, nil, country?):
            vCard += ["ADR:;;\(street);\(city);;;\(country)"]
        case let (street?, city?, zipcode?, nil):
            vCard += ["ADR:;;\(street);\(city);;\(zipcode);"]
        case let (nil, nil, zipcode?, country?):
            vCard += ["ADR:;;;;;\(zipcode);\(country)"]
        case let (street?, nil, nil, country?):
            vCard += ["ADR:;;\(street);;;;\(country)"]
        case let (street?, city?, nil, nil):
            vCard += ["ADR:;;\(street);\(city);;;"]
        case let (nil, city?, nil, country?):
            vCard += ["ADR:;;;\(city);;;\(country)"]
        case let (street?, nil, zipcode?, nil):
            vCard += ["ADR:;;\(street);;;\(zipcode);"]
        case let (nil, city?, zipcode?, nil):
            vCard += ["ADR:;;;\(city);;\(zipcode);"]
        case let (nil, nil, nil, country?):
            vCard += ["ADR:;;;;;;\(country)"]
        case let (street?, nil, nil, nil):
            vCard += ["ADR:;;\(street);;;;"]
        case let (nil, city?, nil, nil):
            vCard += ["ADR:;;;\(city);;;"]
        case let (nil, nil, zipcode?, nil):
            vCard += ["ADR:;;;;;\(zipcode);"]
        case (nil, nil, nil, nil):
            break
        }

        if let phone = phone {
            vCard += ["TEL:\(phone)"]
        }

        if let email = email {
            vCard += ["EMAIL:\(email)"]
        }

        if let website = website {
            vCard += ["URL:\(website)"]
        }

        if let birthday = birthday {
            vCard += ["BDAY:\(birthday)"]
        }

        vCard += ["END:VCARD"]

        return vCard.joined(separator: "\n").data(using: .utf8)
    }
}
