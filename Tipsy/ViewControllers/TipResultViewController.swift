import UIKit

final class TipResultViewController: UIViewController {
    
    private var totalPerPerson: Double = 0.0
    private var splitCount: Int = 2
    private var tipPercentage: Int = 10

    private let topGreenView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D8F9EA")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let totalPerPersonLabel: UILabel = {
        let label = UILabel()
        label.text = "Total per person"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "56.32"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        label.textColor = UIColor(hex: "#06B06B")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Split between 2 people,with 10% tip."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let recalculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Recalculate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#06B06B")
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(recalculateButtonAction),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(
        totalPerPerson: Double,
        splitCount: Int,
        tipPercentage: Int
    ) {
        self.totalPerPerson = totalPerPerson
        self.splitCount = splitCount
        self.tipPercentage = tipPercentage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#F9FFFD")
        let totalString = NumberFormatter.localizedString(
            from: NSNumber(value: totalPerPerson),
            number: .currency
        )
        amountLabel.text = totalString
        descriptionLabel.text = "Split between \(splitCount) people,with \(tipPercentage)% tip."
    }

    @objc
    private func recalculateButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup Constraints

private extension TipResultViewController {
    
    func addSubviews() {
        view.addSubview(topGreenView)
        view.addSubview(descriptionLabel)
        view.addSubview(recalculateButton)

        topGreenView.addSubview(totalPerPersonLabel)
        topGreenView.addSubview(amountLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                topGreenView.topAnchor.constraint(equalTo: view.topAnchor),
                topGreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                topGreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                topGreenView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),

                totalPerPersonLabel.centerXAnchor.constraint(equalTo: topGreenView.centerXAnchor),
                totalPerPersonLabel.centerYAnchor.constraint(equalTo: topGreenView.centerYAnchor, constant: -60),

                amountLabel.centerXAnchor.constraint(equalTo: topGreenView.centerXAnchor),
                amountLabel.topAnchor.constraint(equalTo: totalPerPersonLabel.bottomAnchor, constant: 20),

                descriptionLabel.topAnchor.constraint(equalTo: topGreenView.bottomAnchor, constant: 60),
                descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

                recalculateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
                recalculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                recalculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                recalculateButton.heightAnchor.constraint(equalToConstant: 54)
            ]
        )
    }
}
