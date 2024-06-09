//
//  SettingsViewController.swift
//  SnapShred
//
//  Created by Aditya on 6/1/24.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var darkModeToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let defaultSetAppearanceStyle = UserDefaults.standard.bool(forKey: "isDarkModeOn")
        if defaultSetAppearanceStyle {
            darkModeToggle.isOn = true
        }
        
    }
    
    @IBAction func deleteEverythingAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "This cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.deleteAllData("ImageDataEntity")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            
        }))
        
        present(alert, animated: true)
    }
    
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)

        do{
            try context.execute(deleteRequest)
        }catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func setAppearance(_ sender: UISwitch) {
        UserDefaults.standard.setValue(sender.isOn, forKey: "isDarkModeOn")
        
        setDarkModeUI()
    }
    
    
    func setDarkModeUI() {
        let defaultAppearance = UserDefaults.standard.bool(forKey: "isDarkModeOn")
        
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.overrideUserInterfaceStyle = defaultAppearance ? .dark : .light
                }
            }
        }
    }
    
}
