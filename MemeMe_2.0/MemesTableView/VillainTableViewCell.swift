//
//  VillainTableViewCell.swift
//  MemeMe_2.0
//
//  Created by Abdalfattah Altaeb on 4/10/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit

class VillainTableViewCell: UITableViewCell {

    //MARK: Properties

    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!

    //MARK: Custom Cell's Functions

    func updateCell(_ meme: Meme) {

        //update cell's view
        memedImage.image = meme.memedImage
        topText.text = meme.top as String?
        bottomText.text = meme.bottom as String?
    }
}
