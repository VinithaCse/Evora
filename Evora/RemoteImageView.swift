//
//  RemoteImage.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import SwiftUI

struct URLImage : View {

    init(isUserImage: Bool, urlString: String = "") {
        
        remoteImage = RemoteImage()
        remoteImage.load(isUserImage: isUserImage, urlString: urlString)
    }

    var body: some View {
        ZStack {
            switch remoteImage.loadingState {
                case .success(let image):
                image
                case .failure:
                    Text("")
            }
        }
    }

    @ObservedObject private var remoteImage: RemoteImage
}
