//
//  AppDelegate.swift
//  IdentityExample
//
//  Created by Default on 2021/03/04.
//

import UIKit
import Sybrin_iOS_Identity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let licenseKey: String = "IXZ33Yte4S8ZVBrmvpRDT6WFmqLSidgeEitc0QLMeWJrvPvkZ9eEItAkucZDrDsrBNV3Me/DlAddrNknDuduFcTtyH3cHQ+wGJjDjYCJBArKlArr96tgNGW/Qbkx5igeZtFA8k2l33VINf919domTHF/qxbHPyTEfQoy6uYOgCrEKmDWl3sX7D3VnN6QiWQ/OBdleM6QVn/LxF1Gqa7T1uoSUl6DippjZHAgcduwkrsA7wCz7XTcQXdTeJvdRw9BwFCY4kupN9uqNXUaiAQPcArgKpjsA3VIkiOUPn2tzfeQXm7gYODfUlNFQHBDDWHE7JWYEtULFIRghsl0OsTWzXsUWnEodYFTuxwYwNZY8cOXrsBeHMvazjftpx8bWTRZwPgU/roiMhQwJdzo0RuuNJBrzGAWlGKtrHfU3SdJx45O5RJzVi65QWEjlzfCm+v2Sqy1/9/HD0iQAQoToVOD1RY7YPkor0bRcIbp5PtOlNznTNdEy4PF3q85m0EYxi7W8mPNgpleKli1/fUJhfeRQA=="

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let sybrinConfig = SybrinIdentityConfiguration(license: licenseKey)
        
        SybrinIdentity.shared.configuration = sybrinConfig
        SybrinIdentity.shared.changeLogLevel(to: .Information)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

