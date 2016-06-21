//
//  ViewController.swift
//  JSONCreate
//
//  Created by Vlad Soroka on 1/11/16.
//  Copyright © 2016 com.Jonathan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func chooseFile(sender: AnyObject) {
        let openPanel =  NSOpenPanel()
        
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["csv"]
        
        // Display the dialog.  If the OK button was pressed,
        // process the files.
        if (openPanel.runModal() == NSModalResponseOK)
        {
            let csvURL = openPanel.URLs.first!
            let records = VideoRecord.VideoRecordFrom(csvFileURL: csvURL)
            guard records.1 == nil else {
                self.showAlertWithMessage(records.1!)
                return
            }
            
            let data = records.0
            
            let path = NSSearchPathForDirectoriesInDomains(.DesktopDirectory, .UserDomainMask, true).first!
            let fileName = (csvURL.lastPathComponent! as NSString).stringByDeletingPathExtension + ".json"
            let URL = NSURL(fileURLWithPath: path + "/" + fileName)
            data?.writeToURL(URL, atomically: true)
            
            NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs([URL])
        }
    }

    func showAlertWithMessage(message: String)
    {
        let alert = NSAlert()
        alert.addButtonWithTitle("Ok")
        alert.messageText = "Error"
        alert.informativeText = message
        alert.alertStyle = .CriticalAlertStyle
        alert.runModal()
        /// hello
    }
    
    
    
}

