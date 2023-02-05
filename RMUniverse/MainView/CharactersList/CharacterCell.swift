//
//  CharacterCell.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 04.02.2023.
//

import SwiftUI

struct CharacterCell: View {
    var fullName: String
    var imageURL: String

    var body: some View {
        if let url = URL(string: imageURL) {
            CachedAsyncImage(url: url, transaction: .init(animation: .easeOut)) { image in
                VStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                    Text(fullName)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            } placeholder: {
                VStack {
                    ZStack {
                        Image("placeholder")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                        .blur(radius: 2)
                        ProgressView()
                            .scaleEffect(2)
                            .tint(.black)
                    }
                    Text("Loading...")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .foregroundColor(.white)
        }
    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell(fullName: "Morty Smith", imageURL: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
    }
}
