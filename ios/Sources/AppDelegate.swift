//
//  Delegate.swift
//  App
//
//  Created by Fitz on 2019/2/1.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation
import UIKit


struct AppJSON: Decodable {
    var name: String
    var displayName: String
}

func ReadAppJSON(filepath: String) -> AppJSON? {

    if let path = Bundle.main.url(forResource: filepath, withExtension: "json") {
        let data = try? Data(contentsOf: path, options: .mappedIfSafe)
        let decoder = JSONDecoder()
        let jsonData = try? decoder.decode(AppJSON.self, from: data!)
        return jsonData!;
    } else {
        print("read app.json with error")
        return nil
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


        let jsCodeLocation = RCTBundleURLProvider
                .sharedSettings()!
                .jsBundleURL(forBundleRoot: "index", fallbackResource: nil);
        let appJson = ReadAppJSON(filepath: "./app")
        let rootView = RCTRootView(
                bundleURL: jsCodeLocation,
                moduleName: appJson?.name,
                initialProperties: nil,
                launchOptions: launchOptions
        )
        rootView!.backgroundColor = UIColor.white

        self.window = UIWindow(frame: UIScreen.main.bounds);
        let rootViewController = UIViewController();
        rootViewController.view = rootView;
        self.window?.rootViewController = rootViewController;
        self.window?.makeKeyAndVisible()
        return true
    }
  func applicationDidEnterBackground(_ application: UIApplication) {
    SportModule.sharedInstance.didEnterBackground();
  }
  func applicationWillTerminate(_ application: UIApplication) {
    SportModule.sharedInstance.willTerminate()
  }
}
