import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class SignUpViewController: UIViewController {
  
  
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var userTypePicker: UISegmentedControl!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordText: UITextField!
  @IBOutlet weak var errorLabel: UILabel!
  
  var errorMessage: String = ""
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.dismissKeyboard()
    passwordTextField.isSecureTextEntry = true
    confirmPasswordText.isSecureTextEntry = true
  }
  
  
  
  @IBAction func signUpButton(_ sender: Any) {
    
    if validateForm() {
    

      Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
        if let error = error {
          if let errCode = AuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .emailAlreadyInUse:
              self.errorLabel.text = "emailAlreadyInUse"
            case .wrongPassword:
              self.errorLabel.text = "wrongPassword"
            case .userNotFound:
              self.errorLabel.text = "userNotFound"
            case .invalidEmail:
              self.errorLabel.text = "invalidEmail"
            default:
              self.errorLabel.text = "Error: \(errCode.rawValue)"
            }
          }
          return
        }
        print("user created")
        // create user file in firestore
        // seague to questions
        var userModel = UserModel(id: authResult!.user.uid,
                             email: self.emailTextField.text!,
                                  isDoctor: self.userTypePicker.selectedSegmentIndex == 1)
        
        let db = Firestore.firestore()
        do {
          var ref: DocumentReference!
          ref = try db.collection("users").addDocument(from: userModel) { error in
            if let error = error {
              print(error.localizedDescription)
              return
            }
            userModel.docID = ref.documentID
            user = userModel
            isUpdating = false
            if self.userTypePicker.selectedSegmentIndex == 0 {
              var profileModel = PatientModel(id: user.id,
                                              nickname: "",
                                              dateOfBirth: nil,
                                              imageURL: "",
                                              description: "",
                                              answers: [])
              do {
                var ref: DocumentReference!
                ref = try db.collection("patients").addDocument(from: profileModel) { error in
                  if let error = error {
                    print(error.localizedDescription)
                    return
                  }
                  profileModel.docID = ref.documentID
                  patientProfile = profileModel
                  self.performSegue(withIdentifier: "userSignupToQuestions", sender: nil)
                }
              } catch {
                print(error.localizedDescription)
              }
            } else {
              var profileModel = DoctorModel(id: user.id,
                                             firstName: "",
                                             lastName: "",
                                             mobileNumber: "",
                                             
                                             imageURL: "",
                                             zoom: "",
                                             experience: 0,
                                             languages: [],
                                             availableDates: [], description: "",
                                             answers: [])
              do {
                var ref: DocumentReference!
                ref = try db.collection("doctors").addDocument(from: profileModel) { error in
                  if let error = error {
                    print(error.localizedDescription)
                    return
                  }
                  profileModel.docID = ref.documentID
                  doctorProfile = profileModel
                  let controller = self.storyboard?.instantiateViewController(identifier: "DoctorHomeVC") as! DoctorHomeViewController
                  controller.modalPresentationStyle = .fullScreen
                  controller.modalTransitionStyle = .flipHorizontal
                  self.present(controller, animated: false, completion: nil)
                }
              } catch {
                print(error.localizedDescription)
              }
            }
          }
        } catch {
          print(error.localizedDescription)
        }
        
        
        
      }

    }
    
  }
  
  
  func validateForm() ->Bool {
    if emailTextField.text!.isEmpty {
      errorLabel.text = "Email Addressis Missing!"
      return false
    }
    
    if passwordTextField.text!.isEmpty {
      errorLabel.text = "Password Missing!"
      return false
    }
    
    if confirmPasswordText.text!.isEmpty {
      errorLabel.text = "Password Confirmation Missing!"
      return false
    }
    
    if passwordTextField.text!.count < 8 {
      errorLabel.text = "Password too short!"
      return false
    }
    
    if passwordTextField.text != confirmPasswordText.text {
      errorLabel.text = "Password Does Not Match"
      return false
    }
    if !emailTextField.text!.contains("@") {
      errorLabel.text = "Email invalid"
      return false
    }
    errorLabel.text = ""
    return true
    
  }
  
}

