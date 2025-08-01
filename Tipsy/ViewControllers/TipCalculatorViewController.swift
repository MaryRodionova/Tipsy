import UIKit

final class TipCalculatorViewController: UIViewController {
    
    private var tipModel = TipModel()
    private var selectedTipPercentage: Int = 10
    private var splitCount: Int = 2
 
    private let billTotalLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter bill total"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let billTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "e.g. 123.56"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        textField.textColor = UIColor(hex: "#06B06B")
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let selectTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Select tip"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tipStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let zeroPctButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("0%", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.setTitleColor(UIColor(hex: "#06B06B"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.addTarget(
            self,
            action: #selector(zeroPctCalculateButton),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tenPctButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("10%", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#06B06B")
        button.layer.cornerRadius = 8
        button.addTarget(
            self,
            action: #selector(tenPctCalculateButton),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let twentyPctButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("20%", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.setTitleColor(UIColor(hex: "#06B06B"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.addTarget(
            self,
            action: #selector(twentyPctCalculateButton),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let chooseSplitLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Split"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let splitStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 80
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let splitNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        label.textColor = UIColor(hex: "#06B06B")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stepperValueChanged: UIStepper = {
        let stepper = UIStepper()
        stepper.value = 2
        stepper.minimumValue = 2
        stepper.maximumValue = 25
        stepper.tintColor  = .white
        stepper.backgroundColor = .clear
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(
            self,
            action: #selector(stepperValueAction),
            for: .valueChanged)
        return stepper
    }()

    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#06B06B")
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(calculateButtonTapped),
            for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let bottomGreenView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D8F9EA")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupActions()
        setupUI()

        updateButtonSelection(selectedButton: tenPctButton)
        updateTipModel()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#F9FFFD")
    }

    @objc
    private func zeroPctCalculateButton() {
        billTextField.endEditing(true)
        updateButtonSelection(selectedButton: zeroPctButton)
        updateTipModel()
        selectedTipPercentage = 0
    }

    @objc
    private func tenPctCalculateButton() {
        billTextField.endEditing(true)
        tenPctButton.isSelected = true
        updateButtonSelection(selectedButton: tenPctButton)
        updateTipModel()
        selectedTipPercentage = 10
    }

    @objc private func twentyPctCalculateButton() {
        billTextField.endEditing(true)
        twentyPctButton.isSelected = true
        updateButtonSelection(selectedButton: twentyPctButton)
        updateTipModel()
        selectedTipPercentage = 20
    }

    @objc
    private func stepperValueAction() {
        splitNumberLabel.text = String(Int(stepperValueChanged.value))
        splitCount = Int(stepperValueChanged.value)
    }

    @objc
    private func calculateButtonTapped() {
        guard let tip = tipModel.createTip(
            billText: billTextField.text,
            tipPercentage: selectedTipPercentage,
            splitCount: splitCount
        ) else {
            showAlert(message: "Please enter a valid bill amount")
            return
        }
        let resultVC = TipResultViewController(
            totalPerPerson: tip.amountPerPerson,
            splitCount: tip.splitCount,
            tipPercentage: tip.selectedTipPercentage
        )
        present(resultVC, animated: true)
    }

    private func updateButtonSelection(selectedButton: UIButton) {
        [zeroPctButton, tenPctButton, twentyPctButton].forEach { button in
            button.isSelected = false
            button.backgroundColor = .clear
            button.setTitleColor(UIColor(hex: "#06B06B"), for: .normal)
        }

        selectedButton.isSelected = true
        selectedButton.backgroundColor = UIColor(hex: "#06B06B")
        selectedButton.setTitleColor(.white, for: .normal)
        
    }

    private func setupActions() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        toolbar.setItems([doneButton], animated: false)
        billTextField.inputAccessoryView = toolbar
    }

    private func updateTipModel() {
         _ = tipModel.createTip(
             billText: billTextField.text,
             tipPercentage: selectedTipPercentage,
             splitCount: splitCount
         )
     }

     private func showAlert(message: String) {
         let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
         )
         alert.addAction(
            UIAlertAction(title: "OK", style: .default)
         )
         present(alert, animated: true)
     }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Setup Constraints

private extension TipCalculatorViewController {
 
    func addSubviews() {
        view.addSubview(bottomGreenView)
        view.addSubview(billTotalLabel)
        view.addSubview(billTextField)

        bottomGreenView.addSubview(selectTipLabel)
        bottomGreenView.addSubview(tipStackView)
        bottomGreenView.addSubview(chooseSplitLabel)
        bottomGreenView.addSubview(splitStackView)
        bottomGreenView.addSubview(calculateButton)

        tipStackView.addArrangedSubview(zeroPctButton)
        tipStackView.addArrangedSubview(tenPctButton)
        tipStackView.addArrangedSubview(twentyPctButton)

        splitStackView.addArrangedSubview(splitNumberLabel)
        splitStackView.addArrangedSubview(stepperValueChanged)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                
                bottomGreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomGreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomGreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bottomGreenView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),

                billTotalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                billTotalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                billTotalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

                billTextField.topAnchor.constraint(equalTo: billTotalLabel.bottomAnchor, constant: 20),
                billTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                billTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                billTextField.heightAnchor.constraint(equalToConstant: 50),

                selectTipLabel.topAnchor.constraint(equalTo: bottomGreenView.topAnchor, constant: 40),
                selectTipLabel.leadingAnchor.constraint(equalTo: bottomGreenView.leadingAnchor, constant: 32),
                selectTipLabel.trailingAnchor.constraint(equalTo: bottomGreenView.trailingAnchor, constant: -32),

                tipStackView.topAnchor.constraint(equalTo: selectTipLabel.bottomAnchor, constant: 20),
                tipStackView.leadingAnchor.constraint(equalTo: bottomGreenView.leadingAnchor, constant: 32),
                tipStackView.trailingAnchor.constraint(equalTo: bottomGreenView.trailingAnchor, constant: -32),
                tipStackView.heightAnchor.constraint(equalToConstant: 50),

                chooseSplitLabel.topAnchor.constraint(equalTo: tipStackView.bottomAnchor, constant: 40),
                chooseSplitLabel.leadingAnchor.constraint(equalTo: bottomGreenView.leadingAnchor, constant: 32),
                chooseSplitLabel.trailingAnchor.constraint(equalTo: bottomGreenView.trailingAnchor, constant: -32),

                splitStackView.topAnchor.constraint(equalTo: chooseSplitLabel.bottomAnchor, constant: 20),
                splitStackView.centerXAnchor.constraint(equalTo: bottomGreenView.centerXAnchor),

                calculateButton.bottomAnchor.constraint(equalTo: bottomGreenView.bottomAnchor, constant: -60),
                calculateButton.leadingAnchor.constraint(equalTo: bottomGreenView.leadingAnchor, constant: 32),
                calculateButton.trailingAnchor.constraint(equalTo: bottomGreenView.trailingAnchor, constant: -32),
                calculateButton.heightAnchor.constraint(equalToConstant: 54)
            ]
        )
    }
}


