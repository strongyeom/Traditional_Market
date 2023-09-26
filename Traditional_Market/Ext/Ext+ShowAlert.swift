//
//  Ext+ShowAlert.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit

extension ViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
