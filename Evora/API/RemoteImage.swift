//
//  RemoteImage.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import Foundation

import SwiftUI
import Combine

final class RemoteImage : ObservableObject {

    enum LoadingState {

        case success(_ image: Image)

        case failure
    }
    
    var userViewModel: UserViewModel = UserViewModel()
    
    @Published var loadingState: LoadingState = .failure
    
    private var cancellable: AnyCancellable?

    var url: URL?
    
    init() {
        
    }

    func load(isUserImage: Bool, urlString: String) {
        
        if isUserImage {
            self.userViewModel.getData(completionHandler: {
                isCompleted in
                if isCompleted {
                    
                    guard let url = URL(string: self.userViewModel.user.profileKey) else {
                        return
                    }
                    self.url = url
                    
                    self.cancellable = URLSession(configuration: .default)
                        .dataTaskPublisher(for: self.url!)
                        .map {
                            guard let value = UIImage(data: $0.data) else {
                                return .failure
                            }

                            return .success(Image(uiImage: value).resizable())
                        }
                        .catch { _ in
                            Just(.failure)
                        }
                        .receive(on: RunLoop.main)
                        .assign(to: \.loadingState, on: self)
                }
            })
        } else {
            
            guard let url = URL(string: urlString) else {
                return
            }
            self.url = url
            
            self.cancellable = URLSession(configuration: .default)
                .dataTaskPublisher(for: self.url!)
                .map {
                    guard let value = UIImage(data: $0.data) else {
                        return .failure
                    }

                    return .success(Image(uiImage: value).resizable())
                }
                .catch { _ in
                    Just(.failure)
                }
                .receive(on: RunLoop.main)
                .assign(to: \.loadingState, on: self)
        }
    }
}
