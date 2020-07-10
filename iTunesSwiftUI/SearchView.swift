//
//  SearchView.swift
//  iTunesSwiftUI
//
//  Created by Morgan Smith on 7/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

// Create a swiftUI view that embeds a UISearchBar in it
final class SearchBar: NSObject, UIViewRepresentable {
    //binding reference to something else
    @Binding var artistName: String
    @Binding var artistGenre: String

    //giving initial values because cant do empty strings
    init(artistName: Binding<String> = .constant(""), artistGenre: Binding<String> = .constant("")) {
        _artistName = artistName
        _artistGenre = artistGenre
    }
    //specify which UIView we are trying to use in swiftUI
    typealias UIViewType = UISearchBar
    func makeUIView(context: Context) -> UISearchBar {
        //Initialize and configure the search bar how we want it to be
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        //update your view whenever the swiftUI state changes if needed
        uiView.delegate = self
    }

}

extension SearchBar: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let searchTerm = searchBar.text else { return }
        iTunesAPI.searchArtists(for: searchTerm) { (result) in
            do {
                let artists = try result.get()
                guard let firstArtist = artists.first else {
                    self.artistName = "No Aritsts found"
                    self.artistGenre = ""
                    return
                }
                self.artistName = firstArtist.artistName
                self.artistGenre = firstArtist.primaryGenreName
            } catch {
                NSLog("No artist found")
                self.artistName = "Error search for artist"
            }
        }
    }
}

/*
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
 */

