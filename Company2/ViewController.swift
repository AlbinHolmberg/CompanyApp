//
//  ViewController.swift
//  Company2
//
//  Created by albin holmberg on 2022-04-04.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private let button:  UIButton={
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Pay with Swish", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    @IBOutlet var phoneNrTxtField : UITextField!
    @IBOutlet var amountTxtField : UITextField!
    @IBOutlet var messageTxtField : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6
        view.addSubview(button)
        button.frame = CGRect(x: view.frame.width/2-100, y:view.frame.height-100, width: 200, height: 50)
        button.addTarget(self, action: #selector(openSwish), for: .touchUpInside)
        
        addTextFields()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillLayoutSubviews() {
        let width = self.view.frame.width
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: width, height: 40))
        navigationBar.backgroundColor = .opaqueSeparator
        self.view.addSubview(navigationBar)
        let navigationItem = UINavigationItem(title: "Company")
        let clearBtn = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: nil, action: #selector(clearFields))
        navigationItem.rightBarButtonItem = clearBtn
        navigationBar.setItems([navigationItem], animated: false)

    }
    
      
    
    @objc func clearFields(){
        phoneNrTxtField.text = ""
        amountTxtField.text = ""
        messageTxtField.text = ""
    }
    
    
    
    @objc func openSwish() {
        let data = """
        {"version":1,"payee":{"value":"\(phoneNrTxtField.text!)"},"amount":{"value":\(amountTxtField.text!)},"message":{"value":"\(messageTxtField.text!)","editable":true}}
        """.data(using: .utf8)!
        let json = String(decoding: data, as: UTF8.self)
        let notAllowedChars = CharacterSet.init(charactersIn: "!*'();:@&=+$,/?%#[]{} \"")
        let paymentInfo = json.addingPercentEncoding(withAllowedCharacters: notAllowedChars.inverted)!
        print(paymentInfo)

        
        let callbackUrl = "company%3A%2F%2F"
        
        let callbackResultParam = "res"

        let appScheme = "swish://payment?data="+paymentInfo+"&callbackurl="+callbackUrl+"&callbackresultparameter="+callbackResultParam
        let appUrl = URL(string: appScheme)

        if UIApplication.shared.canOpenURL(appUrl! as URL) {
            UIApplication.shared.open(appUrl!)
        } else {
            print("App not installed")
        }

    }
    
    
    func addTextFields(){
        phoneNrTxtField =  UITextField(frame: CGRect(x: 20, y: 200, width: 300, height: 50))
        phoneNrTxtField.borderStyle = UITextField.BorderStyle.line
        phoneNrTxtField.attributedPlaceholder = NSAttributedString(
            string: "Telephone Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        phoneNrTxtField.textColor = .black
        phoneNrTxtField.backgroundColor = .white
        phoneNrTxtField.keyboardType = UIKeyboardType.phonePad
        phoneNrTxtField.borderStyle = UITextField.BorderStyle.roundedRect
        phoneNrTxtField.returnKeyType = UIReturnKeyType.done
        phoneNrTxtField.delegate = self
        view.addSubview(phoneNrTxtField)
        
        amountTxtField = UITextField(frame: CGRect(x:20, y:275, width:300, height:50))
        amountTxtField.borderStyle = UITextField.BorderStyle.line
        amountTxtField.attributedPlaceholder = NSAttributedString(
            string: "Amount to pay (SEK)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        amountTxtField.textColor = .black
        amountTxtField.backgroundColor = .white
        amountTxtField.keyboardType = UIKeyboardType.numberPad
        amountTxtField.borderStyle = UITextField.BorderStyle.roundedRect
        amountTxtField.returnKeyType = UIReturnKeyType.done
        amountTxtField.delegate = self
        view.addSubview(amountTxtField)
        
        
        messageTxtField = UITextField(frame:CGRect(x:20, y: 350,width: 300,height: 50))
        messageTxtField.borderStyle = UITextField.BorderStyle.line
        messageTxtField.attributedPlaceholder = NSAttributedString(
            string: "Message",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        messageTxtField.textColor = .black
        messageTxtField.backgroundColor = .white
        messageTxtField.keyboardType = UIKeyboardType.asciiCapable
        messageTxtField.borderStyle = UITextField.BorderStyle.roundedRect
        messageTxtField.returnKeyType = UIReturnKeyType.done
        messageTxtField.delegate = self
        view.addSubview(messageTxtField)
    }
    
    


}

