import Foundation

//ball parameter
let ball = OvalShape(width: 40, height: 40)

//barrier parameter
var barriers: [Shape] = []

var targets: [Shape] = []

//funnel parameter
let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]
let funnel = PolygonShape(points:
   funnelPoints)





///subsetup functions starting below


func addTarget(at position:Point) {
    let targetPoints = [
            Point(x: 10, y: 0),
            Point(x: 0, y: 10),
            Point(x: 10, y: 20),
            Point(x: 20, y: 10)
        ]
    
    let target = PolygonShape(points:
           targetPoints)
    
    targets.append(target)
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    target.name = "target"
    target.isDraggable=false
    scene.add(target)
}


fileprivate func setupball() {
    //adding a ball
    ball.position = Point(x: 250, y: 400)
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.isDraggable = false
    ball.bounciness = 0.2
    scene.add(ball)
}

fileprivate func addBarrier(at position: Point, width:Double, height:Double,angle:Double) {
    //adding a barrier
    let barrierPoints = [
            Point(x: 0, y: 0),
            Point(x: 0, y: height),
            Point(x: width, y: height),
            Point(x: width, y: 0)
        ]
    let barrier = PolygonShape(points:
           barrierPoints)
    barriers.append(barrier)
    
    barrier.position = position
    barrier.hasPhysics = true
    barrier.isImmobile = true
    barrier.angle = angle
    scene.add(barrier)
}

fileprivate func setupfunnel() {
    //adding a funnael
    funnel.position = Point(x: 200, y:
                                scene.height - 25)
    funnel.isDraggable = false
    scene.add(funnel)
}

// Drops the ball by moving it to the funnel's position.
func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for target in targets {
        target.fillColor = .yellow
    }
    
    for barrier in barriers{
        barrier.isDraggable = false
    }
}

// Handles collisions between the ball andthe targets.
func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    
    otherShape.fillColor = .green
}

func alertDismissed() {
}


func ballExitedScene() {
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!",completion: alertDismissed)
    }
    
    for barrier in barriers {
        barrier.isDraggable = true
    }
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

// Resets the game by moving the ball below the scene,
// which will unlock the barriers.
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

///setup function below here



func setup() {
    scene.presentAlert(text: "Tap the funnel to release the ball. Drag the barriers to make it touch all the targets. GOOD LUCK!",completion: alertDismissed)
    setupball()
    //addBarrier(at: Point(x: 200, y: 150),width: 80, height: 25, angle: 0.1)
    setupfunnel()
    //addTarget(at: Point(x: 150, y: 400))

    //adding function to onTapped property of funnel
    funnel.onTapped = dropBall
    ball.onCollision = ballCollided(with:)
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    scene.onShapeMoved = printPosition(of:)

    addBarrier(at: Point(x: 278, y: 198), width: 150,
       height: 15, angle: 0.4)
    addBarrier(at: Point(x: 246, y: 261), width: 90,
       height: 10, angle: -0.3)
    addBarrier(at: Point(x: 307, y: 125), width: 100,
       height: 25, angle: 0.3)
    
    addTarget(at: Point(x: 111, y: 473))
    addTarget(at: Point(x: 131, y: 172))
    
    for target in targets{
        printPosition(of: target)
    }
    
    for barrier in barriers{
        printPosition(of: barrier)
    }
    
    
    resetGame()
}



