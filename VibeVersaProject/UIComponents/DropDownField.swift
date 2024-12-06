

import Foundation
import UIKit


class DropdownField: UIView {
    // MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.text = "----------- Select -----------"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var options: [String]
    var selectedOptions: Set<String> = []
    var onSelectionChanged: (([String]) -> Void)?
    
    // MARK: - Initializer
    init(frame: CGRect = .zero, options: [String]) {
        self.options = options
        super.init(frame: frame)
        self.backgroundColor = .darkBeige
        self.translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(borderView)
        borderView.addSubview(label)
        
        // Add Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showOptions))
        borderView.addGestureRecognizer(tapGesture)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Show Options
    @objc private func showOptions() {
        guard let parentViewController = findParentViewController() else { return }
        
        let checklistVC = ChecklistViewController(
            options: options,
            selectedOptions: Array(selectedOptions)
        )
        
        checklistVC.onSelectionChanged = { [weak self] selected in
            guard let self = self else { return }
            self.selectedOptions = Set(selected)
            self.updateLabel()
            self.onSelectionChanged?(Array(self.selectedOptions))
        }
        
        let navController = UINavigationController(rootViewController: checklistVC)
        parentViewController.present(navController, animated: true)
    }
    
    // MARK: - Update Label
    private func updateLabel() {
        if selectedOptions.isEmpty {
            label.text = "----------- Select -----------"
        } else {
            label.text = selectedOptions.joined(separator: ", ")
        }
    }
    
    // MARK: - Utility
    private func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
