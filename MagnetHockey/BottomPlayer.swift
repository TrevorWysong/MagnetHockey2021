import SpriteKit

protocol BottomPlayerDelegate : AnyObject
{
    func bottomTouchIsActive(_ touchIsActive: Bool, fromBottomPlayer bottomPlayer: BottomPlayer)
}

class BottomPlayer: SKShapeNode
{
    //keep track of previous touch time (will use to calculate vector)
    var lastTouchTimeStamp: Double?
    
    //delegate will refer to class which will act on player force
    weak var delegate:BottomPlayerDelegate?
    
    //this will determine the allowable area for the player
    let activeArea:CGRect
    
    var bottomTouchIsActive = false
    
    
    //define player size
    var radius:CGFloat
    
    //when we instantiate the class we will set the active area
    init(activeArea: CGRect)
    {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        if UserDefaults.standard.string(forKey: "Game") != "Air Hockey"
        {
            if screenWidth > 700
            {
                radius = screenWidth/15
            }
            else
            {
                radius = screenWidth/11
            }
        }
        else
        {
            if screenWidth > 700
            {
                radius = screenWidth/12
            }
            else
            {
                radius = screenWidth/9
            }
        }
        
        //set the active area variable this class with the variable passed in
        self.activeArea = activeArea
        
        //ensure we pass the init call to the base class
        super.init()
        
        //allow the player to handle touch events
        isUserInteractionEnabled = true
        
        //create a mutable path (later configured as a circle)
        let circularPath = CGMutablePath()
        
        //define pi as CGFloat (type π using alt-p)
        let π = CGFloat.pi
        
               
        //create the circle shape
        circularPath.addArc(center: CGPoint(x: 0, y:0), radius: radius, startAngle: 0, endAngle: 2*π, clockwise: true)
        // CGPathAddArc(circularPath, nil, 0, 0, radius, 0, π*2, true)
        
        //assign the path to this SKShapeNode's path property
        path = circularPath
        
        lineWidth = 0;
        
        fillColor = .white
        fillTexture = SKTexture(imageNamed: "AirHockeyMallet1.png")
        
        //set physics properties (note physicsBody is an optional)
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.mass = 500;
        physicsBody?.categoryBitMask = BodyType.player.rawValue
        physicsBody!.affectedByGravity = false;
        physicsBody?.linearDamping = 1
        physicsBody?.angularDamping = 1
        physicsBody?.friction = 1

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        bottomTouchIsActive = true
        var releventTouch:UITouch!
        //convert set to known type
        let touchSet = touches
        //get array of touches so we can loop through them
        let orderedTouches = Array(touchSet)

        for touch in orderedTouches
        {
            //if we've not yet found a relevent touch
            if releventTouch == nil
            {
                //look for a touch that is in the activeArea (Avoid touches by opponent)
                if activeArea.contains(CGPoint(x: touch.location(in: parent!).x, y: touch.location(in: parent!).y + frame.height * 0.24))
                {
                    isUserInteractionEnabled = true
                    releventTouch = touch
                }
                else
                {
                    releventTouch = nil
                }
            }
        }
        
        if (releventTouch != nil) && lastTouchTimeStamp != nil
        {
            //get touch position and relocate player
            let location = CGPoint(x: releventTouch!.location(in: parent!).x, y: releventTouch!.location(in: parent!).y + frame.height * 0.24)
            position = location
            
            //find old location and use pythagoras to determine length between both points
            let oldLocation = CGPoint(x: releventTouch!.previousLocation(in: parent!).x, y: releventTouch!.previousLocation(in: parent!).y + frame.height * 0.24)
            let xOffset = location.x - oldLocation.x
            let yOffset = location.y - oldLocation.y
            let vectorLength = sqrt(xOffset * xOffset + yOffset * yOffset)
            let seconds = releventTouch.timestamp - lastTouchTimeStamp!
            let velocity = 0.015 * Double(vectorLength) / seconds
            //to calculate the vector, the velcity needs to be converted to a CGFloat
            let velocityCGFloat = CGFloat(velocity)
            
            
            // NSUserDefaults for more direct access in collision detection
            let forceSaveDX = UserDefaults.standard
            forceSaveDX.set(velocityCGFloat * xOffset / vectorLength, forKey: "BottomForceDX")
            forceSaveDX.synchronize()
            
            let forceSaveDY = UserDefaults.standard
            forceSaveDY.set(velocityCGFloat * yOffset / vectorLength, forKey: "BottomForceDY")
            forceSaveDY.synchronize()
            
            let velocitySave = UserDefaults.standard
            velocitySave.set(velocityCGFloat, forKey: "BottomVelocity")
            velocitySave.synchronize()
            
            //Only apply an impulse if the touch is active.
            delegate?.bottomTouchIsActive(bottomTouchIsActive, fromBottomPlayer: self)

            //update latest touch time for next calculation
            lastTouchTimeStamp = releventTouch.timestamp
        }
        else if (releventTouch != nil) && lastTouchTimeStamp == nil
        {
            //get touch position and relocate player
            let location = CGPoint(x: releventTouch!.location(in: parent!).x, y: releventTouch!.location(in: parent!).y + frame.height * 0.24)
            position = location
            
           //update latest touch time for next calculation
            lastTouchTimeStamp = releventTouch.timestamp
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        bottomTouchIsActive = false
        delegate?.bottomTouchIsActive(bottomTouchIsActive, fromBottomPlayer: self)
    }
}

