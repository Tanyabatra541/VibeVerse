
import Foundation
import UIKit

class ChecklistViewController: UIViewController {
    private var options: [String]
    private var selectedOptions: Set<String>
    var onSelectionChanged: (([String]) -> Void)?
    
    private let visibleView = View(backgroundcolor: .beige, cornerradius: 20.autoSized)
    
    private let titleLabel = Label(texttitle: "Choose Options", textcolor: .black, font: .boldSystemFont(ofSize: 20), numOflines: 1, textalignment: .center)
    private let doneButton = ButtonWithLabel(title: "Done", font: .boldSystemFont(ofSize: 18), backgroundColor: .clear, titlecolor: .blue)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .beige
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChecklistCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    
    init(options: [String], selectedOptions: [String]) {
        self.options = options
        self.selectedOptions = Set(selectedOptions)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(visibleView)
        visibleView.addSubview(titleLabel)
        visibleView.addSubview(doneButton)
        visibleView.addSubview(tableView)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            visibleView.heightAnchor.constraint(equalToConstant: 500.autoSized),
            visibleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visibleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visibleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: visibleView.topAnchor, constant: 20.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: visibleView.leadingAnchor, constant: 25.widthRatio),
            
            doneButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: visibleView.trailingAnchor, constant: -25.widthRatio),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.autoSized),
            tableView.leadingAnchor.constraint(equalTo: visibleView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: visibleView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: visibleView.bottomAnchor),
        ])

    }
    
    @objc private func doneTapped() {
        onSelectionChanged?(Array(selectedOptions))
        dismiss(animated: true)
    }
}

extension ChecklistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath)
        cell.backgroundColor = .beige
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .black
        let option = options[indexPath.row]
        cell.textLabel?.text = option
        cell.accessoryType = selectedOptions.contains(option) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
