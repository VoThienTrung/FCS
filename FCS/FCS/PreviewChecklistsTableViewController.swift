//
//  PreviewChecklistsTableViewController.swift
//  FCS
//
//  Created by Mr Trung Vo Thien Trung on 8/7/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import SnapKit

class PreviewChecklistsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var backButton: UIButton = UIButton()
    
    var userInfoButton: UIButton = UIButton()
    
    var titleLabel: UILabel = UILabel()
    
    var customView: UIView = UIView()
    
    var questions: [Questions] = [Questions]()
    
    var defaultLanguage: Int = 0 // 0: vn 1: en
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if questions[indexPath.row].review == "" {
            return 230
        } else {
            return 240 + questions[indexPath.row].heightOfComment
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChecklistTableViewCell", for: indexPath)
            as! NewChecklistTableViewCell
        let question = self.questions[indexPath.row]
        if defaultLanguage == 0 {
            cell.questionTextView.text = question.title_vn
        } else {
            cell.questionTextView.text = question.title_en
        }
        
        cell.heightOfReviewLabel = question.heightOfComment
        
        if question.review != "" {
            cell.reviewTextView.text = question.review
            cell.reviewTextView.numberOfLines = 0
            cell.reviewTextView.setContentCompressionResistancePriority(UILayoutPriority.init(1000), for: UILayoutConstraintAxis.horizontal)
            cell.reviewTextView.setContentHuggingPriority(UILayoutPriority.init(1000), for: UILayoutConstraintAxis.horizontal)
            cell.setupLayoutForAddingComment()
        }
        
        cell.fisrtChoiceButtonTapped = {
            cell.firstChoiceButton.setImage(UIImage(named:"ic_check"), for: .normal)
            cell.secondChoiceButton.setImage(UIImage(named:"ic_circle"), for: .normal)
            cell.thirdChoiceButton.setImage(UIImage(named:"ic_circle"), for: .normal)
        }
        
        cell.secondChoiceButtonTapped = {
            cell.secondChoiceButton.setImage(UIImage(named:"ic_check"), for: .normal)
            cell.firstChoiceButton.setImage(UIImage(named:"ic_circle"), for: .normal)
            cell.thirdChoiceButton.setImage(UIImage(named:"ic_circle"), for: .normal)
        }
        
        cell.thirdChoiceButtonTapped = {
            cell.thirdChoiceButton.setImage(UIImage(named:"ic_check"), for: .normal)
            cell.firstChoiceButton.setImage(UIImage(named:"ic_circle"), for: .normal)
            cell.secondChoiceButton.setImage(UIImage(named:"ic_circle"), for: .normal)
        }
        
        cell.firstChoiceButton.isUserInteractionEnabled = false
        cell.secondChoiceButton.isUserInteractionEnabled = false
        cell.thirdChoiceButton.isUserInteractionEnabled = false
        
        return cell
    }
    
    private var submitButton: UIButton = UIButton()
    
    private var checklistTableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
        setupLayout()
        
        self.checklistTableView.delegate = self
        self.checklistTableView.dataSource = self
        
        self.submitButton.layer.masksToBounds = true
        self.submitButton.layer.borderColor = UIColor.white.cgColor
        self.submitButton.layer.borderWidth = 2
        self.submitButton.layer.cornerRadius = 10
        
        submitButton.backgroundColor = UIColor.init(red: 78/255, green: 181/255, blue: 251/255, alpha: 1.0)
        self.submitButton.titleLabel!.font = UIFont(name: "Georgia-Bold" , size: 19)

        submitButton.setTitle("Submit", for: .normal)
        
        self.checklistTableView.backgroundColor = UIColor.clear
        self.checklistTableView.separatorStyle = .none
        self.checklistTableView.showsVerticalScrollIndicator = false
        self.checklistTableView.register(NewChecklistTableViewCell.self, forCellReuseIdentifier: NewChecklistTableViewCell.CELL_IDENTIFIER)
    }
    
    fileprivate var _isStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return self._isStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._isStatusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.checklistTableView)
        self.view.addSubview(self.submitButton)
        self.view.addSubview(self.customView)
        self.customView.addSubview(self.backButton)
        //        self.customView.addSubview(self.userInfoButton)
        self.customView.backgroundColor = UIColor.init(red: 78/255, green: 181/255, blue: 251/255, alpha: 1.0)
        
        self.backButton.setImage(UIImage(named: "ic_back_white"), for: .normal)
        //        self.userInfoButton.setImage(UIImage(named: "ic_user"), for: .normal)
        
        self.backButton.addTarget(self, action: #selector(backButtonOnClick), for: .touchUpInside)
        self.submitButton.addTarget(self, action: #selector(submitButtonOnClick), for: .touchUpInside)
        
        //        self.userInfoButton.addTarget(self, action: #selector(userInfoButtonOnClick), for: .touchUpInside)
        
        self.customView.addSubview(self.titleLabel)
        self.titleLabel.font = UIFont(name: "Georgia-Bold", size: 22)
        self.titleLabel.textColor = .white
        self.titleLabel.text = "Preview Check List"
        self.titleLabel.textAlignment = .center
    }
    
    func setupLayout() {
        self.customView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(31)
            make.leading.equalToSuperview()
            make.height.equalTo(44)
            make.trailing.equalToSuperview()
        }
        
        self.backButton.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(44)
        }
        
        self.titleLabel.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview()
        }
        
        self.submitButton.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.40)
            make.height.equalTo(60)
        }
        
        self.checklistTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.backButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.submitButton.snp.top).offset(-10)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func submitButtonOnClick() {
        /// To do: Implement later
    }
    
    @objc func backButtonOnClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func userInfoButtonOnClick() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserInfoViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
}
