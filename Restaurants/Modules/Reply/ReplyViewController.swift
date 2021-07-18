//
//  ReplyViewController.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import UIKit

protocol ReplyViewOutput {
    func viewDidLoad()
    func didFinishReply(with text: String)
}

final class ReplyViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let replyTitleTopInset: CGFloat = 20
        static let replyTitleSideInset: CGFloat = 20

        static let replyTopInset: CGFloat = 10
        static let replySideInset: CGFloat = 20
    }

    // MARK: - Views

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    let userComment = UserCommentView()
    let replyTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = Localizable.Reply.title
        return label
    }()
    let replyTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.tintColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()

    // MARK: - Properties

    var output: ReplyViewOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.output?.viewDidLoad()
    }

}

// MARK: - ReplyViewInput

extension ReplyViewController: ReplyViewInput {

    func configure(with title: String, model: UserCommentViewModel) {
        self.title = title
        self.userComment.configure(with: model)
    }

}

// MARK: - Actions

private extension ReplyViewController {

    @objc
    func didSelectDone() {
        self.output?.didFinishReply(with: self.replyTextView.text)
    }

}

// MARK: - Private Methods

private extension ReplyViewController {

    func setupInitial() {
        self.view.backgroundColor = .white

        self.configureNavigationBar()
        self.configureScrollView()
        self.configureUserComment()
        self.configureReplyLabel()
        self.configureReplyTextView()

        self.replyTextView.becomeFirstResponder()
    }

    func configureNavigationBar() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.didSelectDone))
        self.navigationItem.rightBarButtonItem = doneItem
    }

    func configureScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUserComment() {
        self.scrollView.addSubview(self.userComment)
        self.userComment.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.right.equalTo(self.view.snp.right)
        }
    }

    func configureReplyLabel() {
        self.scrollView.addSubview(self.replyTitleLabel)
        self.replyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userComment.snp.bottom).inset(-Constants.replyTitleTopInset)
            make.left.equalTo(Constants.replyTitleSideInset)
            make.right.equalTo(self.view.snp.right).inset(Constants.replyTitleSideInset)
        }
    }

    func configureReplyTextView() {
        // TODO: fix keyboard

        let textViewContainer = UIView()
        textViewContainer.addSubview(self.replyTextView)
        self.replyTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.scrollView.addSubview(textViewContainer)
        textViewContainer.snp.makeConstraints { make in
            make.top.equalTo(self.replyTitleLabel.snp.bottom).inset(-Constants.replyTopInset)
            make.left.equalTo(Constants.replySideInset)
            make.right.equalTo(self.view.snp.right).inset(Constants.replySideInset)
            make.bottom.equalToSuperview()
        }
    }

}
