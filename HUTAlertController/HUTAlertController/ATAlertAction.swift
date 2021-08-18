//
//  HUTAlertAction.swift
//  HUTAlertController
//
//  Created by Hut on 2021/8/18.
//

import UIKit

public enum HUTAlertActionStyle {
    case `default`
    case `cancel`
}

class HUTAlertAction: UIButton {
    fileprivate var action: (() -> Void)?
    
    open var actionStyle : HUTAlertActionStyle
    
    open var separator = UIImageView()
    
    init(){
        self.actionStyle = .cancel
        super.init(frame: CGRect.zero)
    }
    
    public convenience init(title: String?, style: HUTAlertActionStyle, action: (() -> Void)? = nil){
        self.init()
        
        self.action = action
        self.addTarget(self, action: #selector(HUTAlertAction.tapped(_:)), for: .touchUpInside)
        
        self.setTitle(title, for: UIControl.State())
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        
        self.actionStyle = style
        style == .default ? (self.setTitleColor(UIColor.black, for: UIControl.State())) : (self.setTitleColor(UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0), for: UIControl.State()))
        backgroundColor = .white
        self.addSeparator()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped(_ sender: HUTAlertAction) {
        //Action need to be fired after alert dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.action?()
        }
    }
    
    fileprivate func addSeparator(){
        separator.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        self.addSubview(separator)
        
        // Autolayout separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: -8).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: 8).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

}
