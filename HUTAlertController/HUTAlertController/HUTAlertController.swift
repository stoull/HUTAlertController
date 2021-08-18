//
//  HUTAlertController.swift
//  HUTAlertController
//
//  Created by Hut on 2021/8/18.
//

import UIKit

enum HUTAlertControllerStyle {
    case alert
    case sheet_center
    case sheet_bottom
}

class HUTAlertController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var alertActionStackView: UIStackView!
    @IBOutlet weak var alertTextFieldStackView: UIStackView!
    
    @IBOutlet weak var alertViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertTextFieldStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertTitleStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertTextFieldStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertTextFieldStackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertActionStackViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var alertView: UIView!
    fileprivate var textFields: [UITextField] = []
    fileprivate var ALERT_TEXTFIELD_VIEW_HEIGHT : CGFloat = 40
    fileprivate var ALERT_ACTION_VIEW_HEIGHT: CGFloat = 54.0
    fileprivate let alertTransition = HUTAlertTransition()
    fileprivate var alertStyle: HUTAlertControllerStyle = .alert
    
    public var dismissWithBackgroudTouch = false // enable touch background to dismiss. Off by default.
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCustomConstraints()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    convenience init(title: String?, description: String?, style:HUTAlertControllerStyle) {
        self.init()
        self.alertStyle = style
        let mainBundle = Bundle(for: self.classForCoder)
        guard let nib = mainBundle.loadNibNamed("HUTAlertController", owner: self, options: nil), let unwrappedView = nib[0] as? UIView else {
            return
        }
        self.view = unwrappedView
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        alertView.layer.cornerRadius = 12.0
        alertView.layer.masksToBounds = true
        
        if let title = title {
            titleLabel.text = title
        } else {
            titleLabel.isHidden = true
        }
        
        if let description = description {
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        alertTextFieldStackView.isHidden = true
        
        if style == .sheet_bottom{
            alertActionStackView.spacing = 0.0
            NSLayoutConstraint.deactivate([alertViewCenterYConstraint])
            let alertViewBottomConstraint = alertView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40.0)
            alertViewLeadingConstraint.constant = 20.0
            alertViewTrailingConstraint.constant = 20.0
            NSLayoutConstraint.activate([alertViewBottomConstraint])
        } else {
            alertActionStackView.spacing = 1.0
        }
        
        self.modalPresentationStyle = .fullScreen
        self.transitioningDelegate = alertTransition
        
        // Add background view tap gesture
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(type(of: self).backgroundViewDidTap))
        self.view.addGestureRecognizer(tapRecognizer)

    }
    
    // MARK: - Public methods
    func addAction(_ alertAction: HUTAlertAction) {
        alertActionStackView.addArrangedSubview(alertAction)
        if self.alertStyle == .alert {
            if alertActionStackView.arrangedSubviews.count > 2 {
                alertActionStackView.axis = .vertical
            } else {
                alertActionStackView.axis = .horizontal
            }
        } else {
            alertActionStackView.axis = .vertical
        }
        
        alertAction.addTarget(self, action: #selector(type(of: self).actionDidClick(_:)), for: .touchUpInside)
    }
    
    /// - Text Fields
    func addTextField(textField:UITextField? = nil, _ configuration: (_ textField: UITextField?) -> Void){
        let textField = textField ?? UITextField()
        textField.delegate = self
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textAlignment = .center
        configuration (textField)
        _addTextField(textField)
    }
    
    fileprivate func _addTextField(_ textField: UITextField){
        alertTextFieldStackView.addArrangedSubview(textField)
        
        alertTextFieldStackView.axis = .vertical
        textFields.append(textField)
        
        alertTextFieldStackView.isHidden = false
        
    }
    
    // MARK: - Actions
    @objc private func actionDidClick(_ sender: HUTAlertAction) {
        if sender.actionStyle == .cancel {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func backgroundViewDidTap() {
        if keyboardHasBeenShown == true {
            for textFeild in self.textFields {
                textFeild.resignFirstResponder()
            }
        } else {
            if dismissWithBackgroudTouch == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Update UI
    fileprivate func updateCustomConstraints() {
        // Title part
        var titleViewHeight: CGFloat = 46.0
        if descriptionLabel.isHidden == false {
            titleViewHeight += 20.0
        }
        
        // text field part
        var textFieldHeight:CGFloat = 0.0
        var textFieldStackViewTopConstraint: CGFloat = 0.0
        var textFieldStackViewBottomConstraint: CGFloat = 10.0
        var titleStackViewTopConstraint: CGFloat = 10.0
        if hasTextFieldAdded() == true {
            textFieldHeight = CGFloat(textFields.count) * ALERT_TEXTFIELD_VIEW_HEIGHT
            textFieldStackViewTopConstraint = 18.0
            textFieldStackViewBottomConstraint = 34.0
            titleStackViewTopConstraint = 20.0
        }
        alertTextFieldStackViewTopConstraint.constant = textFieldStackViewTopConstraint
        alertTextFieldStackViewBottomConstraint.constant = textFieldStackViewBottomConstraint
        alertTextFieldStackViewHeightConstraint.constant = textFieldHeight
        textFieldHeight = textFieldHeight + textFieldStackViewTopConstraint + textFieldStackViewBottomConstraint
        alertTitleStackViewTopConstraint.constant = titleStackViewTopConstraint
        
        // actions part
        var actionLines = 1
        if self.alertStyle == .alert {
            actionLines = alertActionStackView.arrangedSubviews.count > 2 ? alertActionStackView.arrangedSubviews.count : 1
        } else {
            actionLines = alertActionStackView.arrangedSubviews.count
        }
        let actionViewsHeight = ALERT_ACTION_VIEW_HEIGHT*CGFloat(actionLines)
        alertActionStackViewHeightConstraint.constant = actionViewsHeight
        
        // all part
        alertViewHeightConstraint.constant = actionViewsHeight + textFieldHeight + alertTitleStackViewTopConstraint.constant + titleViewHeight
    }
    
    func hasTextFieldAdded () -> Bool{
        return textFields.count > 0
    }

    //MARK: - Keyboard avoiding
    var tempFrameOrigin: CGPoint?
    var keyboardHasBeenShown:Bool = false
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardHasBeenShown = true
        
        guard let userInfo = (notification as NSNotification).userInfo else {return}
        guard let endKeyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.minY else {return}
        
        if tempFrameOrigin == nil {
            tempFrameOrigin = alertView.frame.origin
        }
        
        var newContentViewFrameY = alertView.frame.maxY - endKeyBoardFrame
        if newContentViewFrameY < 0 {
            newContentViewFrameY = 0
        }
        alertView.frame.origin.y -= newContentViewFrameY
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if (keyboardHasBeenShown) { // Only on the simulator (keyboard will be hidden)
            if (tempFrameOrigin != nil){
                alertView.frame.origin.y = tempFrameOrigin!.y
                tempFrameOrigin = nil
            }
            keyboardHasBeenShown = false
        }
    }
}

extension HUTAlertController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
