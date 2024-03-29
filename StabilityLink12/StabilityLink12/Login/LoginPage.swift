//
//  LoginPage.swift
//  StabilityLink12
//
//  Created by BinXiong on 2019/11/10.
//  Copyright © 2019 Matthew Chute. All rights reserved.
//

import UIKit
import Firebase

class LoginPage: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailtext: UITextField!
    
    @IBOutlet weak var Passwordtext: UITextField!
    
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var Errortext: UILabel!
    
    var textF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupelements()
        //keyboard function
        
    
        
        
    }
    func setupelements(){
        Errortext.alpha = 0
        //Utilities.styleTextField(emailtext)
        //Utilities.styleTextField(Passwordtext)
        //Utilities.styleFilledButton(loginbutton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailtext.resignFirstResponder()
        Passwordtext.resignFirstResponder()
    }
    
            
        
  
    
    @IBAction func loginTapped(_ sender: Any) {
        //validate text filed
        let email = emailtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = Passwordtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //signing in the user
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.Errortext.text = error!.localizedDescription
                self.Errortext.alpha = 1
            }
            else{
                //get current user id
                let userID = Auth.auth().currentUser?.uid
                let db = Firestore.firestore()
                db.collection("users").whereField("uid", isEqualTo: userID as Any).getDocuments { (snapshot, error) in
                    if error != nil{
                        print(error as Any)
                    }
                    else{
                        for document in (snapshot?.documents)!{
                            if let role = document.data()["role"] as? String{
                                //if current id role is patient
                                //else physio
                                if role == "patient"
                                {
                                    let loginStoryboard = UIStoryboard(name: "patientHome", bundle: nil)
                                    let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "PatientHome")
                                    self.view.window?.rootViewController = loginViewController
                                    self.view.window?.makeKeyAndVisible()
                                    
                                }
                                else
                                {
                                    let loginStoryboard = UIStoryboard(name: "physioHome", bundle: nil)
                                    let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "PhysicalTherapistHome")
                                    self.view.window?.rootViewController = loginViewController
                                    self.view.window?.makeKeyAndVisible()
                                }
                                
                            }
                            
                        }
                    }
                }          }
        }
    }
    
    
}
