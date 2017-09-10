//
//  ViewController.swift
//  miDNI
//
//  Created by Álvaro Martín on 08/09/15.
//  Copyright © 2015 Álvaro A. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var nDNITextField: UITextField!
    @IBOutlet var letraDNILabel: UILabel!
    @IBOutlet var dniHistorialTableView: UITableView!
    
    var dnis = [Dni]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
        if let savedDnis = loadDnis() {
            dnis += savedDnis
            
        }
        else {
            loadSampleDNIs()
        }
        
        // no hace falta ordenarlos porque en cuanto se crea un dni en la primera ejecución ya estarían ordenados
        // y se grabarían así.
        dnis.sort { (a, b) -> Bool in
            return a.created.timeIntervalSinceReferenceDate > b.created.timeIntervalSinceReferenceDate
        }
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nDNITextFieldChanges(_ sender: Any) {
        
        let ahora = NSDate()
        letraDNILabel.textColor = UIColor(netHex:0xC7EDE8)
        //        letraDNILabel.font = UIFont.systemFontOfSize(22.0)
        let nuevoDNI = Dni (numeroDNI: nDNITextField.text!, created: ahora, favorite: false, notas: "")
        let letraCalculada = nuevoDNI.letra
        letraDNILabel.text = "\(letraCalculada)"
        if  ((nDNITextField.text?.characters.count)! >= 8 && letraCalculada != "-") {
            //            NSLog("vvvvvvvvvvvv")
            //            NSLog("la letra de la label debe ser " + "\(letraCalculada)")
            letraDNILabel.textColor = UIColor.black
            // letraDNILabel.font = UIFont.boldSystemFontOfSize(22.0)
            nDNITextField.resignFirstResponder()
            dnis += [nuevoDNI]
            dnis.sort { (a, b) -> Bool in
                return a.created.timeIntervalSinceReferenceDate > b.created.timeIntervalSinceReferenceDate
            }
            dniHistorialTableView.reloadData()
            refreshUI()
            nDNITextField.becomeFirstResponder()
            saveDnis()
        }
    }

    
    @IBAction func viewTapped(sender: AnyObject) {
        nDNITextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // make sure we can only type numbers
        
        let characterSetNotAllowed = CharacterSet.decimalDigits
        
        if let _ = string.rangeOfCharacter(from: characterSetNotAllowed.inverted, options: .caseInsensitive) {
            return false
        } else {
            return true
        }
        
    }
    
    
    func refreshUI () {
        nDNITextField.text = ""
        letraDNILabel.text = "-"
    }
    
    func loadSampleDNIs () {
        let dnis1 = Dni (numeroDNI: "12345678", created: NSDate(), favorite: false, notas: "un ejemplo")
        let dnis2 = Dni (numeroDNI: "87654321", created: NSDate(), favorite: false, notas: "otro ejemplo")
        
        dnis += [dnis1,dnis2]
    }
    
    // MARK: Rollos del TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dnis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "dniTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! dniTableViewCell
        let dni = dnis [indexPath.row]
        
    
        cell.nifLabel.text = dni.numeroDNI + " "
        cell.nifLabel.text?.append(dni.letra)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        cell.fechaCreacionLabel.text = formatter.string(from: dni.created as Date)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dnis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        } else if editingStyle == .insert {
        }
        saveDnis()
    }
    
    // MARK: NSCoding
    
    func saveDnis() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dnis, toFile:Dni.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save dnis...")
        }
    }
    
    func loadDnis() -> [Dni]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Dni.ArchiveURL.path) as? [Dni]
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

