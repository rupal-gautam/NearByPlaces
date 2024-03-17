import Foundation

class VenueListViewModel: ObservableObject {
    
    var onDataUpdated: (() -> Void)?
    private var venues: [Venue] = []
    private var currentPage = 1
    private var totalPages = 1
    private var isFetchingData = false
    
    // UserDefaults keys for caching
    private let cachedVenuesKey = "cachedVenues"
    
    init() {
        // Load cached venues on initialization
        loadCachedVenues()
    }
    
    func fetchVenues(latitude: Double, longitude: Double, distance: Int) {
        guard !isFetchingData else { return }
        isFetchingData = true
        
        let clientID = "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5"
        let perPage = 10
        let url = "https://api.seatgeek.com/2/venues?client_id=\(clientID)&per_page=\(perPage)&page=\(currentPage)&lat=\(latitude)&lon=\(longitude)&range=\(distance)mi"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data else { return }
            do {
                let venuesData = try JSONDecoder().decode(VenueResponse.self, from: data)
                self.totalPages = venuesData.meta.total
                if self.currentPage == 1 {
                    self.venues = venuesData.venues
                    // Save fetched venues to UserDefaults
                    self.saveCachedVenues()
                } else {
                    self.venues.append(contentsOf: venuesData.venues)
                }
                DispatchQueue.main.async {
                    self.isFetchingData = false
                    self.onDataUpdated?()
                }
            } catch {
                print("Error decoding venue data: \(error)")
            }
        }.resume()
    }
    
    func fetchNextPageIfNeeded(currentIndex: Int, latitude: Double, longitude: Double, distance: Int) {
        if currentIndex == venues.count - 1 && currentPage < totalPages {
            currentPage += 1
            fetchVenues(latitude: latitude, longitude: longitude, distance: distance)
        }
    }

    private func onDataUpdated(response: VenueResponse) {
        // Update venues
        self.venues = response.venues    }

    func filterVenuesByDistance(_ distance: Int) {
        // Filter venues based on distance
        venues = venues.filter { _ in /* Add distance filtering logic here */ true }
        onDataUpdated?()
    }
    
    func venue(at index: Int) -> Venue {
        return venues[index]
    }
    
    func numberOfVenues() -> Int {
        return venues.count
    }
    
    private func saveCachedVenues() {
        do {
            let encodedData = try JSONEncoder().encode(venues)
            UserDefaults.standard.set(encodedData, forKey: cachedVenuesKey)
        } catch {
            print("Error saving cached venues: \(error)")
        }
    }
    
    private func loadCachedVenues() {
        guard let cachedData = UserDefaults.standard.data(forKey: cachedVenuesKey) else { return }
        do {
            venues = try JSONDecoder().decode([Venue].self, from: cachedData)
        } catch {
            print("Error loading cached venues: \(error)")
        }
    }
}
