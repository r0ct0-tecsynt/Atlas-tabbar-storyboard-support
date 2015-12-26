import UIKit
import Atlas

class ConversationViewController: ATLConversationViewController, ATLConversationViewControllerDataSource, ATLConversationViewControllerDelegate, ATLParticipantTableViewControllerDelegate {
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    var searchCallback: (([AnyObject]) -> Void) = {_ in }
    var conversationListViewController: ConversationsListController!
    
    //MARK: - SINGLETON
    
    static func shared(layerClient:LYRClient) -> ConversationViewController {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ConversationViewController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ConversationViewController(layerClient: layerClient)
        }
        return Static.instance!
        
    }
    
    class var sharedInstance: ConversationViewController {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ConversationViewController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ConversationViewController()
        }
        return Static.instance!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        self.addressBarController?.delegate = self
        // Uncomment the following line if you want to show avatars in 1:1 conversations
         self.shouldDisplayAvatarItemForOneOtherParticipant = true
        
        // Setup the dateformatter used by the dataSource.
        self.dateFormatter.dateFormat = "dd MMM yy"
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let composeItem = UIBarButtonItem(image: UIImage(named: "options-1"), style: UIBarButtonItemStyle.Bordered, target: self, action: "detailsButtonTapped")
        
        let searchItem = UIBarButtonItem(image: UIImage(named: "search-1"), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        
        self.navigationItem.setRightBarButtonItems([composeItem, searchItem], animated: false)
        
//        self.messageInputToolbar.inputToolBarDelegate = self
        
        self.configureUI()


    }
    

    func configureUI() {

    }

    // MARK - ATLConversationViewControllerDelegate methods

    func conversationViewController(viewController: ATLConversationViewController, didSendMessage message: LYRMessage) {
        print("Message sent!")
    }

    func conversationViewController(viewController: ATLConversationViewController, didFailSendingMessage message: LYRMessage, error: NSError?) {
        print("Message failed to sent with error: \(error)")
    }

    func conversationViewController(viewController: ATLConversationViewController, didSelectMessage message: LYRMessage) {
        print("Message selected")
    }

    // MARK - ATLConversationViewControllerDataSource methods

    func conversationViewController(conversationViewController: ATLConversationViewController, participantForIdentifier participantIdentifier: String) -> ATLParticipant? {
        return nil
    }

    func conversationViewController(conversationViewController: ATLConversationViewController, attributedStringForDisplayOfDate date: NSDate) -> NSAttributedString? {
        let attributes: NSDictionary = [ NSFontAttributeName : UIFont.systemFontOfSize(9), NSForegroundColorAttributeName : UIColor.grayColor() ]
        return NSAttributedString(string: self.dateFormatter.stringFromDate(date), attributes: attributes as? [String : AnyObject])
    }

    func conversationViewController(conversationViewController: ATLConversationViewController, attributedStringForDisplayOfRecipientStatus recipientStatus: [NSObject:AnyObject]) -> NSAttributedString? {
        if (recipientStatus.count == 0) {
            return nil
        }
        let mergedStatuses: NSMutableAttributedString = NSMutableAttributedString()
        
        let recipientStatusDict = recipientStatus as NSDictionary
        let allKeys = recipientStatusDict.allKeys as NSArray
        allKeys.enumerateObjectsUsingBlock { participant, _, _ in
            let participantAsString = participant as! String
            if (participantAsString == self.layerClient.authenticatedUserID) {
                return
            }

            let checkmark: String = "✔︎"
            var textColor: UIColor = UIColor.lightGrayColor()
            let status: LYRRecipientStatus! = LYRRecipientStatus(rawValue: Int(recipientStatusDict[participantAsString]!.unsignedIntegerValue))
            switch status! {
            case .Sent:
                textColor = UIColor.lightGrayColor()
            case .Delivered:
                textColor = UIColor.orangeColor()
            case .Read:
                textColor = UIColor.greenColor()
            default:
                textColor = UIColor.lightGrayColor()
            }
            let statusString: NSAttributedString = NSAttributedString(string: checkmark, attributes: [NSForegroundColorAttributeName: textColor])
            mergedStatuses.appendAttributedString(statusString)
        }
        return mergedStatuses;
    }

    // MARK - ATLAddressBarViewController Delegate methods methods

    override func addressBarViewController(addressBarViewController: ATLAddressBarViewController, didTapAddContactsButton addContactsButton: UIButton) {
    }

    override func addressBarViewController(addressBarViewController: ATLAddressBarViewController, searchForParticipantsMatchingText searchText: String, completion: (([AnyObject]) -> Void)?) {
    }

    // MARK - ATLParticipantTableViewController Delegate Methods

    func participantTableViewController(participantTableViewController: ATLParticipantTableViewController, didSelectParticipant participant: ATLParticipant) {
        print("participant: \(participant)")
        self.addressBarController.selectParticipant(participant)
        print("selectedParticipants: \(self.addressBarController.selectedParticipants)")
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }

    func participantTableViewController(participantTableViewController: ATLParticipantTableViewController, didSearchWithString searchText: String, completion: ((Set<NSObject>!) -> Void)?) {
    }
       //MARK: - APPEAR METHODS
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        if (self.conversation == nil) {
            return
        }
         
    }

}
