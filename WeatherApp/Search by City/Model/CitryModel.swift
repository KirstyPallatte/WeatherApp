//
//  CitryModel.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/22.
//

import Foundation

// MARK: - CityData
struct CityData: Codable {
    let id: Int?
    let name, state: String?
    let country: String?
    let coord: Coordinate?
}

// MARK: - Coordinate
struct Coordinate: Codable {
    let lon, lat: Double?
}
