//
//  7.swift
//  apiApp
//
//  Created by Apple on 15.01.2021.
//

import UIKit

extension ViewController {
    
    func addShadow(){
        customView.layer.shadowColor = UIColor.black.cgColor
        customView.layer.shadowRadius = 4
        customView.layer.shadowOffset = CGSize(width: 1, height: 1)
        customView.layer.shadowOpacity = 0.5
        
        customViewButton.layer.shadowColor = UIColor.black.cgColor
        customViewButton.layer.shadowRadius = 4
        customViewButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        customViewButton.layer.shadowOpacity = 0.5
    }
    
    func setupBlurViews(){
        blurViewTable.clipsToBounds = true
        blurViewTable.layer.cornerRadius = 20
        blurViewTable.translatesAutoresizingMaskIntoConstraints = false
        customView.insertSubview(blurViewTable, at: 0)
        blurViewTable.heightAnchor.constraint(equalTo: customView.heightAnchor).isActive = true
        blurViewTable.widthAnchor.constraint(equalTo: customView.widthAnchor).isActive = true
        
        blurViewButton.clipsToBounds = true
        blurViewButton.layer.cornerRadius = 20
        blurViewButton.translatesAutoresizingMaskIntoConstraints = false
        customViewButton.insertSubview(blurViewButton, at: 0)
        blurViewButton.heightAnchor.constraint(equalTo: customViewButton.heightAnchor).isActive = true
        blurViewButton.widthAnchor.constraint(equalTo: customViewButton.widthAnchor).isActive = true
    }
    
    func setupVibrancyViews(){
        vibrancyViewTable.translatesAutoresizingMaskIntoConstraints = false
        vibrancyViewTable.heightAnchor.constraint(equalTo: blurViewTable.heightAnchor).isActive = true
        vibrancyViewTable.widthAnchor.constraint(equalTo: blurViewTable.widthAnchor).isActive = true
        
        vibrancyViewButton.translatesAutoresizingMaskIntoConstraints = false
        vibrancyViewButton.heightAnchor.constraint(equalTo: blurViewButton.heightAnchor).isActive = true
        vibrancyViewButton.widthAnchor.constraint(equalTo: blurViewButton.widthAnchor).isActive = true
    }
    
    func setupViews(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalTo: vibrancyViewTable.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: vibrancyViewTable.widthAnchor).isActive = true
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.heightAnchor.constraint(equalTo: vibrancyViewButton.heightAnchor).isActive = true
        buttonStackView.widthAnchor.constraint(equalTo: vibrancyViewButton.widthAnchor).isActive = true
    }

}

