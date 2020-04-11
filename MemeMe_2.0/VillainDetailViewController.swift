//
//  VillainDetailViewController.swift
//  MemeMe_2.0
//
//  Created by Abdalfattah Altaeb on 4/10/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit

class VillainDetailViewController: UIViewController {
    var meme: Meme!


    @IBOutlet weak var imageCell: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.imageCell!.image = meme.memedImage

    }
}
