//
//  APIClient.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-03.
//

import Foundation

struct APIService {
    
    static let loginURLString = Endpoints.login
    
    static func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: loginURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password.base64Encode()
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let success = json["success"] as? Bool, let msg = json["msg"] as? String {
                    completion(success, msg)
                } else {
                    completion(false, nil)
                }
            } catch {
                completion(false, nil)
            }
        }
        
        task.resume()
    }
    
    static let eventsURLString = Endpoints.events
    
    static func getEvents(completion: @escaping ([Event]?, String?) -> Void) {
        let url = URL(string: eventsURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Retrieve the token from Keychain
        if let token = KeychainService.shared.retrieveToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(nil, "Authorization token not found")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, "Network error or no data")
                return
            }
            
            //            print(String(data: data, encoding: .utf8) ?? "No data")
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var events = [Event]()
                    
                    for json in jsonArray {
                        print(json["startDate"] ?? "Value not readable")
                        if let id = json["id"] as? Int,
                           let name = json["name"] as? String,
                           //                           let description = json["description"] as? String,
                           let eventType = json["eventType"] as? String,
                           let locationName = json["locationName"] as? String,
                           let pointsWorth = json["pointsWorth"] as? Int,
                           let startDateStr = json["startDate"] as? String,
                           let endDateStr = json["endDate"] as? String {
                            
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let startDate = formatter.date(from: startDateStr)
                            let endDate = formatter.date(from: endDateStr)
                            
                            let event = Event(id: id, name: name/*, description: description*/, eventType: eventType, locationName: locationName, pointsWorth: pointsWorth, startDate: startDate!, endDate: endDate!)
                            events.append(event)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(events, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, "Failed to parse JSON")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, "JSON parsing error")
                }
            }
        }
        
        task.resume()
    }
    
    
    private func base64Encode(_ input: String) -> String{
        let inputData = input.data(using: .utf8)
        let encodedData = inputData?.base64EncodedString()
        return encodedData ?? ""
    }
}
