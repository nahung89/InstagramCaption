//
//  ViewController.swift
//  InstagramCaption
//
//  Created by NAH on 2/11/17.
//  Copyright © 2017 NAH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var container: InstaCaptionContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = container.becomeFirstResponder()
    }

}

