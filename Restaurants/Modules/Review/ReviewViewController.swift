//
//  ReviewViewController.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import UIKit

protocol ReviewViewOutput {
    func viewDidLoad()
    func didFinishReview(with text: String, rating: Int, date: Date)
}

final class ReviewViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let ratingViewTopInset: CGFloat = 20

        static let datePickerTopInset: CGFloat = 10
        static let datePickerHeight: CGFloat = 31

        static let reviewTopInset: CGFloat = 10
        static let reviewSideInset: CGFloat = 20
    }

    // MARK: - Views

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    let ratingView = RatingSelectorView()
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.tintColor = .black
        return datePicker
    }()
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.tintColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()

    // MARK: - Properties

    var output: ReviewViewOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.output?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.reviewTextView.becomeFirstResponder()
    }

}

// MARK: - ReviewViewInput

extension ReviewViewController: ReviewViewInput {

    func configure(with title: String) {
        self.title = title
    }

    func setupLoadingState() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.reviewTextView.resignFirstResponder()
        self.showLoading()
    }

}

// MARK: - Actions

private extension ReviewViewController {

    @objc
    func didSelectDone() {
        self.output?.didFinishReview(with: self.reviewTextView.text,
                                     rating: self.ratingView.getRating(),
                                     date: self.datePicker.date)
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let bottom = keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 16

        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom , right: 0)
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets.zero
    }

}

// MARK: - Private Methods

private extension ReviewViewController {

    func setupInitial() {
        self.view.backgroundColor = .white

        self.configureNavigationBar()
        self.configureScrollView()
        self.configureRatingView()
        self.configureDatePicker()
        self.configureReviewTextView()
        self.registerForKeyboardNotifications()
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
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalToSuperview()
        }
    }

    func configureRatingView() {
        self.contentView.addSubview(self.ratingView)
        self.ratingView.snp.makeConstraints { make in
            make.top.equalTo(Constants.ratingViewTopInset)
            make.left.equalToSuperview()
            make.right.equalTo(self.view.snp.right)
        }
    }

    func configureDatePicker() {
        self.contentView.addSubview(self.datePicker)
        self.datePicker.snp.makeConstraints { make in
            make.top.equalTo(self.ratingView.snp.bottom).inset(-Constants.datePickerTopInset)
            make.height.equalTo(Constants.datePickerHeight)
            make.centerX.equalToSuperview()
        }
    }

    func configureReviewTextView() {
        let textViewContainer = UIView()
        textViewContainer.addSubview(self.reviewTextView)
        self.reviewTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        self.contentView.addSubview(textViewContainer)
        textViewContainer.snp.makeConstraints { make in
            make.top.equalTo(self.datePicker.snp.bottom).inset(-Constants.reviewTopInset)
            make.left.equalTo(Constants.reviewSideInset)
            make.right.equalTo(self.view.snp.right).inset(Constants.reviewSideInset)
            make.bottom.equalToSuperview()
        }
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

}
