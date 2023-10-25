//
//  WebViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/10/20.
//

import UIKit
import WebKit


// ⭐️⭐️ 웹뷰 포인트 지점 : 웹에서 버튼을 눌렀을때 앱에서 알럿을 띄어주는 방법
// 상호 통신이 가능하게 하는게 핵심임
class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView = WKWebView()
    
    var homePageurl : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let homePageurl else { return }
        
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // https://cool-workshop-596.notion.site/4c75ddc9bc16488d853cf84cae44ad01?pvs=4
        
        let myURL = URL(string:homePageurl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

}
