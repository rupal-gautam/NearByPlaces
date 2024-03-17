import SwiftUI
import CoreLocation

struct VenueListView: View {
    @ObservedObject var viewModel: VenueListViewModel
    @State private var searchText: String = ""
    @ObservedObject var locationManager = LocationManager() // Location manager instance
    
    init(viewModel: VenueListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar with Search Button
                SearchBar(text: $searchText, searchAction: {
                    // Perform search action for manually entered location or search text
                    fetchVenuesForLocation()
                })
                
                if viewModel.numberOfVenues() > 0 {
                    List {
                        ForEach(0..<viewModel.numberOfVenues(), id: \.self) { index in
                            NavigationLink(destination: Text(viewModel.venue(at: index).url)) {
                                VenueItemView(venue: viewModel.venue(at: index))
                                    .onAppear {
                                        // Call fetchNextPageIfNeeded when the last item in the list is reached
                                        if index == viewModel.numberOfVenues() - 1 {
                                            viewModel.fetchNextPageIfNeeded(currentIndex: index, latitude: locationManager.location?.latitude ?? 0, longitude: locationManager.location?.longitude ?? 0, distance: 12)
                                        }
                                    }
                            }
                        }
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
            .navigationBarTitle("Nearby Venues")
            .onAppear {
                // Fetch venues based on current location when view appears
                fetchVenuesForLocation()
            }
        }
    }
    private func fetchVenuesForLocation() {
//        if let location = locationManager.location {
//             Fetch venues based on current location
//            viewModel.fetchVenues(latitude: location.latitude, longitude: location.longitude, distance: 12) // Distance can be adjusted as needed
            viewModel.fetchVenues(latitude: 12.971599, longitude: 77.594566, distance: 12) // Distance can be adjusted as needed
            
//        } else {
//             Location services not enabled, show alert
//            print("Location services not enabled")
//        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var searchAction: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .padding(.top, 5)
                .padding(.bottom, 10)
            
            Button(action: {
                searchAction()
            }) {
                Text("Search")
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}
