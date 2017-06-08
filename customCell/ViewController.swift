//
//  ViewController.swift
//  customCell
//
//  Created by Sebastian Hette on 23.09.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit
class parser {
    var bodies: [String];
    var titles: [String];
    init() {
        self.bodies=[String]();
        self.titles=[String]();
        self.web();
    }
    func fix(){
        var c=0;
        for item in bodies {
            bodies[c]=item.replacingOccurrences(of: "\n", with: "\\");
            c+=1;
        }
    }
    func otax(){
        self.fix();
        for item in titles {
            print(item);
        }
        for item in bodies {
            print(item);
        }
    }
    func web() {
        let url = URL(string:"https://jsonplaceholder.typicode.com/posts");
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        for element in myJson{
                            let d = element as? NSDictionary
                            self.titles.append(d?["title"] as! String);
                            self.bodies.append(d?["body"] as! String);
                        }
                    }
                    catch
                    {
                        print("Can't Parse\n");
                    }
                    self.otax();
                }
            }
        }
        task.resume()
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let par = parser();
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 100;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        if par.bodies.count==0 {
            cell.myLabel.text="Scroll up and down to refresh";
        }
        else{
            var out = "Title : ";
            out.append(par.titles[indexPath.hashValue%par.titles.count]);
            out.append("\n\nBody : ");
            out.append(par.bodies[indexPath.hashValue%par.bodies.count]);
            cell.myLabel.text=out;
        }
        return (cell)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

