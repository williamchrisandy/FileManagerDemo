//
//  Photo.swift
//  FileManagerDemo
//
//  Created by William Chrisandy on 13/07/22.
//

import UIKit

class Photo
{
    var image: UIImage?
    var name: String?
    
    init(image: UIImage? = nil, name: String? = nil)
    {
        self.image = image
        self.name = name
    }
}
