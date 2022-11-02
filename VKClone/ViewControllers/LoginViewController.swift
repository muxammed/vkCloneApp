// LoginViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// LoginViewController экран логина
final class LoginViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var inputBackView: UIView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!

    // MARK: - Private properties

    private var buttonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = UIColor(named: Constants.ownDisabledColor)
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        container.foregroundColor = UIColor(named: Constants.ownBackColor)
        configuration.attributedTitle = AttributedString(Constants.loginTitle, attributes: container)
        return configuration
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Public methods

    @objc func keyboardWasShown(notification: Notification) {
        if let info = notification.userInfo as NSDictionary?,
           let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size
        {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            let buttonRect = CGRect(
                x: loginButton.frame.midX,
                y: loginButton.frame.minY + 10,
                width: loginButton.frame.width,
                height: loginButton.frame.height
            )
            scrollView.scrollRectToVisible(buttonRect, animated: true)
            imageWidthConstraint.constant = 80
            imageHeightConstraint.constant = 80
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        imageWidthConstraint.constant = 100
        imageHeightConstraint.constant = 100
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func goToLoginAction(_ sender: Any) {
        scrollView.endEditing(true)
        if let username = usernameTextField.text, username.trimmingCharacters(in: [" "]) == Constants.username,
           let password = passwordTextField.text, password.trimmingCharacters(in: [" "]) == Constants.password
        {
            UserDefaults.standard.set(true, forKey: Constants.isLoggedIn)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: nil, message: Constants.alertMessage, preferredStyle: .alert)
            let okeyAction = UIAlertAction(title: Constants.okeyText, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.usernameTextField.becomeFirstResponder()
            })
            alertController.addAction(okeyAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }

    // MARK: - Private methods

    private func addNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown),
            name:
            UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }

    private func setupViews() {
        inputBackView.layer.borderColor = UIColor(named: Constants.ownStrokeColor)?.cgColor
        inputBackView.layer.borderWidth = 1
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.configuration = buttonConfiguration
    }
}

/// LoginViewController extensions
extension LoginViewController {
    enum Constants {
        static let ownStrokeColor = "ownStrokeColor"
        static let ownBlueColor = "ownBlueColor"
        static let ownDisabledColor = "ownDisabledColor"
        static let ownBackColor = "ownBackColor"
        static let loginTitle = "Sing In"
        static let username = "muxammed"
        static let password = "pass"
        static let alertMessage = """
        Username or Password is wrong.
        Please try again
        """
        static let okeyText = "Okey"
        static let isLoggedIn = "isLoggedIn"
    }
}

/// UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return true }
        if usernameTextField.text?.count == 0 || passwordTextField.text?.count == 0 || text.count == 0 {
            buttonConfiguration.background.backgroundColor = UIColor(named: Constants.ownDisabledColor)
        } else {
            buttonConfiguration.background.backgroundColor = UIColor(named: Constants.ownBlueColor)
        }
        loginButton.configuration = buttonConfiguration
        view.layoutIfNeeded()
        return true
    }
}
