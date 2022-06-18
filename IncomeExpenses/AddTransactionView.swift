//
//  AddTransactionView.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/15/22.
//

import UIKit

final class AddTransactionView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private weak var delegate: MainViewControllerProtocol?
    private var dataType: MoneyData.DataType?
    
    private(set) lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.tintColor = .black
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Transaction"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Some fields are missing"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var descriptionTextView: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4.0
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 20)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeholder = "Transaction Description"
        return textView
    }()
    
    private lazy var amountTextView: UITextField = {
        let textView = UITextField()
        textView.placeholder = "Amount"
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.keyboardType = .numberPad
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4.0
        textView.delegate = self
        textView.font = .systemFont(ofSize: 15)
        textView.textAlignment = .center
        return textView
    }()
    
    private lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        return picker
    }()
    
    private lazy var transactionTypeLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textColor = .black
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.font = .systemFont(ofSize: 15)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicker)))
        label.addTrailing(image: UIImage(systemName: "arrowtriangle.down.fill")!, text: "Transaction Type")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        addSubview(titleLabel)
        addSubview(transactionTypeLabel)
        addSubview(descriptionTextView)
        addSubview(amountTextView)
        addSubview(addButton)
        addSubview(errorLabel)
        addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            closeButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            closeButton.widthAnchor.constraint(equalToConstant: 20.0),
            closeButton.heightAnchor.constraint(equalToConstant: 20.0),
            
            transactionTypeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0),
            transactionTypeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            transactionTypeLabel.heightAnchor.constraint(equalToConstant: 50),
            transactionTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            transactionTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            descriptionTextView.topAnchor.constraint(equalTo: transactionTypeLabel.bottomAnchor, constant: 15.0),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 50),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            amountTextView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 15.0),
            amountTextView.heightAnchor.constraint(equalToConstant: 50),
            amountTextView.widthAnchor.constraint(equalToConstant: 80.0),
            amountTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            addButton.topAnchor.constraint(equalTo: amountTextView.bottomAnchor, constant: 15.0),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 120.0),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 15.0),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.0),
        ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEdit)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func showPicker() {
        if subviews.contains(picker) {
            picker.removeFromSuperview()
        } else {
            addSubview(picker)
        }
    }
    
    @objc private func close() {
        removeFromSuperview()
    }
    
    @objc private func didTapAdd() {
        guard let dataType = dataType,
              let description = descriptionTextView.text,
              let amountText = amountTextView.text?.filter({ $0 != "$" }),
              let amount = Double(amountText)
        else {
            errorLabel.isHidden = false
            return
        }

        delegate?.didTapAdd(type: dataType.rawValue, description: description, amount: (ceil(amount * 100) / 100))
        removeFromSuperview()
    }
    
    @objc private func endEdit() {
        endEditing(true)
    }
}

extension AddTransactionView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            textField.text = "$0"
            return
        }
        
        if textField == amountTextView, !text.contains("$") {
            textField.text = "$" + (text.count == 0 ? "0" : text)
        }
    }
}

extension AddTransactionView {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            self.dataType = MoneyData.DataType.expense
        } else if row == 1 {
            self.dataType = MoneyData.DataType.income
        }
        
        transactionTypeLabel.addTrailing(image: UIImage(systemName: "arrowtriangle.down.fill")!, text: dataType?.rawValue ?? "Transaction Type")
        picker.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return MoneyData.DataType.expense.rawValue
            
        } else if row == 1 {
            return MoneyData.DataType.income.rawValue
        }
        
        return nil
    }
}
