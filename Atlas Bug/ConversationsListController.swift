//
//  ConversationsListController.swift
//  SSUKI
//
//  Created by Rostislav on 12/2/15.
//  Copyright © 2015 Alexey Zayakin. All rights reserved.
//

import UIKit
import Atlas


class SIConversation {
    var users = []
    var title = ""
}

class ConversationsListController: ATLConversationListViewController, ATLConversationListViewControllerDelegate, ATLConversationListViewControllerDataSource {

    var conversationUsers = NSMutableDictionary(dictionary: [:])
    var conversationsWithUsers: Dictionary <String,SIConversation> = Dictionary()
    var convCotnroler: ConversationViewController?
    override func viewDidLoad()
    {

        if let app = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            self.layerClient = app.layerClient;
        }
        self.convCotnroler = ConversationViewController.shared(self.layerClient)
        super.viewDidLoad()
        
        self.navigationItem.title = "MESSAGES"

        self.title = ""
        self.accessibilityLabel = ""
        
        self.dataSource = self
        self.delegate = self
        
        self.deletionModes = [0]
        

        self.rowHeight = 50.0
        
        self.displaysAvatarItem = true
        
//        
        let composeItem = UIBarButtonItem(image: UIImage(named: "msg"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("composeButtonTapped:"))
//
        let searchItem = UIBarButtonItem(image: UIImage(named: "search-1"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        let ite = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action:  Selector("composeButtonTapped:"))
//
       let emptyItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.setRightBarButtonItems([ite], animated: false)
        self.navigationItem.setLeftBarButtonItems([emptyItem], animated: false)
        
   
        

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Layer Delegate Methods
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didSelectConversation conversation:LYRConversation)
    {
    }
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didDeleteConversation conversation: LYRConversation, deletionMode: LYRDeletionMode) {
        print("Conversation deleted")
    }
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didFailDeletingConversation conversation: LYRConversation, deletionMode: LYRDeletionMode, error: NSError?) {
        print("Failed to delete conversation with error: \(error)")
    }
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didSearchForText searchText: String, completion: ((Set<NSObject>!) -> Void)?) {
    }
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController!, avatarItemForConversation conversation: LYRConversation!) -> ATLAvatarItem! {
            return nil
    }
    
    //MARK: - Layer DataSource Methods
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController, titleForConversation conversation: LYRConversation) -> String {
        var result = ""
        return result
    }

    //MARK: - Actions
    
    func composeButtonTapped(sender: AnyObject) {
        self.convCotnroler!.displaysAddressBar = true
        do {
//            try self.convCotnroler!.conversation = self.layerClient.newConversationWithParticipants("poctuclab@gmail.com", options: nil)
        }
        catch
        {
            
        }
        
        self.convCotnroler!.title = "Hello"
        
        self.navigationController?.pushViewController(self.convCotnroler!, animated: true)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
