//
//  ViewController.swift
//  SuperSenha
//
//  Created by Ian Manor on 15/03/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tfTotalPasswords: UITextField!
    @IBOutlet weak var tfNumberOfCharacters: UITextField!
    @IBOutlet weak var swLowercaseLetters: UISwitch!
    @IBOutlet weak var swNumbers: UISwitch!
    @IBOutlet weak var swUppercaseLetters: UISwitch!
    @IBOutlet weak var swSpecialCharacters: UISwitch!
    @IBOutlet weak var btnGerarSenhas: UIButton!

    var corPadrao : UIColor?
    var tamanhoPadrao: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
//        btnGerarSenhas.isEnabled = false
//        btnGerarSenhas.isOpaque = true

        corPadrao = UIColor(cgColor:  tfTotalPasswords.layer.borderColor!)
        tamanhoPadrao = tfTotalPasswords.layer.borderWidth



    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let passwordsViewController = segue.destination as! PasswordsViewController

        // forma mais segura (usar if let)
        if let numberOfPasswords = Int(tfTotalPasswords.text!) {
            // se conseguir obter o valor do campo e converter para inteiro
            passwordsViewController.numberOfPasswords = numberOfPasswords
        }
        if let numberOfCharacters = Int(tfNumberOfCharacters.text!) {
            passwordsViewController.numberOfCharacters = numberOfCharacters
        }
        passwordsViewController.useNumbers = swNumbers.isOn
        passwordsViewController.useUppercaseLetters = swUppercaseLetters.isOn
        passwordsViewController.useLowercaseLetters = swLowercaseLetters.isOn
        passwordsViewController.useSpecialCharacters = swSpecialCharacters.isOn

        // forcar encerrar o modo de edicao // remove o foco e libera teclado
        view.endEditing(true)
    }

    func temSwitchAtivo() -> Bool{
        return swNumbers.isOn || swLowercaseLetters.isOn || swUppercaseLetters.isOn || swSpecialCharacters.isOn
    }

    @IBAction func ligaDesligaBotao(_ sender: UISwitch) {
        if temSwitchAtivo() {
            btnGerarSenhas.isEnabled = true
            btnGerarSenhas.alpha = 1
        } else {
            btnGerarSenhas.isEnabled = false
            btnGerarSenhas.alpha = 0.5
        }

//        tfTotalPasswords.borderWidth = CGFloat( tamanhoPadrao!)
//        tfTotalPasswords.borderColor = corPadrao

    }
    @IBAction func gerarSenha(_ sender: UIButton) {
        print("Gerar Senha")

        if temQuantidadeDeSenhasValida() &&
            temQuantidadeDeCaracteresValida() {
        performSegue(withIdentifier: "ShowList", sender: nil)
        } else {
            showAlert(message: "problema com ")
        }
    }

    func temQuantidadeDeSenhasValida() -> Bool{

        if let number = Int(tfTotalPasswords.text!) ,
           number >= 0, number < 100 {
            print("válido numero de senhas \(number)")
            return true
        }
        print("invalido numero de senhas")
        return false
    }

    func temQuantidadeDeCaracteresValida() -> Bool{

        if let number = Int(tfNumberOfCharacters.text!) ,
           number >= 0, number <= 16 {
            print("válido numero de caracteres \(number)")
            return true
        }
        print("invalido numero de caracteres")
        return false
    }

    func showAlert(message: String){
        let alert = UIAlertController(title: "Falta de informações obrigatórias", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            self.tfTotalPasswords.borderWidth = CGFloat(self.tamanhoPadrao!)
            self.tfTotalPasswords.borderColor = self.corPadrao!

            self.tfNumberOfCharacters.borderWidth = CGFloat(self.tamanhoPadrao!)
            self.tfNumberOfCharacters.borderColor = self.corPadrao!
        }
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            if !self.temQuantidadeDeCaracteresValida() {
                self.tfNumberOfCharacters .borderWidth = CGFloat(2.0)
                self.tfNumberOfCharacters.borderColor = UIColor.red
            }

            if !self.temQuantidadeDeSenhasValida() {
                self.tfTotalPasswords.borderWidth = CGFloat(2.0)
                self.tfTotalPasswords.borderColor = UIColor.red
            }
        }

    }
}

extension UITextField {
    @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }

        @IBInspectable
        var borderColor: UIColor? {
            get {
                let color = UIColor.init(cgColor: layer.borderColor!)
                return color
            }
            set {
                layer.borderColor = newValue?.cgColor
            }
        }

}
