//
//  ViewController.swift
//  HUTAlertController
//
//  Created by Hut on 2021/8/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showAlert(_ sender: Any) {
        let alert = HUTAlertController(title: "确定删除充电费率？", message: "是否解除该电子锁？", preferredStyle: .sheet_bottom)
        
        let cancelAction = HUTAlertAction(title: "Cancel", style: .cancel, action: nil)
        let comfirmAction = HUTAlertAction(title: "Confirm", style: .default) {
            print("xxxx vvbbb ")
        }
        
        let aAction = HUTAlertAction(title: "1111", style: .default) {
            print("11111 ")
        }
        
        let bAction = HUTAlertAction(title: "2222", style: .default) {
            print("22222 ")
        }
        
        alert.addAction(aAction)
//        alert.addAction(bAction)
//        alert.addAction(comfirmAction)
        alert.addAction(cancelAction)
        
//        alert.addAction(aAction)
//        alert.addAction(bAction)
        
        alert.dismissWithBackgroudTouch = true
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAlertWithTextFlied(_ sender: Any) {
        let alert = HUTAlertController(title: "确定删除充电费率？", message: nil, preferredStyle: .sheet_center)
        
        let cancelAction = HUTAlertAction(title: "Cancel", style: .cancel, action: nil)
        let comfirmAction = HUTAlertAction(title: "Confirm", style: .default) {
            print("xxxx vvbbb ")
        }
        
        let aAction = HUTAlertAction(title: "1111", style: .default) {
            print("11111 ")
        }
        
        let bAction = HUTAlertAction(title: "2222", style: .default) {
            print("22222 ")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(comfirmAction)

//        alert.addAction(aAction)
//        alert.addAction(bAction)
        
        alert.addTextField { textField in
            textField?.backgroundColor = UIColor.systemGray5
            textField?.layer.cornerRadius = 4.0
            textField?.layer.masksToBounds = true
            textField?.placeholder = "Input here"
        }
        
        alert.dismissWithBackgroudTouch = true
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAlertWithSheetStyle(_ sender: Any) {
        
    }
}

