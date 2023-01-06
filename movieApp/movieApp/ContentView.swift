//
//  ContentView.swift
//  movieApp
//
//  Created by Consultant on 1/6/23.
//

import SwiftUI

struct Movie: Codable {
    let results: [MovieDetails]
}

struct MovieDetails: Codable {
    let original_title: String
}

class ViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    func fetch () {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=9e1d8923520bd266b373cf8eb02c7f6b&language=en-US&page=1") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            //convert to JSON
            
            do {
                let movies = try JSONDecoder().decode([Movie].self, from: data)
                DispatchQueue.main.async{
                    self?.movies = movies
                }
        
            }
            catch {
                print(error)
            }
        })
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach (viewModel.movies, id: \.self) { movie in
                        HStack {
                            Text (movie.original_title).bold()
                        }
                        
                    }
                }
                .navigationTitle("Top Movies")
                .onAppear {
                    viewModel.fetch()
                }
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
