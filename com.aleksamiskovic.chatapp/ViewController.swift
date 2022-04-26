
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var messageTextField: UITextField!
    var messages: [DataSnapshot] = [DataSnapshot] ()
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
  
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        logOut()
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        checkCurrentUser()
        setupFirebase()
    }
    func setupFirebase(){
        ref = Database.database().reference()
        refHandle = ref.child("messages").observe(DataEventType.childAdded, with: { (dataSnapsShot)
            in
            self.messages.append(dataSnapsShot)
            self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
        })
    }
    
    deinit {
        ref.child("messages").removeObserver(withHandle: refHandle)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text!.count < 1){
            return false
        }
        let data = [Constants.MessageFields.text: textField.text!]
        //sendMessage(data: data)
        print("Message writting ended and sent to firebase")
        self.view.endEditing(true)
        Utilities().clearTextField(textField: textField)
        return true
    }
    
    func sendMessage (data: [String: String]){
        var packet = data
        packet[Constants.MessageFields.dateTime] = Utilities().getData()
        ref.child("messages").childByAutoId().setValue(packet)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell")!
        let message = messages[indexPath.row]
        let msgContent = message.value as! Dictionary<String, String>
        if let text = msgContent[Constants.MessageFields.text]
        {
            cell.textLabel?.text = text
        }
        if let dateTime = msgContent[Constants.MessageFields.dateTime]{
            cell.detailTextLabel?.text = dateTime
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    
    func checkCurrentUser () {
        if (Auth.auth().currentUser == nil) {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "authViewController"){
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    func logOut () {
        do {
            try Auth.auth().signOut()
        } catch (_) {}
    }

}

