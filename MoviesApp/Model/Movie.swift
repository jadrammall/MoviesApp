//
//  Movie.swift
//  MoviesApp
//
//  Created by Jad Rammal on 12/10/2024.
//

import Foundation

struct Movie {
    let title: String
    let image: String
    let genre: String
    let year: Int
    let rate: Double
}

var data: [Movie] = [
    Movie(title: "Titanic", image: "titanic", genre: "Romantic", year: 1997, rate: 9.5),
    Movie(title: "Heart of stone", image: "heartofstone", genre: "Action", year: 2023, rate: 8.0),
    Movie(title: "IT", image: "it", genre: "Horror", year: 2017, rate: 7.5),
    Movie(title: "Transcendence", image: "transcendence", genre: "Action", year: 2014, rate: 7.0),
    Movie(title: "Annabelle", image: "anabelle", genre: "Horror", year: 2014, rate: 8.0),
    Movie(title: "Sweet girl", image: "sweetgirl", genre: "Action", year: 2021, rate: 8.5)
]
