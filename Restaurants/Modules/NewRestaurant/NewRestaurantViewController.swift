//
//  NewRestaurantViewController.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

import UIKit

protocol NewRestaurantViewOutput {
    func viewDidLoad()
    func didSelect(image: UIImage)
    func didSelectSave(with name: String, description: String)
    func didSelectDelete()
}

final class NewRestaurantViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Constants

    private enum Constants {
        static let nameTextSideInset: CGFloat = 20
        static let nameTextHeight: CGFloat = 44

        static let addImageButtonTopInset: CGFloat = 8
        static let addImageButtonSideInset: CGFloat = 20
        static let addImageButtonHeight: CGFloat = 44

        static let imageSideInset: CGFloat = 20
        static let imageWidth: CGFloat = 100
        static let imageHeight: CGFloat = 50
        static let imageCornerRadius: CGFloat = 4

        static let descriptionLabelSideInset: CGFloat = 20

        static let desctiptionCornerRadius: CGFloat = 4
        static let descriptionTopInset: CGFloat = 8
        static let descriptionSideInset: CGFloat = 20
        static let descriptionBottomInset: CGFloat = 280
    }

    // MARK: - Views

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localizable.NewRestaurant.Name.placeholder
        textField.keyboardType = .asciiCapable
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        return textField
    }()
    private let addImageButton = DefaultButton(title: Localizable.NewRestaurant.AddImage.buttonTitle)
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.roundCorners(Constants.imageCornerRadius)
        return imageView
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = Localizable.NewRestaurant.Description.title
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.tintColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.roundCorners(Constants.desctiptionCornerRadius)
        textView.addBorder(width: 1, color: .lightGray)
        return textView
    }()

    // MARK: - Properties

    var output: NewRestaurantViewOutput?

    // MARK: - Private Properties

    let imagePicker = UIImagePickerController()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.output?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.nameTextField.becomeFirstResponder()
    }

}

// MARK: - NewRestaurantViewInput

extension NewRestaurantViewController: NewRestaurantViewInput {

    func setupLoadingState() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.view.endEditing(true)
        self.showLoading()
    }

    func setupInitialState() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func configureAdminState(with restaurant: RestaurantResponseModel) {
        self.nameTextField.text = restaurant.name
        if let imageUrlString = restaurant.imageUrlString,
           let url = URL(string: imageUrlString) {
            self.restaurantImageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
                self?.restaurantImageView.image = image
            }
        }
        self.addImageButton.isHidden = true
        self.descriptionTextView.text = restaurant.description

        self.configureDeleteIcon()
    }

}

// MARK: - UITextFieldDelegate

extension NewRestaurantViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.descriptionTextView.becomeFirstResponder()
        }
        return true
    }

}

// MARK: - Actions

extension NewRestaurantViewController {

    @objc
    func didSelectUploadImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
            return
        }
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .savedPhotosAlbum
        self.imagePicker.allowsEditing = false

        self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
    }

    @objc
    func didSelectSave() {
        self.output?.didSelectSave(with: self.nameTextField.text ?? "", description: self.descriptionTextView.text)
    }

    @objc
    func didSelectDelete() {
        self.output?.didSelectDelete()
    }

}

// MARK: - UIImagePickerControllerDelegate

extension NewRestaurantViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.restaurantImageView.image = image
        self.output?.didSelect(image: image)
        self.addImageButton.setTitle(Localizable.NewRestaurant.ChangeImage.buttonTitle, for: .normal)
    }

}

// MARK: - Private Methods

private extension NewRestaurantViewController {

    func setupInitial() {
        self.title = Localizable.NewRestaurant.title
        self.view.backgroundColor = .white

        self.configureNavigationBar()
        self.configureNameTextField()
        self.configureAddingImage()
        self.configureDescriptionTextView()
    }

    func configureNavigationBar() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.didSelectSave))
        self.navigationItem.rightBarButtonItem = doneItem
    }

    func configureDeleteIcon() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.didSelectSave))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.didSelectDelete))
        self.navigationItem.rightBarButtonItems = [doneItem, deleteItem]
    }

    func configureNameTextField() {
        self.nameTextField.delegate = self

        self.view.addSubview(self.nameTextField)
        self.nameTextField.snp.makeConstraints { make in
            make.topMargin.equalTo(Constants.nameTextSideInset)
            make.left.equalTo(Constants.nameTextSideInset)
            make.right.equalTo(-Constants.nameTextSideInset)
            make.height.equalTo(Constants.nameTextHeight)
        }
    }

    func configureAddingImage() {
        self.addImageButton.addTarget(self, action: #selector(self.didSelectUploadImage), for: .touchUpInside)

        self.view.addSubview(self.addImageButton)
        self.addImageButton.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextField.snp.bottom).inset(-Constants.addImageButtonTopInset)
            make.left.equalTo(Constants.addImageButtonSideInset)
            make.height.equalTo(Constants.addImageButtonHeight)
        }

        self.view.addSubview(self.restaurantImageView)
        self.restaurantImageView.snp.makeConstraints { make in
            make.top.equalTo(self.addImageButton)
            make.left.equalTo(self.addImageButton.snp.right).inset(-Constants.imageSideInset)
            make.right.equalTo(-Constants.imageSideInset)
            make.height.equalTo(Constants.imageHeight)
            make.width.equalTo(Constants.imageWidth)
        }
    }

    func configureDescriptionTextView() {
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.restaurantImageView.snp.bottom).inset(-Constants.descriptionLabelSideInset)
            make.left.equalTo(Constants.descriptionLabelSideInset)
            make.right.equalTo(-Constants.descriptionLabelSideInset)
        }

        self.view.addSubview(self.descriptionTextView)
        self.descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).inset(-Constants.descriptionTopInset)
            make.left.equalTo(Constants.descriptionSideInset)
            make.right.equalTo(-Constants.descriptionSideInset)
            make.bottomMargin.equalTo(-Constants.descriptionBottomInset)
        }
    }

}
