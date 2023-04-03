//
//  Constants.swift
//  m15
//
//  Created by Nursultan Konspayev on 25.03.2023.
//

import UIKit

//MARK: - Creating constants - texts, colors and fonts
enum Constants {
    enum Color {
        static var WB: UIColor? {
            UIColor(named: "WB")
        }
        
        static var BW: UIColor? {
            UIColor(named: "BW")
        }
        
        static var Gray01: UIColor? {
            UIColor(named: "Gray01")
        }
        
        static var Gray02: UIColor? {
            UIColor(named: "Gray02")
        }
    }
    
    enum Font {
        static var header: UIFont? {
            UIFont(name: "Inter-SemiBold", size: 16)
        }
        
        static var text: UIFont? {
            UIFont(name: "Inter-Regular", size: 14)
        }
        
        static var ago: UIFont? {
            UIFont(name: "Inter-Regular", size: 14)
        }
    }
    
    enum Text {
        static var header: String {
            String("Header")
        }
        
        static var text: String {
            String("He'll want to use your yacht, and I don't want this thing smelling like fish.")
        }
        
        static var ago: String {
            String("8m ago")
        }
    }
}
