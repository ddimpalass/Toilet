//
//  8.swift
//  apiApp
//
//  Created by Дмитрий on 15.01.2021.
//

import UIKit

extension ViewController {
    
    func animationShow(){
        customView.isHidden = false
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                        guard let self = self else { return }

                        self.customView.bounds.origin.y += self.customView.bounds.height
                        self.customView.layoutIfNeeded()
        })
    }
    
    func animationHide(){
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        
                        self.customView.bounds.origin.y -= self.customView.bounds.height
                        self.customView.layoutIfNeeded()
        }) { _ in
            self.customView.isHidden = true
        }
    }
}
