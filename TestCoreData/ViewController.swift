//
//  ViewController.swift
//  TestCoreData
//
//  Created by Sakkaphong Luaengvilai on 11/20/2560 BE.
//  Copyright © 2560 MaDonRa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var CenterImageView: UIImageView!
    
    let file: DataReadWrite = FileData()
    let full : DataFullAccess = FileData()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        file.write(name: "333", age: 480, image: #imageLiteral(resourceName: "sistacafe_color.jpg"))
        //full.removeAll()

        for a in file.read(Sort_ID_ASC: true)
        {
            
            print(a.id ,a.names ?? "",a.age)
            guard let photo = a.photo else { return }
            guard let image = UIImage(data: photo) else { return }
            CenterImageView.image = image
            
        }
        
        print("------")
        
        for a in file.find(id: "17")
        {
            
            print(a.id ,a.names ?? "",a.age)
            guard let photo = a.photo else { return }
            guard let image = UIImage(data: photo) else { return }
            CenterImageView.image = image
            
        }
        
        print("-----")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

