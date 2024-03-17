import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Authorization granted, start location updates
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // Authorization denied or restricted, handle accordingly
            // You may want to display an alert to inform the user
            showLocationServicesDisabledAlert()
        case .notDetermined:
            // Authorization status not determined yet
            // You can request authorization again if needed
            manager.requestWhenInUseAuthorization()
        @unknown default:
            // Handle unknown authorization status
            // You may want to log this case for debugging purposes
            print("Unknown authorization status: \(status.rawValue)")
        }
    }

    func showLocationServicesDisabledAlert() {
        // Display an alert informing the user that location services are disabled
        // You can customize the alert message and actions as needed
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }}
