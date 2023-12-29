//
//  ViewController.swift
//  
//  
//  Created by kohsaka on 2023/12/28
//  
//

import UIKit
import AWSKMS

class ViewController: UIViewController {

    @IBOutlet private weak var encrypt: UITextField!
    @IBOutlet private weak var encryptResult: UITextField!
    @IBOutlet private weak var decrypt: UITextField!
    @IBOutlet private weak var decryptResult: UITextField!

    private var client: AWSKMS?
    private let keyId = "please set keyId"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.client = AWSKMS.default()
    }

    @IBAction private func encryptTapped() {
        if (!self.encrypt.text!.isEmpty) {
            let request = AWSKMSEncryptRequest()
            request?.plaintext = self.encrypt.text!.data(using: .utf8)
            request?.keyId = self.keyId
            self.client!.encrypt(request!).continueWith { (task: AWSTask<AWSKMSEncryptResponse>) -> Any? in
                DispatchQueue.main.async {
                    self.encryptResult.text = task.result!.ciphertextBlob!.base64EncodedString()
                }
                return
            } .waitUntilFinished()
        }
    }

    @IBAction private func decryptTapped() {
        if (!self.decrypt.text!.isEmpty) {
            let request = AWSKMSDecryptRequest()
            request?.ciphertextBlob = Data(base64Encoded: self.decrypt.text!.data(using: .utf8)!)
            request?.keyId = self.keyId
            self.client!.decrypt(request!).continueWith { (task: AWSTask<AWSKMSDecryptResponse>) -> Any? in
                DispatchQueue.main.async {
                    self.decryptResult.text = String(data: (task.result?.plaintext)!, encoding: .utf8)
                }
                return
            } .waitUntilFinished()
        }
    }
}

