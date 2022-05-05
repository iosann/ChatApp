//
//  ImageParser.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation
import UIKit

class ImageParser: IParser {
    typealias Model = UIImage
    
    func parse(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
