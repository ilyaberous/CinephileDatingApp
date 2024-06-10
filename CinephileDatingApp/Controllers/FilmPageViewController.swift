//
//  FilmPageViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 09.06.2024.
//

import UIKit
import WebKit

class FilmPageViewController: UIViewController {

    private var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        presentFilmPage(url: url, webView: webView)
    }
    
    init(filmURL: String?) {
        self.url = filmURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func presentFilmPage(url: String?, webView: WKWebView) {
        guard let filmURLString = url, let filmURL = URL(string: filmURLString) else {
            return
        }
        let request = URLRequest(url: filmURL)
        webView.load(request)
    }
}
