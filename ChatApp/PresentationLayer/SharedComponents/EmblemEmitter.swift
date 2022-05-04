//
//  EmblemEmitter.swift
//  ChatApp
//
//  Created by Anna Belousova on 04.05.2022.
//

import UIKit
import QuartzCore

protocol IEmblemEmitter {
    func showEmblemFlow(into position: CGPoint, on view: UIView)
    func stopAnimation(on view: UIView)
}

class EmblemEmitter: IEmblemEmitter {
    
    private lazy var emblemCell: CAEmitterCell = {
        let emblemCell = CAEmitterCell()
        emblemCell.contents = UIImage(named: "emblem")?.cgImage
        emblemCell.scale = 0.3
        emblemCell.scaleRange = 0.5
        emblemCell.scaleSpeed = -0.1
        emblemCell.lifetime = 5
        emblemCell.birthRate = 100
        emblemCell.velocity = 100
        emblemCell.velocityRange = 50
        emblemCell.alphaSpeed = -0.4
        emblemCell.beginTime = 1.5
        emblemCell.emissionRange = .pi * 2
        emblemCell.spin = 2
        return emblemCell
    }()
    
    private lazy var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterCells = [emblemCell]
        emitterLayer.renderMode = .additive
        emitterLayer.emitterMode = .surface
        emitterLayer.birthRate = 1
        return emitterLayer
    }()
    
    func showEmblemFlow(into position: CGPoint, on view: UIView) {
        emitterLayer.emitterPosition = position
        emitterLayer.emitterSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        view.layer.addSublayer(emitterLayer)
    }
    
    func stopAnimation(on view: UIView) {
        emitterLayer.birthRate = 0
    }
}
