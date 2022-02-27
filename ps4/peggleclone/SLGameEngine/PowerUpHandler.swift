//
//  PowerUpHandler.swift
//  peggleclone
//
//  Created by Stuart Long on 24/2/22.
//

import Foundation
import SwiftUI

class PowerUpHandler {
    private var spookyBallsActivated = 0

    func handlePowerUp(
        powerPeg: Peg, mappings: [PeggleObject: SLPhysicsBody],
        cannonBall: Peg, gameDisplayDelegate: GameDisplayDelegate) {
        if let spookyPeg = powerPeg as? SpookyPeg {
            if !spookyPeg.activated {
                spookyBallsActivated += 1
                spookyPeg.setActivated()
            }
        } else if let kaboomPeg = powerPeg as? KaboomPeg {
            if !kaboomPeg.activated {
                // find area of hit
                for (key, value) in mappings where isWithinExplosionRadius(kaboomPeg: kaboomPeg, physicsBody: value) {
                    if let peg = key as? Peg {
                        peg.glow()
                        value.setCollided()
                    }
                }
                // move ball back
                guard let cannonBallPhysicsBody = mappings[cannonBall] else {
                    return
                }
                if isWithinExplosionRadius(kaboomPeg: kaboomPeg, physicsBody: cannonBallPhysicsBody) {
                    let forceDirection = kaboomPeg.center.vectorTo(point: cannonBallPhysicsBody.position)
                    let distance = kaboomPeg.center.distanceFrom(point: cannonBallPhysicsBody.position)
                    let ratio = 25 * (1 - distance / kaboomPeg.radiusOfExplosion)
                    cannonBallPhysicsBody.addForceToVelocity(force: forceDirection.multiplyWithScalar(scalar: ratio))
                }
                kaboomPeg.setActivated()
            }
            gameDisplayDelegate.renderExplosion(kaboomPeg: kaboomPeg)
        }
    }

    private func isWithinExplosionRadius(kaboomPeg: KaboomPeg, physicsBody: SLPhysicsBody) -> Bool {
        kaboomPeg.center.distanceFrom(point: physicsBody.position) <= kaboomPeg.radiusOfExplosion + physicsBody.width
    }

    func removePowerPeg(powerPeg: Peg) {
        if let spookyPeg = powerPeg as? SpookyPeg {
            spookyPeg.setNotActivated()
        } else if let kaboomPeg = powerPeg as? KaboomPeg {
            kaboomPeg.setNotActivated()
        }
    }

    func handleCannonBall(
        canvasDimension: CGRect, cannonBall: Peg, cannonBallPhysicsBody: SLPhysicsBody,
        gameDisplayDelegate: GameDisplayDelegate) {
        if spookyBallsActivated > 0 {
            gameDisplayDelegate.spookCannonBall(cannonBall: cannonBall)
        }

        if spookyBallsActivated > 0 && isOutOfScreen(peg: cannonBall, canvasDimensions: canvasDimension) {
            gameDisplayDelegate.didMove(peggleObject: cannonBall,
                                        newLocation: Point(xCoordinate: cannonBall.center.xCoordinate, yCoordinate: 0))
            cannonBallPhysicsBody.moveTo(position: Point(xCoordinate: cannonBall.center.xCoordinate, yCoordinate: 0))
            cannonBallPhysicsBody
                .setVelocity(newVelocity: cannonBallPhysicsBody.velocity.multiplyWithScalar(scalar: 0.5))
            spookyBallsActivated -= 1
        }
    }

    private func isOutOfScreen(peg: Peg, canvasDimensions: CGRect) -> Bool {
        peg.center.yCoordinate >= canvasDimensions.height + peg.radius
    }

    func resetCount() {
        self.spookyBallsActivated = 0
    }
}
