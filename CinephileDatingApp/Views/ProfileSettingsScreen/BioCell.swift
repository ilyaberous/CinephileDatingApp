//
//  BioCell.swift
//  CinephileDatingApp
//
//  Created by Ilya on 22.05.2024.
//

import UIKit

class BioCell: UITableViewCell {
    
    static let identifier = "bio_cell"
    
    weak var delegate: ProfileSettingsCellDelegate?
    
    var viewModel: ProfileSettingsViewModel! {
        didSet {
            configure()
        }
    }
    
    lazy var inputTextView: UITextView = {
       var tv = UITextView()
        tv.delegate = self
        tv.font = .systemFont(ofSize: 16)
        tv.textColor = .black
        tv.autocapitalizationType = .words
        tv.isScrollEnabled = false
        return tv
    }()
    
    let characterCount: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Constants.Fonts.Montserrat.medium, size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGroupedBackground
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        
        selectionStyle = .none
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        contentView.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(characterCount)
        characterCount.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    
    private func configure() {
        //inputTextView.placeholder = viewModel.placeholderText
        inputTextView.text = viewModel.value
        characterCount.text = ""
    }
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    // MARK: - Selectors
    
    @objc private func userInfoUpdated(sender: UITextView) {
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
}

// MARK: - TextView Delegate Methods

extension BioCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if inputTextView.isFirstResponder &&
            (inputTextView.text.isEmpty ||
            inputTextView.text == viewModel.placeholderText)
        {
            inputTextView.text = ""
            inputTextView.textColor = .black
            print("DEBUG: textview selected!")
           }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if inputTextView.text.isEmpty || inputTextView.text == "" {
            inputTextView.textColor = .lightGray
            inputTextView.text = viewModel.placeholderText
        }
        characterCount.text = ""
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.settingsCell(self, wantsToUpdateUserWith: textView.text, for: viewModel.section)
        characterCount.text = "\(textView.text.count)/200"
        print("DEBUG: characters count: \(textView.text.count)")
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        return self.textLimit(existingText: textView.text,
                              newText: text,
                              limit: 200)
    }
}
