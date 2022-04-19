//
//  UserViewModel.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var user: UserModel = UserModel()
    
    func getData(completionHandler: @escaping(_ isCompleted: Bool) -> Void) {
        
        let apiConfig = APIConfigurator(jsonValue: [:], httpMethod: .get, urlToBeCalled: "http://assessment.api.vweb.app/user")
        
        UserApi.getUserAPI(configuration: apiConfig, completionHandler: {
            [weak self] userModel in
            
            if let self = self {
                self.user = userModel
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }
    
}
