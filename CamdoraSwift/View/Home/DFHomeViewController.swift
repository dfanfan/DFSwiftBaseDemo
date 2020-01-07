//
//  DFHomeViewController.swift
//  CamdoraSwift
//
//  Created by user on 11/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit

class DFHomeViewController: DFBaseViewController {
    
    var tableView : UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let button = UIButton.init(frame: CGRect(x: 10, y: 100, width: 100, height: 100))
//        button.backgroundColor = UIColor.red
//        view.addSubview(button)
//
//        button.addTarget(self, action: #selector(aaa), for: .touchUpInside)
//
//        navView?.backgroundColor = UIColor.red
        
        let netManager = DFNetManager.sharedManager
        netManager.df_startNetWorkMonitoring { (networkStatus) in
            print(networkStatus)

        }
        
        
        tableView = UITableView.init(frame: view.bounds, style: .plain)

        if let tableView = tableView {
            view.addSubview(tableView)

            tableView.addEmptyCallback { [weak self] in
                print("=======")
                self?.tableView?.setLoading(isLoading: false)

            }
            
            tableView.addHeaderCallback { [weak self] in
                print("------")
                self?.tableView?.emptyReloadData()
            }
        }
    }
    
    
    override func hideNavView() -> Bool {
        return true
    }
    
    @objc func aaa() {
//        let vc = DFMeViewController()
//        navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
        DFHud.showSuccesshHint(hint: "success", view: self.view) { () -> (Void) in
            print("=======")
            DFHud.showHudInView(view: self.view)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            DFHud.showSuccesshHint(hint: "error", view: self.view) { () -> (Void) in
                print("------")
                DFHud.showHudInView(view: self.view)
            }
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
