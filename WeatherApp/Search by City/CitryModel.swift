//
//  CitryModel.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/22.
//

import Foundation
struct CityData: Codable {
        let refCountryCodes: [RefCountryCode]

        enum CodingKeys: String, CodingKey {
            case refCountryCodes = "ref_country_codes"
        }

    // MARK: - RefCountryCode
    struct RefCountryCode: Codable {
        let country, alpha2, alpha3: String
        let numeric: Int
        let latitude, longitude: Double
    }
}
