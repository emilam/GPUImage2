public class ContrastAdjustment: BasicOperation {
    public var contrast:Float = 1.0 { didSet { uniformSettings["contrast"] = contrast } }
    
    public init() {
        super.init(fragmentShader:ContrastFragmentShader, numberOfInputs:1)
        
        ({contrast = 1.0})()
    }
}


public class BlackWhite: BasicOperation {
    public init() {
        super.init(fragmentShader:BlackWhiteFragmentShader, numberOfInputs:1)
        
    }
}

public class ColorClamp: BasicOperation {
    public init() {
        super.init(fragmentShader:ColorClampFragmentShader, numberOfInputs:1)
        
    }
}
