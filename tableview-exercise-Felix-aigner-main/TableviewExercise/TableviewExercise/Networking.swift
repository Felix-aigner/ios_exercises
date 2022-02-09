

import Foundation

class Networking {
    let session = URLSession(configuration: .default)
    let jsonDecoder = JSONDecoder()
    var currIdToken = ""
    
    
    func login(email: String, password: String, completionHandler: @escaping (_ response: (User?, NetworkingError?)) -> ()){
        // Preparation of the request, including API Key, email and password
        let api = "AIzaSyCTryhlVmmRHYE7iQT3k0eeNRHIKsTMpRw"
        let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(api)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String : Any] = ["email": email, "password": password, "returnSecureToken": true]
        
        // parsing of the prepared body to json for request
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        request.httpBody = jsonData
        
        // starting the actual request
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // catching error first to return failedRequest
            if let error = error {
                print(error)
                completionHandler((nil, NetworkingError.failedRequest))
                return
            }
            
            // if no error was caught, proceed with check for status code and further error handling
            if let httpResp = response as? HTTPURLResponse, let data = data {
                
                //any status code from 200 to 299 is seen as "okay" for now and returns the user (without an error)
                if 200...299 ~= httpResp.statusCode {
                    if let user = try? self.jsonDecoder.decode(User.self, from: data)  {
                        self.currIdToken = user.idToken
                        completionHandler((user, nil))
                        return
                    }
                } else {
                    // the status code was out of bounds for 200-299, we decode data to our errormodel and look for the message to classify the error
                    if let fireBaseRespError = try? self.jsonDecoder.decode(FirebaseResponseError.self, from: data) {
                        switch fireBaseRespError.message {
                        case "INVALID_PASSWORD":
                            completionHandler((nil, NetworkingError.invalidPassword))
                        case "USER_DISABLED":
                            completionHandler((nil, NetworkingError.userDisabled))
                        case "EMAIL_NOT_FOUND":
                            completionHandler((nil, NetworkingError.emailNotFound))
                        default:
                            //any unknown error is treated as a failed request
                            completionHandler((nil, NetworkingError.failedRequest))
                        }
                        // as with any completionhandler, we have to close the function after calling it, since the function would continue running and maybe call another completion handler (leading to further errors)
                        return
                    }
                }
            }
            completionHandler((nil, NetworkingError.failedRequest))
            return
            
        }
        dataTask.resume()
        
    }
    
    func downloadCountries(completionHandler: @escaping (_ response: ([Country]?, NetworkingError?)) -> ()) {
        self.jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/mad-course-3ceb1/databases/(default)/documents/countries?pageSize=1000&orderBy=name")!
        //forced because we know it exists at this point
        var request = URLRequest(url: url)
        request.setValue("Bearer \(self.currIdToken)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            
            if let httpResp = response as? HTTPURLResponse, let dataContent = data {
                if 200...299 ~= httpResp.statusCode {
                    print("good status code")
                    print(dataContent)
                    
                    
                    if let countries = try? self.jsonDecoder.decode(DocumentsContainer.self, from: dataContent).documents  {
                        print("decoded countries")
                        completionHandler((countries, nil))
                        return
                    } else {
                        print("couldn´t decode")
                    }
                }
            }
            completionHandler((nil, nil))
            return
        }
        dataTask.resume()
    }
    
}

// Modelled after the Response to a correct login request
struct User: Codable {
    let localId: String
    let displayName: String
    let email: String
    let idToken: String
    let registered: Bool
    let profilePicture: String
    let examplePropertyThatDoesNotExistInJSON: String?
    let refreshToken: String?
}

// used to classify errors for further error messages and ease of use in the completion handler
enum NetworkingError {
    case failedRequest
    case invalidPassword
    case userDisabled
    case emailNotFound
}

// actual response with an error from the server for the login request
struct FirebaseResponseError: Decodable {
    let code: Int
    let message: String
    let errors: [NestedError]
    
    struct NestedError: Decodable {
        let message: String
        let domain: String
        let reason: String
    }
    
    private enum RootCodingKeys: String, CodingKey {
        case error
    }
    
    private enum NestedCodingKeys: String, CodingKey {
        case code, message, errors
    }
    
    //custom decoder for use of nested objects
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let nestedContainer = try rootContainer.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .error)
        code = try nestedContainer.decode(Int.self, forKey: .code)
        message = try nestedContainer.decode(String.self, forKey: .message)
        errors = try nestedContainer.decode([NestedError].self, forKey: .errors)
    }
}


extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
