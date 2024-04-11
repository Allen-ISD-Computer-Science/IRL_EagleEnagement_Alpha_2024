//
//  APIClient.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-03.
//

import Foundation

struct APIService {
    
    // LOGIN
    
    static func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let body: [String: Any] = [
            "email": email,
            "password": password.base64Encode()
        ]
        
        guard let request = createRequest(urlString: Endpoints.login, httpMethod: "POST", body: body) else {
            completion(false, "Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            handleResponse(data: data, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    // FORGOT PASSWORD
    
    static let forgotPasswordURLString = Endpoints.forgotPassword
    
    static func forgotPassword(email: String, studentID: String, completion: @escaping (Bool, String?) -> Void) {
        let body: [String: Any] = [
            "email": email,
            "studentID": Int(studentID)! // TODO: Fix this
        ]
        
        guard let request = createRequest(urlString: Endpoints.forgotPassword, httpMethod: "POST", body: body) else {
            completion(false, "Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            handleResponse(data: data, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    // SIGN UP
    
    static func signup(firstName: String, lastName: String, email: String, studentID: String, completion: @escaping (Bool, String?) -> Void) {
        let body: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "studentID": Int(studentID)! // TODO: Fix this
        ]
        
        guard let request = createRequest(urlString: Endpoints.signup, httpMethod: "POST", body: body) else {
            completion(false, "Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            handleResponse(data: data, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    // VERIFY
    
    static func verify(email: String, token: String, password: String, passwordConfirm: String, completion: @escaping (Bool, String?) -> Void) {
        let body: [String: Any] = [
            "email": email,
            "token": token,
            "password": password.base64Encode(),
            "passwordConfirm": passwordConfirm.base64Encode()
        ]
        
        guard let request = createRequest(urlString: Endpoints.verify, httpMethod: "POST", body: body) else {
            completion(false, "Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            handleResponse(data: data, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    // PROFILE
    
    static func getProfile(completion: @escaping (Profile?, String?) -> Void) {
        guard let token = KeychainService.shared.retrieveToken(),
              let request = createRequest(urlString: Endpoints.profile, httpMethod: "POST", token: token) else {
            NavigationManager.shared.resetAuthenticationState()
            completion(nil, "Invalid URL or Authorization token not found")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            
            guard let data = data, error == nil else {
                completion(nil, "Network error")
                return
            }
            
            do {
                let profile = try JSONDecoder().decode(Profile.self, from: data)
                DispatchQueue.main.async {
                    completion(profile, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, "Failed to parse JSON")
                }
            }
        }
        
        task.resume()
    }
    
    // CLUBS
    
    static func getClubs(completion: @escaping ([ClubListObject]?, String?) -> Void) {
        guard let token = KeychainService.shared.retrieveToken(),
              let request = createRequest(urlString: Endpoints.clubs, httpMethod: "POST", token: token) else {
            NavigationManager.shared.resetAuthenticationState()
            completion(nil, "Invalid URL or Authorization token not found")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            
            guard let data = data, error == nil else {
                completion(nil, "Network error or no data")
                return
            }
            
            do {
                let clubs = try JSONDecoder().decode([ClubListObject].self, from: data)
                DispatchQueue.main.async {
                    completion(clubs, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, "Failed to parse JSON")
                }
            }
        }
        
        task.resume()
    }
    
    // Club
//    static func getClub(clubId: Int, completion: @escaping (Club?, String?) -> Void) {
//        let clubURLString = "\(Endpoints.club)/\(clubId)"
//        
//        guard var request = createRequest(urlString: clubURLString, httpMethod: "POST") else {
//            completion(nil, "Invalid URL")
//            return
//        }
//        
//        // Retrieve the token from Keychain
//        if let token = KeychainService.shared.retrieveToken() {
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        } else {
//            completion(nil, "Authorization token not found")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, _, error in
//            guard let data = data, error == nil else {
//                completion(nil, "Network error")
//                return
//            }
//            
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let name = json["name"] as? String,
//                   let description = json["description"] as? String,
//                   let sponsors = json["sponsors"] as? String,
//                   let meetingTimes = json["meetingTimes"] as? String?,
//                   let locationName = json["locationName"] as? String?,
//                   let websiteLink = json["websiteLink"] as? String?,
//                   let instagramLink = json["instagramLink"] as? String?,
//                   let twitterLink = json["twitterLink"] as? String?,
//                   let youtubeLink = json["youtubeLink"] as? String? {
//                    
//                    let club = Club(name: name, description: description, sponsors: sponsors, meetingTimes: meetingTimes, locationName: locationName, websiteLink: websiteLink, instagramLink: instagramLink, twitterLink: twitterLink, youtubeLink: youtubeLink)
//                    completion(club, nil)
//                } else {
//                    completion(nil, "Failed to parse JSON")
//                }
//            } catch {
//                completion(nil, "JSON parsing error")
//            }
//        }
//        
//        task.resume()
//    }
    
    static func getClub(clubId: Int, completion: @escaping (Club?, String?) -> Void) {
        let clubURLString = "\(Endpoints.club)/\(clubId)"
        
        guard let token = KeychainService.shared.retrieveToken(),
              let request = createRequest(urlString: clubURLString, httpMethod: "POST", token: token) else {
            NavigationManager.shared.resetAuthenticationState()
            completion(nil, "Invalid URL or Authorization token not found")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            
            guard let data = data, error == nil else {
                completion(nil, "Network error")
                return
            }

            do {
                let club = try JSONDecoder().decode(Club.self, from: data)
                DispatchQueue.main.async {
                    completion(club, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, "Failed to parse JSON")
                }
            }
        }

        task.resume()
    }

    
    // EVENTS
    
    static let eventsURLString = Endpoints.events
    
//    static func getEvents(completion: @escaping ([EventListObject]?, String?) -> Void) {
//        let url = URL(string: eventsURLString)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // Retrieve the token from Keychain
//        if let token = KeychainService.shared.retrieveToken() {
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        } else {
//            completion(nil, "Authorization token not found")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, _, error in
//            guard let data = data, error == nil else {
//                completion(nil, "Network error or no data")
//                return
//            }
//            
//            do {
//                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
//                    var events = [EventListObject]()
//                    
//                    for json in jsonArray {
//                        if let id = json["id"] as? Int,
//                           let name = json["name"] as? String,
//                           let eventType = json["eventType"] as? String,
//                           let locationName = json["locationName"] as? String,
//                           let pointsWorth = json["pointsWorth"] as? Int,
//                           let startDateStr = json["startDate"] as? String,
//                           let endDateStr = json["endDate"] as? String
//                        {
//                            let formatter = DateFormatter()
//                            formatter.locale = Locale(identifier: "en_US_POSIX")
//                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                            let startDate = formatter.date(from: startDateStr)
//                            let endDate = formatter.date(from: endDateStr)
//                            
//                            let event = EventListObject(id: id, name: name /* , description: description */, eventType: eventType, locationName: locationName, pointsWorth: pointsWorth, startDate: startDate!, endDate: endDate!)
//                            events.append(event)
//                        }
//                    }
//                    DispatchQueue.main.async {
//                        completion(events, nil)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        completion(nil, "Failed to parse JSON")
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(nil, "JSON parsing error")
//                }
//            }
//        }
//        
//        task.resume()
//    }
    
    static func getEvents(completion: @escaping ([EventListObject]?, String?) -> Void) {
        guard let token = KeychainService.shared.retrieveToken(),
              let request = createRequest(urlString: Endpoints.events, httpMethod: "POST", token: token) else {
            NavigationManager.shared.resetAuthenticationState()
            completion(nil, "Invalid URL or Authorization token not found")
            return
        }

        print("Request: \(request)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            
            guard let data = data, error == nil else {
                completion(nil, "Network error or no data")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let events = try decoder.decode([EventListObject].self, from: data)
                DispatchQueue.main.async {
                    completion(events, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, "Failed to parse JSON")
                }
            }
        }

        task.resume()
    }


    
    // Event
//    static func getEvent(eventId: Int, completion: @escaping (Event?, String?) -> Void) {
//        let eventURLString = "\(Endpoints.event)/\(eventId)"
//        
//        guard var request = createRequest(urlString: eventURLString, httpMethod: "POST") else {
//            completion(nil, "Invalid URL")
//            return
//        }
//        
//        // Retrieve the token from Keychain
//        if let token = KeychainService.shared.retrieveToken() {
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        } else {
//            completion(nil, "Authorization token not found")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, _, error in
//            guard let data = data, error == nil else {
//                completion(nil, "Network error")
//                return
//            }
//            
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let id = json["id"] as? Int,
//                   let name = json["name"] as? String,
//                   let eventType = json["eventType"] as? String,
//                   let description = json["description"] as? String,
//                   let locationName = json["locationName"] as? String,
//                   let address = json["address"] as? String,
//                   let pointsWorth = json["pointsWorth"] as? Int,
//                   let startDateStr = json["startDate"] as? String,
//                   let endDateStr = json["endDate"] as? String {
//                    
//                    let formatter = DateFormatter()
//                    formatter.locale = Locale(identifier: "en_US_POSIX")
//                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                    let startDate = formatter.date(from: startDateStr)
//                    let endDate = formatter.date(from: endDateStr)
//                    
//                    let event = Event(id: id, name: name, eventType: eventType, description: description, locationName: locationName, address: address, pointsWorth: pointsWorth, startDate: startDate!, endDate: endDate!)
//                    completion(event, nil)
//                } else {
//                    completion(nil, "Failed to parse JSON")
//                }
//            } catch {
//                completion(nil, "JSON parsing error")
//            }
//        }
//        
//        task.resume()
//    }
    
    static func getEvent(eventId: Int, completion: @escaping (Event?, String?) -> Void) {
        let eventURLString = "\(Endpoints.event)/\(eventId)"

        guard let token = KeychainService.shared.retrieveToken(),
              let request = createRequest(urlString: eventURLString, httpMethod: "POST", token: token) else {
            NavigationManager.shared.resetAuthenticationState()
            completion(nil, "Invalid URL or Authorization token not found")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            
            guard let data = data, error == nil else {
                completion(nil, "Network error")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let event = try decoder.decode(Event.self, from: data)
                DispatchQueue.main.async {
                    completion(event, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, "Failed to parse JSON")
                }
            }
        }

        task.resume()
    }
    
    // Points History Req
    static func fetchPointHistory(completion: @escaping ([PointHistoryListObject]?, String?) -> Void) {
        guard let request = createRequest(urlString: Endpoints.pointHistory, httpMethod: "POST", body: nil) else {
            completion(nil, "Invalid request.")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let pointHistoryList = try decoder.decode([PointHistoryListObject].self, from: data)
                completion(pointHistoryList, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }

    
    // REWARDS

    static func getRewards(completion: @escaping ([RewardListObject]?, String?) -> Void) {
        guard let token = KeychainService.shared.retrieveToken(),
              let request = createRequest(urlString: Endpoints.rewards, httpMethod: "POST", token: token) else {
            NavigationManager.shared.resetAuthenticationState()
            completion(nil, "Invalid URL or Authorization token not found")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            checkForUnauthorizedResponse(response: response) // Check for 403 error code
            
            guard let data = data, error == nil else {
                completion(nil, "Network error or no data")
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var rewards = [RewardListObject]()

                    for json in jsonArray {
                        if let id = json["id"] as? Int,
                           let name = json["name"] as? String,
                           let description = json["description"] as? String,
                           let cost = json["cost"] as? Int {
                            let reward = RewardListObject(id: id, name: name, description: description, cost: cost)
                            rewards.append(reward)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(rewards, nil)
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

    
    // API Methods
    
    // Creates a URLRequest
    private static func createRequest(urlString: String, httpMethod: String, body: [String: Any]? = nil, token: String? = nil) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    // TODO: Create method to remove user token and send them to the Login screen in case of failed token retrievaltodo
    
    // Handles the response
    private static func handleResponse(data: Data?, error: Error?, completion: @escaping (Bool, String?) -> Void) {
        guard let data = data, error == nil else {
            completion(false, "Network error")
            return
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let success = json["success"] as? Bool {
                let msg = json["msg"] as? String
                if !success && (msg == "User authentication error" || msg == "Token not found") {
                    DispatchQueue.main.async {
                        NavigationManager.shared.resetAuthenticationState()  // Navigate back to the login screen
                    }
                }
                completion(success, msg)
            } else {
                completion(false, "Failed to parse JSON")
            }
        } catch {
            completion(false, "JSON parsing error")
        }
    }
    
    private static func checkForUnauthorizedResponse(response: URLResponse?) {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 else {
            return
        }

        DispatchQueue.main.async {
            print("User not Authorized")
            NavigationManager.shared.resetAuthenticationState()  // Navigate back to the login screen
        }
    }

    
    private func base64Encode(_ input: String) -> String {
        let inputData = input.data(using: .utf8)
        let encodedData = inputData?.base64EncodedString()
        print(encodedData ?? "")
        return encodedData ?? ""
    }
}


