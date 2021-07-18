//
//  ReviewCellViewModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

struct ReviewCellViewModel {

    // MARK: - Properties

    let id: Int
    let userCommentViewModel: UserCommentViewModel
    let reply: String?
    let isSelectable: Bool

    // MARK: - Init

    init(with response: ReviewResponseModel, isSelectable: Bool) {
        self.id = response.id
        let hasNoReply = response.reply == nil
        self.userCommentViewModel = UserCommentViewModel(rate: "\(response.rate)",
                                                         comment: response.comment,
                                                         dateDescription: response.dateOfVisit,
                                                         hasInfo: isSelectable ? hasNoReply : false)
        self.reply = response.reply
        self.isSelectable = isSelectable
    }

}
