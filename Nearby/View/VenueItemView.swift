//
//  VenueItemView.swift
//  Nearby
//
//  Created by Rupal Gautam on 17/03/24.
//

import SwiftUI

struct VenueItemView: View {

    let venue: Venue 
    var body: some View {
        VStack(alignment: .leading) {
            Text(venue.name ?? "")
                .font(.headline)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
