//
//  ViewController.swift
//  MiniApp66-RxSwift08
//
//  Created by 前田航汰 on 2022/07/29.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet private  weak var emailTextField: UITextField!
    @IBOutlet private weak var password1TextField: UITextField!
    @IBOutlet private weak var password2TextField: UITextField!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var errorTextView: UITextView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        errorTextView.layer.borderColor = UIColor.red.cgColor
        errorTextView.layer.borderWidth = 1

        let inputs = Observable
            .combineLatest(
            emailTextField.rx.text.orEmpty,
            password1TextField.rx.text.orEmpty,
            password2TextField.rx.text.orEmpty
        )

        inputs
            .map{ email, pass1, pass2 in
                return makeErrorMessage(email: email, pass1: pass1, pass2: pass2)
                    .map { "・\($0)" }
                    .joined(separator: "\n")
            }
            .bind(to: errorTextView.rx.text)
            .disposed(by: disposeBag)
    }

}

private func makeErrorMessage(email: String, pass1: String, pass2: String) -> [String] {
    var message: [String] = []

    if email.isEmpty {
        message.append("メールアドレスを入力して下さい")
    } else if !email.isVaidEmail {
        message.append("メールアドレスの形式が正しくありません")
    }

    if pass1.isEmpty {
        message.append("パスワードを入力して下さい")
    } else if !pass1.isVaildPassword {
        message.append("パスワードの形式が正しくありません")
    }

    if pass2.isEmpty {
        message.append("確認用パスワードを入力して下さい")
    } else if !pass2.isVaildPassword {
        message.append("確認用パスワードの形式が正しくありません")
    }

    if !pass1.isEmpty && !pass2.isEmpty && pass1 != pass2 {
        message.append("パスワードと確認用パスワードが一致していません")
    }

    return message

}


private extension String {

    var isVaidEmail: Bool {
        self.contains("@gmail.com")
    }

    var isVaildPassword: Bool {
        count >= 8
    }
}
