//
//  AppDelegate.swift
//  BiometricsExample
//
//  Created by Default on 2021/03/03.
//

import UIKit
import Sybrin_iOS_Biometrics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let licenseKey: String = "3sbMb2s+DWs3KnWYhEntFWl89oc3WguPIL5GSIg7M+sGFCyrhayer1iexfzO7PtY2thAgrH2pwcD6DdcXOExmlfI2fUTKyMniByooRUrCgr6cNkVfUoGZLVqp0Ewv5XOB3cZng3qU2NXG5UXQsrKRSffmKKJoRW6aSmus6yMk1f1f7j5pyIDQ6UgjimvAfiuFCZ1gRxHUrgZMYPJ1UXN07NUFRpCY3Yrbc34D0MGJOqmIaipQSXt4/ayRxtE8hB0SWlRS/894BcdTl0DO0kaAJWKco3k59GtmvZsVDvULDbZDJBH5fc1nTsM7Hm6wd/odndTUplUoYCBQEs9UI7ivnX2rnufAbtNUtTjmXm5abDH4mlfIduogJq8tvl4I8DiuKBitTp7PdYO4S9ltylkvbZe0OPawES6Mh7ZBYGFx1zdJKNh3RntTf5STn9EE2Jdb5bV/ofTOGjFFLaNSgT9yckR9wrbOXvlExDxCAulgBOg0U48uhF8BQamm8rrkqkAHsxuxxg4Fon3N1+TW5QEyA=="

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let sybrinConfig = SybrinBiometricsConfiguration(license: licenseKey)
        
        SybrinBiometrics.shared.configuration = sybrinConfig
        
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

