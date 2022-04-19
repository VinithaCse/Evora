//
//  APIConfigurator.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import Foundation

struct APIConfigurator {
    
    var json: [String: Any] = [:]
    var method: HTTPMethod  = .get
    var url: String = ""
    
    
    init(jsonValue: [String:Any], httpMethod: HTTPMethod, urlToBeCalled: String) {
        
        self.json = jsonValue
        self.method = httpMethod
        self.url = urlToBeCalled
    }
}

enum HTTPMethod : String {
    
    case post = "POST" , put = "PUT", get = "GET"
    
    var isEitherPUTorPOST: Bool {
        return self == .post || self == .put
    }
}

class APIHandler {
    
    class func getURLRequest(with configuration: APIConfigurator, completionHandler: @escaping (_ request: URLRequest?, _ errorMessage: String?) -> Void) {
        
        let urlString = configuration.url
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            var body : Data?
            if configuration.method.isEitherPUTorPOST {
                
                let jsonData = try! JSONSerialization.data(withJSONObject: configuration.json, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                if let encodedJSON = String(data: jsonData, encoding: String.Encoding.utf8), !encodedJSON.isEmpty,
                    let jsonString = encodedJSON.replacingOccurrences(of: "\n", with: "").encodedString {
                    body = Data()
                    
                    let headerContent = "JSONString=\(jsonString)&"
                    body?.append(headerContent.data(using: String.Encoding.ascii, allowLossyConversion: true)!)
                }

                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                if(body != nil) {
                    request.setValue("\(body!.count)", forHTTPHeaderField: "Content-Length")
                    request.httpBody = body
                }
            }
            
            completionHandler(request, nil)
        } else {
            completionHandler(nil, "Request Not Formed")
        }
    }
    
    class func performRequest(with configuration: APIConfigurator, completionHandler: @escaping (Data?, URLResponse?, String?) -> Void) {
        
        APIHandler.getURLRequest(with: configuration) { (urlRequest, error) in
            
            guard let request = urlRequest else {
                DispatchQueue.main.async{
                    completionHandler(nil, nil, error)
                }
                return
            }
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            let task = session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    
                    completionHandler(data, urlResponse, error?.localizedDescription)
                }
            })
            
            task.resume()
            
        }
    }
}

extension String {
    
    var encodedString: String? {
        let allowedCharSet = CharacterSet(charactersIn:"~!%*()-_|#;/?:@&=$+{}<>'\".^, \n").inverted
        let result = self.addingPercentEncoding(withAllowedCharacters: allowedCharSet)
        return result
    }
}
