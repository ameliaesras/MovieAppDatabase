//
//  ImagesDownloader.swift
//  TMDB
//
//  Created by Amelia Esra S on 01/02/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import Foundation
import UIKit

var vSpinner : UIView?

//MARK: Extension of UIViewController
extension UIViewController {
    
    func showLoading(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
      
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeLoading() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}


