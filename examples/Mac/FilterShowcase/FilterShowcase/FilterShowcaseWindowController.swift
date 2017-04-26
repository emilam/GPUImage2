import Cocoa
import GPUImage
import AVFoundation

let blendImageName = "Lambeau.jpg"

class FilterShowcaseWindowController: NSWindowController {

    @IBOutlet var filterView: RenderView!
    @IBOutlet var settingsView: NSView!
    
    @IBOutlet weak var filterSlider: NSSlider!
    
    dynamic var currentSliderValue:Float = 0.5 {
        willSet(newSliderValue) {
            switch (currentFilterOperation!.sliderConfiguration) {
                case .enabled: currentFilterOperation!.updateBasedOnSliderValue(newSliderValue)
                case .disabled: break
            }
        }
    }
    
    var currentFilterOperation: FilterOperationInterface?
    var videoCamera:Camera!
    lazy var blendImage:PictureInput = {
        return PictureInput(imageName:blendImageName)
    }()
    var currentlySelectedRow = 1

    override func windowDidLoad() {
        super.windowDidLoad()

        do {
            videoCamera = try Camera(sessionPreset:AVCaptureSessionPreset1280x720)
            videoCamera.runBenchmark = true
            videoCamera.startCapture()
        } catch {
            fatalError("Couldn't initialize camera with error: \(error)")
        }
        self.changeSelectedRow(0)
    }
    
    func createSlider(index: Int, name: String, width: CGFloat) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: CGFloat(index * 40), width: width, height: 40))
        let slideLabel = NSTextField(frame: NSRect(x: 0, y: 0, width: settingsView.frame.width, height: 20))
        slideLabel.stringValue = name
        slideLabel.isBezeled = false
        slideLabel.isEditable = false
        slideLabel.isSelectable = false
        let slider = NSSlider(frame: NSRect(x: 0, y: 20, width: settingsView.frame.width, height: 20))
        
        view.addSubview(slideLabel)
        view.addSubview(slider)
        return view

    }
    func changeSelectedRow(_ row:Int) {
        guard (currentlySelectedRow != row) else { return }
        currentlySelectedRow = row
        for each in settingsView.subviews {
            each.removeFromSuperview()
        }
        settingsView.addSubview(self.createSlider(index: 0, name: "1", width: settingsView.frame.width))
        settingsView.addSubview(self.createSlider(index: 2, name: "2", width: settingsView.frame.width))

        
        // Clean up everything from the previous filter selection first
//        videoCamera.stopCapture()
        videoCamera.removeAllTargets()
        currentFilterOperation?.filter.removeAllTargets()
        currentFilterOperation?.secondInput?.removeAllTargets()
        
        currentFilterOperation = filterOperations[row]
        switch currentFilterOperation!.filterOperationType {
            case .singleInput:
                videoCamera.addTarget((currentFilterOperation!.filter))
                currentFilterOperation!.filter.addTarget(filterView!)
            case .blend:
                blendImage.removeAllTargets()
                videoCamera.addTarget((currentFilterOperation!.filter))
                self.blendImage.addTarget((currentFilterOperation!.filter))
                currentFilterOperation!.filter.addTarget(filterView!)
                self.blendImage.processImage()
            case let .custom(filterSetupFunction:setupFunction):
                currentFilterOperation!.configureCustomFilter(setupFunction(videoCamera!, currentFilterOperation!.filter, filterView!))
        }
        
        switch currentFilterOperation!.sliderConfiguration {
            case .disabled:
                filterSlider.isEnabled = false
                //                case let .Enabled(minimumValue, initialValue, maximumValue, filterSliderCallback):
            case let .enabled(minimumValue, maximumValue, initialValue):
                filterSlider.minValue = Double(minimumValue)
                filterSlider.maxValue = Double(maximumValue)
                filterSlider.isEnabled = true
                currentSliderValue = initialValue
        }
        
        videoCamera.startCapture()
    }

// MARK: -
// MARK: Table view delegate and datasource methods
    
    func numberOfRowsInTableView(_ aTableView:NSTableView!) -> Int {
        return filterOperations.count
    }
    
    func tableView(_ aTableView:NSTableView!, objectValueForTableColumn aTableColumn:NSTableColumn!, row rowIndex:Int) -> AnyObject! {
        let filterInList:FilterOperationInterface = filterOperations[rowIndex]
        return filterInList.listName as NSString
    }
    
    func tableViewSelectionDidChange(_ aNotification: Notification!) {
        if let currentTableView = aNotification.object as? NSTableView {
            let rowIndex = currentTableView.selectedRow
            self.changeSelectedRow(rowIndex)
        }
    }
}
