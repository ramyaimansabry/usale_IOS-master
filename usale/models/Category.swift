//
//  Category.swift
//  usale
//
//  Created by Ahmed masoud on 7/29/18.
//  Copyright © 2018 Usale. All rights reserved.
//

import Foundation
import UIKit

class Category {
    let id: Int!
    let name: String!
    let image: UIImage!
    
    private init(id: Int, name: String, image: UIImage) {
        self.id = id
        self.name = name
        self.image = image
    }
    
    static func populateCategories() -> [Category]{
        /*
         1. Food & Beverage
         2. Women's clothing
         3. Beauty & personal care
         4. Health & Fitness
         5. Education
         6. Entertainment
         7. Men's clothing
         8. Men's shoes
         9. Sports wear
         */
        return [
            Category(id: 1, name: "Food & Beverage", image: #imageLiteral(resourceName: "food.png")),
//            Category(id: 2, name: "Women's Clothing", image: #imageLiteral(resourceName: "womenClothing.png")),
//            Category(id: 3, name: "Beauty & Personal Care", image: #imageLiteral(resourceName: "beauty.png")),
            Category(id: 4, name: "Health & Fitness", image: #imageLiteral(resourceName: "health.png")),
            Category(id: 5, name: "Education", image: #imageLiteral(resourceName: "Education.png")),
            Category(id: 6, name: "Entertainment", image: #imageLiteral(resourceName: "entertainment.png")),
//            Category(id: 7, name: "Men's Clothing", image: #imageLiteral(resourceName: "mensFashion.png")),
//            Category(id: 8, name: "Men's Footwear", image: #imageLiteral(resourceName: "menShoes.png")),
//            Category(id: 9, name: "Sports Wear", image: #imageLiteral(resourceName: "sportsWear.png"))
        ]
    }
    
}
