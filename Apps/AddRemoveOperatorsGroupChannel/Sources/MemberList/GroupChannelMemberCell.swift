//
//  GroupChannelMemberCell.swift
//  AddRemoveOperatorsGroupChannel
//
//  Created by Yogesh Veeraraj on 07.04.22.
//  Copyright © 2022 Sendbird. All rights reserved.
//

import UIKit
import CommonModule
import SendbirdChatSDK

protocol GroupChannelMemberCellDelegate: AnyObject {
    func groupChannelMemberCell(
        cell: GroupChannelMemberCell,
        didUpdateOperators: [Member]
    )
    
    func groupChannelMemberCell(
        cell: GroupChannelMemberCell,
        didReceiveError error: Error
    )
}

class GroupChannelMemberCell: BasicChannelMemberCell {
    
    private var useCase: AddRemoveOperatorUseCase?
    private var member: Member?
    
    public weak var delegate: GroupChannelMemberCellDelegate?
    
    private lazy var addRemoveOperatorButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(addRemoveOperatorAction), for: .touchUpInside)
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        useCase = nil
        member = nil
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        let emptyView = UIView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(emptyView)
        contentStackView.addArrangedSubview(addRemoveOperatorButton)
    }
    
    func update(member: Member, useCase: AddRemoveOperatorUseCase) {
        self.useCase = useCase
        self.member = member
        configure(with: member)
        let buttonTitle = useCase.isOperator(member: member) ? "Remove Operator" : "Add Operator"
        addRemoveOperatorButton.setTitle(buttonTitle, for: .normal)
    }
    
    @objc func addRemoveOperatorAction() {
        guard let useCase = useCase, let member = member else {
            return
        }
        if useCase.isOperator(member: member) {
            useCase.removeOperator(users: [member]) { [weak self] result in
                self?.handle(result: result, member: member)
                
            }
        } else {
            useCase.addOperators(users: [member]) { [weak self] result in
                self?.handle(result: result, member: member)
            }
        }
    }
    
    private func handle(result: Result<Void, SBError>, member: Member) {
        switch result {
        case .success():
            delegate?.groupChannelMemberCell(cell: self, didUpdateOperators: [member])
        case .failure(let error):
            delegate?.groupChannelMemberCell(cell: self, didReceiveError: error)
            
        }
    }
    
}
