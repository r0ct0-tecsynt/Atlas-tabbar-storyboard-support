//
//  AppDelegate.swift
//  SSUKI
//
//  Created by Alexey Zayakin on 23.09.15.
//  Copyright © 2015 Alexey Zayakin. All rights reserved.
//

import UIKit
import Atlas

#if TARGET_IPHONE_SIMULATOR
let DeviceMode = "Simulator";
#else
let DeviceMode = "Device";
#endif
typealias AuthenticationCompletionBlock = (error: NSError?) -> Void
typealias IdentityTokenCompletionBlock  = (String?, NSError?) -> Void
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate
{
    var apns_token = ""
    let locationUpdateTime = -600.0
    
    var window: UIWindow?
    
    
    //MARK: LAYER SETUP
    
    var layerClient: LYRClient!
    
    //MARK: SOCIAL SETUP
    //MARK: - SOCIAL SETUP
    
    //MARK: - GENERAL SETUP
    
    func showSimpleAlertWithText(text:String)
    {
        let alert : UIAlertController = UIAlertController(title: "", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        self.setupLayer()
        
        if (DeviceMode  == "Simulator")
        {
            self.apns_token = "6ef4ceef541ebc1b33a76a6173785674a9d7160c4786fe31a742c3cb07c37113"//TERMINAL
            
//            let tokenData = self.apns_token.dataUsingEncoding(NSUTF8StringEncoding)
//            assert(self.layerClient != nil, "The Layer client has not been initialized!")
//            do
//            {
//                try self.layerClient.updateRemoteNotificationDeviceToken(tokenData)
//                print("Application did register for remote notifications: \(tokenData)")
//                
//            }
//            catch let error as NSError
//            {
//                print("Failed updating device token with error: \(error)")
//            }
        }
        
        
        //MARK: - REGISTERING USER NOTIFICATIONS
        
//        let types: UIUserNotificationType = UIUserNotificationType.Badge
//        
//        let settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
//        application.registerUserNotificationSettings( settings )
//        application.c()
        
        //MARK: - REGISTERING LOCATION UPDATES
        
        return true
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        print( deviceTokenString )
        
        
        assert(self.layerClient != nil, "The Layer client has not been initialized!")
        do
        {
            try self.layerClient.updateRemoteNotificationDeviceToken(deviceToken)
            print("Application did register for remote notifications: \(deviceToken)")
        } catch let error as NSError {
            print("Failed updating device token with error: \(error)")
        }
        
        
        
    }
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError )
    {
        print( error.localizedDescription )
        
    }
    
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: LAYER METHODS
    
    func getBackgroundFetchResult(changes: [AnyObject]!, error: NSError!) -> UIBackgroundFetchResult {
        if changes?.count > 0 {
            return UIBackgroundFetchResult.NewData
        }
        return error != nil ? UIBackgroundFetchResult.Failed : UIBackgroundFetchResult.NoData
    }
    
    func conversationFromRemoteNotification(remoteNotification: [NSObject : AnyObject]) -> LYRConversation {
        let layerMap = remoteNotification["layer"] as! [String: String]
        let conversationIdentifier = NSURL(string: layerMap["conversation_identifier"]!)
        return self.existingConversationForIdentifier(conversationIdentifier!)!
    }
    
    func navigateToViewForConversation(conversation: LYRConversation) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
//            self.showModalVCWithStoryBoardID("ConversationViewController")
        });
    }
    
    func existingConversationForIdentifier(identifier: NSURL) -> LYRConversation? {
        let query: LYRQuery = LYRQuery(queryableClass: LYRConversation.self)
        query.predicate = LYRPredicate(property: "identifier", predicateOperator: LYRPredicateOperator.IsEqualTo, value: identifier)
        query.limit = 1
        do {
            return try self.layerClient.executeQuery(query).firstObject as? LYRConversation
        } catch {
            // This should never happen?
            return nil
        }
    }
    
    func setupParse() {
        // Enable Parse local data store for user persistence
    }
    
    func setupLayer() {
        
        ATLMessageInputToolbar.appearance().leftAccessoryImage = UIImage(named: "add")
        ATLMessageInputToolbar.appearance().rightAccessoryImage = UIImage(named: "location-pressed")
        
        let LayerAppIDString: NSURL! = NSURL(string: "layer:///apps/staging/c034233c-8f8a-11e5-99eb-a26d20003910")
        layerClient = LYRClient(appID: LayerAppIDString)
        layerClient.autodownloadMIMETypes = NSSet(objects: ATLMIMETypeImagePNG, ATLMIMETypeImageJPEG, ATLMIMETypeImageJPEGPreview, ATLMIMETypeImageGIF, ATLMIMETypeImageGIFPreview, ATLMIMETypeLocation) as! Set<String>
        loginLayer()
    }
    
    // MARK - Layer Authentication Methods
    
    func loginLayer() {
        
        // Connect to Layer
        // See "Quick Start - Connect" for more details
        // https://developer.layer.com/docs/quick-start/ios#connect
        self.layerClient.connectWithCompletion { success, error in
            if (!success) {
                print("Failed to connect to Layer: \(error)")
            } else {
                let userID: String = "poctuclab@gmail.com"
                // Once connected, authenticate user.
                // Check Authenticate step for authenticateLayerWithUserID source
                self.authenticateLayerWithUserID(userID, completion: { success, error in
                    if (!success) {
                        print("Failed Authenticating Layer Client with error:\(error)")
                        self.showSimpleAlertWithText("Layer couldnt authenticate! This must be handled!")
                    } else {
                        print("Authenticated")
                    }
                })
            }
        }
    }
    
    func authenticateLayerWithUserID(userID: NSString, completion: ((success: Bool , error: NSError!) -> Void)!) {
        // Check to see if the layerClient is already authenticated.
        if self.layerClient.authenticatedUserID != nil {
            // If the layerClient is authenticated with the requested userID, complete the authentication process.
            if self.layerClient.authenticatedUserID == userID {
                print("Layer Authenticated as User \(self.layerClient.authenticatedUserID)")
                if completion != nil {
                    completion(success: true, error: nil)
                }
                return
            } else {
                //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
                self.layerClient.deauthenticateWithCompletion { (success: Bool, error: NSError?) in
                    if error != nil {
                        self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError?) in
                            if (completion != nil) {
                                completion(success: success, error: error)
                            }
                        })
                    } else {
                        if completion != nil {
                            completion(success: true, error: error)
                        }
                    }
                }
            }
        } else {
            // If the layerClient isn't already authenticated, then authenticate.
            self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError!) in
                if completion != nil {
                    completion(success: success, error: error)
                }
            })
        }
    }
    
    func authenticationTokenWithUserId(userID: NSString, completion:((success: Bool, error: NSError!) -> Void)!) {
        /*
        * 1. Request an authentication Nonce from Layer
        */
        self.layerClient.requestAuthenticationNonceWithCompletion { (nonce: String?, error: NSError?) in
            if (nonce!.isEmpty) {
                if (completion != nil) {
                    completion(success: false, error: error)
                }
                return
            }
            
            /*
            * 2. Acquire identity Token from Layer Identity Service
            */
            let appID = "layer:///apps/staging/c034233c-8f8a-11e5-99eb-a26d20003910"
            
            self.requestIdentityTokenForUserID(userID as String, appID: appID, nonce: nonce!, tokenCompletion: { (object:String?, error: NSError?) -> Void in
                if error == nil {
                    let identityToken = object
                    self.layerClient.authenticateWithIdentityToken(identityToken!) { authenticatedUserID, error in
                        if let _ = authenticatedUserID {
                            if (completion != nil) {
                                completion(success: true, error: nil)
                            }
                            print("Layer Authenticated as User: \(authenticatedUserID)")
                        } else {
                            completion(success: false, error: error)
                        }
                    }
                } else {
                    print("Parse Cloud function failed to be called to generate token with error: \(error)")
                }
                
            })
            
        }
    }
    
    private func requestIdentityTokenForUserID(userID: String, appID: String, nonce: String, tokenCompletion: IdentityTokenCompletionBlock) {
        let identityTokenURL = NSURL(string: "https://layer-identity-provider.herokuapp.com/identity_tokens")!
        let request = NSMutableURLRequest(URL: identityTokenURL)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters = ["app_id": appID, "user_id": userID, "nonce": nonce]
        do {
            let requestBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
            request.HTTPBody = requestBody
        } catch {
            let encodingError = error as NSError
        }
        
        
        let sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let dataTask = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                tokenCompletion(nil, error)
                return
            }
            
            // Deserialize the response
            var responseObject : NSDictionary = [:]
            do {
                responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            } catch {
                let encodingError = error as NSError
            }
            
            if responseObject["error"] == nil {
                let identityToken = responseObject["identity_token"] as! String
                tokenCompletion(identityToken, nil)
            } else {
                let domain = "layer-identity-provider.herokuapp.com"
                let code = responseObject["status"]!.integerValue
                let userInfo = [
                    NSLocalizedDescriptionKey: "Layer Identity Provider Returned an Error.",
                    NSLocalizedRecoverySuggestionErrorKey: "There may be a problem with your APPID."
                ]
                
                let error = NSError(domain: domain, code: code, userInfo: userInfo)
                tokenCompletion(nil, error)
            }
        }
        dataTask.resume()
    }
    
}

