//
//  Meme.swift
//  MemeMe_2.0
//
//  Created by Abdalfattah Altaeb on 4/10/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit

struct Meme{
    
    var top: String!
    var bottom: String!
    var originalImage: UIImage!
    var memedImage : UIImage!

    //Get a count of all Memes
    static func count() -> Int {
        return getMemeStorage().memes.count
    }

    //Locate the Meme storage location
    static func getMemeStorage() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

