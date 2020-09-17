//
//  CallViewController.swift
//  VideoChat
//
//  Created by Сергей Шестаков on 17.09.2020.
//  Copyright © 2020 Сергей Шестаков. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    // MARK: - Subviews
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var callButton: UIButton!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Action
    @IBAction func call(_ sender: Any) {
        if let vcChat = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            vcChat.modalPresentationStyle = .fullScreen
            present(vcChat, animated: false, completion: nil)
        }
    }
    
    // MARK: - Private method
    private func configureView() {
        callView.layer.cornerRadius = 20
    }
}
