//
//  GroupChannelViewController+PollEvents.swift
//  PollsGroupChannel
//
//  Copyright © 2022 Sendbird. All rights reserved.
//

import UIKit
import SendbirdChatSDK
import CommonModule

extension GroupChannelViewController: PollUseCaseDelegate {

    func pollUseCase(_ pollUseCase: PollUseCase, updatedPoll poll: SendbirdChatSDK.Poll) {
        guard let message = messageListUseCase.messages.first(where: { $0.messageId == poll.messageId }) as? UserMessage else {
            return
        }
        message.apply(poll: poll)
    }

    func pollUseCase(_ pollUseCase: PollUseCase, didVotePoll event: SendbirdChatSDK.PollVoteEvent) {
        guard let message = messageListUseCase.messages.first(where: { $0.messageId == event.messageId }) as? UserMessage else {
            return
        }
        message.apply(pollVoteEvent: event)
    }
}
