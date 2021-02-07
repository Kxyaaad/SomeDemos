//
//  ViewController.swift
//  SomeDemos
//
//  Created by Mac on 2021/2/5.
//

import UIKit

class ViewController: UIViewController {
    
    var controllers:Array<String> = ["ViewPropertyAnimator"]
    
    var mainTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demos"
        let mainTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(mainTableViewCell.self, forCellReuseIdentifier: "CELL")
        self.mainTableView = mainTableView
        view.addSubview(mainTableView)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")!
        cell.textLabel?.text = self.controllers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let viewclass = NSClassFromString(spaceName + "." + self.controllers[indexPath.row]) as! UIViewController.Type
        let vc = viewclass.init()
        vc.view.backgroundColor = .white
        vc.title = self.controllers[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

