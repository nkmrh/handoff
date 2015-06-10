import UIKit
import Security
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SecRequestSharedWebCredential(nil, nil) { (credentials: CFArray!, error: CFError!) -> Void in
            if let error = error {
                println("error: \(error)")
            } else if CFArrayGetCount(credentials) > 0 {
                let unsafeCredential = CFArrayGetValueAtIndex(credentials, 0)
                let credential: CFDictionaryRef = unsafeBitCast(unsafeCredential, CFDictionaryRef.self)
                let dict: Dictionary<String, String> = credential as! Dictionary<String, String>
                let username = dict[kSecAttrAccount as String]
                let password = dict[kSecSharedPassword.takeRetainedValue() as! String]
                dispatch_async(dispatch_get_main_queue()) {
                    self.textView.text = "Account:" + username! + "\nPassword:" + password!
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.textView.text = CFErrorCopyDescription(error) as! String
                    return
                }
            }
        }

        self.userActivity = NSUserActivity(activityType: "handoff")
        self.userActivity!.webpageURL = NSURL(string: "http://blog.hajimenakamura.jp")
    }

    override func restoreUserActivityState(activity: NSUserActivity)
    {
    }
}