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
                VStack {
                    CachedAsyncImage(url: url, transaction: .init(animation: .easeOut)) { image in
                            VStack {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(48)

                                Text(fullName)
                            }
                    } placeholder: {
                            VStack {
                                ZStack {
                                    Image("placeholder")
                                        .resizable()
                                        .scaledToFit()
                                        .blur(radius: 2)
                                        .cornerRadius(48)
                                    ProgressView()
                                        .tint(.black)
                                }
                                Text("Loading...")
                                    .lineLimit(2)
                            }

                    }
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                }
            }

    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell(fullName: "Morty Smith", imageURL: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
            .preferredColorScheme(.dark)
    }
}
