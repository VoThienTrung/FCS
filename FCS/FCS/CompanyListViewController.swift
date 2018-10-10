
import Foundation
import UIKit



class CompanyListTableViewCell: UITableViewCell {
    @IBOutlet weak var companyImageView: UIImageView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyDescription: UILabel!
    
    
    
    override func awakeFromNib() {
        companyImageView.layer.borderWidth = 1
        companyImageView.layer.masksToBounds = false
        companyImageView.layer.borderColor = UIColor.white.cgColor
        companyImageView.layer.cornerRadius = companyImageView.frame.height/2
        companyImageView.clipsToBounds = true
    }
}

class CompanyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, LanguagesPickerDelegate, DKDropMenuDelegate {
   
    @IBOutlet weak var companyTableView: UITableView!
    @IBOutlet weak var dropMenu: DKDropMenu? = nil
    
    @IBAction func userInfoButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBOutlet weak var companySearchBar: UISearchBar!
    fileprivate var _companies = [Companies]()
    var filtered: [Companies] = []
    var searchActive : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.companyTableView.delegate = self
        self.companyTableView.dataSource = self
        self.companySearchBar.delegate = self
        
        /// Load list of company on UI
        if let unarchivedObject = UserDefaults.standard.object(forKey: "companies") as? Data {
            self._companies = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [Companies])!
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dropDownButtonOnClick(_:)))
//        tap.delegate = self as? UIGestureRecognizerDelegate
//        dropMenu?.addGestureRecognizer(tap)
        
        dropMenu?.add(names: ["Vi", "En"])
        
        dropMenu?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogout), name: NSNotification.Name(rawValue: "Logout"), object: nil)
    }
    
    @objc func userLogout() {
        self.dismiss(animated: true) {
            print("logout success")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = self._companies.filter({ (company) -> Bool in
            let tmp: String = company.name
            let range = tmp.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            return range?.isEmpty == false
        })
        if(filtered.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        self.companyTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return self.filtered.count
        }
        return self._companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyListTableViewCell", for: indexPath)
            as! CompanyListTableViewCell
        var company = self._companies[indexPath.row]
        if(searchActive){
            company = filtered[indexPath.row]
        }
        cell.companyNameLabel.text = company.name
        cell.companyDescription.text = company.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreListViewController") as! StoreListViewController
        let company = self._companies[indexPath.row]
        vc.company_id = company.id
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func userInfoButtonOnClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController")
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func backButtonOnClick(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    func itemSelected(withIndex: Int, name: String) {
        print("lang selected = \(name)")

    }

    func selectedLanguage(_ lang: String) {
        print("lang selected = \(lang)")
    }
    
}
