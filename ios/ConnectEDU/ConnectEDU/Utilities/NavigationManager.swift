//
//  NavigationManager.swift
//  ConnectEDU
//
//  Created by Logan Rohlfs on 2024-03-05.
//

import Foundation

class NavigationManager: ObservableObject {
    // Old way of using shared object (Didnt work for built in swift reactivity)
    //    static let shared = NavigationManager()
    
    @Published var currentEventID: Int?
    
    @Published var currentPage: Page = KeychainService.shared.retrieveToken() != nil ? .events : .login
    private var pageStack: [Page] = [KeychainService.shared.retrieveToken() != nil ? .events : .login]
    
    private var isUserAuthenticated: Bool {
        didSet {
            currentPage = isUserAuthenticated ? .events : .login
        }
    }
    
    init() {
        isUserAuthenticated = KeychainService.shared.retrieveToken() != nil
        currentPage = isUserAuthenticated ? .events : .login
    }
    
    enum Page: String, CaseIterable {
        case login
        case forgotPassword
        case signup
        case verify
        case dev
        case missingPoints
        case profile
        case clubs
        case events
        case rewards
        case eventDetail
        // Add other pages as needed
    }
    
    @Published var forceUpdate: Bool = false
    
    func navigate(to page: Page) {
        pageStack.append(page)
        currentPage = page
        forceUpdate.toggle()
        forceUpdate.toggle()
        // Additional logic if needed
        print("Navigated to \nPage: \(page) \nCurrent Stack: \(pageStack)")
    }
    
    func goToEventDetail(with eventID: Int) {
        currentEventID = eventID // Store the current event ID
        navigate(to: .eventDetail)
    }
    
    func dump() -> String {
        return pageStack.map { $0.rawValue }.joined(separator: " -> ")
    }
    
    func fetch() -> String {
        return pageStack.last?.rawValue ?? "stack is empty"
    }
    
    func back() {
        if pageStack.count > 1 {
            pageStack.removeLast()
            currentPage = pageStack.last ?? .events
        }
    }
    
    func popToRoot() {
        pageStack.removeAll()
        navigate(to: .events)
    }
    
    func updateAuthenticationState(withToken token: String?) {
        if let token = token {
            KeychainService.shared.saveToken(token)
            currentPage = .events
            isUserAuthenticated = true
        } else {
            KeychainService.shared.deleteToken()
            isUserAuthenticated = false
        }
    }
    
    // Add methods for login, signup, and verify that handle authentication and navigation
}
