// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localizable {

  internal enum Alert {
    internal enum Ok {
      /// Ok
      internal static let buttonTitle = Localizable.tr("Localizable", "Alert.Ok.buttonTitle")
    }
    internal enum SomethingWentWrong {
      /// Please, try again later
      internal static let subtitle = Localizable.tr("Localizable", "Alert.SomethingWentWrong.subtitle")
      /// Something went wrong
      internal static let title = Localizable.tr("Localizable", "Alert.SomethingWentWrong.title")
    }
    internal enum Unauthorized {
      /// Please, log in again
      internal static let subtitle = Localizable.tr("Localizable", "Alert.Unauthorized.subtitle")
      /// Your session expired
      internal static let title = Localizable.tr("Localizable", "Alert.Unauthorized.title")
    }
  }

  internal enum Auth {
    /// I'm the owner of the restaurant
    internal static let roleDescription = Localizable.tr("Localizable", "Auth.roleDescription")
    internal enum Continue {
      /// Continue
      internal static let buttonTitle = Localizable.tr("Localizable", "Auth.Continue.buttonTitle")
    }
    internal enum Error {
      internal enum EmptyData {
        /// It seems, your login or password is empty
        internal static let subtitle = Localizable.tr("Localizable", "Auth.Error.EmptyData.subtitle")
        /// Ooops!
        internal static let title = Localizable.tr("Localizable", "Auth.Error.EmptyData.title")
      }
      internal enum Incorrect {
        /// It seems, your login or password may not be correct
        internal static let subtitle = Localizable.tr("Localizable", "Auth.Error.Incorrect.subtitle")
        /// Ooops!
        internal static let title = Localizable.tr("Localizable", "Auth.Error.Incorrect.title")
      }
    }
    internal enum Login {
      /// Login
      internal static let placeholder = Localizable.tr("Localizable", "Auth.Login.placeholder")
      /// Login
      internal static let title = Localizable.tr("Localizable", "Auth.Login.title")
    }
    internal enum Password {
      /// Password
      internal static let placeholder = Localizable.tr("Localizable", "Auth.Password.placeholder")
    }
    internal enum Register {
      /// Register
      internal static let title = Localizable.tr("Localizable", "Auth.Register.title")
    }
  }

  internal enum Initial {
    /// Welcome!\nPlease, sign in or register
    internal static let title = Localizable.tr("Localizable", "Initial.title")
    internal enum Login {
      /// Login
      internal static let buttonTitle = Localizable.tr("Localizable", "Initial.Login.buttonTitle")
    }
    internal enum Register {
      /// Register
      internal static let buttonTitle = Localizable.tr("Localizable", "Initial.Register.buttonTitle")
    }
  }

  internal enum NewRestaurant {
    /// New Restaurant
    internal static let title = Localizable.tr("Localizable", "NewRestaurant.title")
    internal enum AddImage {
      /// Upload image
      internal static let buttonTitle = Localizable.tr("Localizable", "NewRestaurant.AddImage.buttonTitle")
    }
    internal enum ChangeImage {
      /// Change image
      internal static let buttonTitle = Localizable.tr("Localizable", "NewRestaurant.ChangeImage.buttonTitle")
    }
    internal enum Description {
      /// Enter your description below:
      internal static let title = Localizable.tr("Localizable", "NewRestaurant.Description.title")
    }
    internal enum Error {
      /// All fields should be not empty for saving, including image of the restaurant
      internal static let subtitle = Localizable.tr("Localizable", "NewRestaurant.Error.subtitle")
      /// Ooops!
      internal static let title = Localizable.tr("Localizable", "NewRestaurant.Error.title")
    }
    internal enum Name {
      /// Enter name of the restaurant
      internal static let placeholder = Localizable.tr("Localizable", "NewRestaurant.Name.placeholder")
    }
  }

  internal enum Placeholder {
    /// Something went wrong,\ntry again later
    internal static let description = Localizable.tr("Localizable", "Placeholder.description")
    internal enum Reload {
      /// Reload
      internal static let buttonTitle = Localizable.tr("Localizable", "Placeholder.Reload.buttonTitle")
    }
  }

  internal enum Reply {
    /// Your reply:
    internal static let title = Localizable.tr("Localizable", "Reply.title")
    internal enum Error {
      internal enum Empty {
        /// You can not save empty reply
        internal static let subtitle = Localizable.tr("Localizable", "Reply.Error.Empty.subtitle")
        /// Ooops!
        internal static let title = Localizable.tr("Localizable", "Reply.Error.Empty.title")
      }
    }
  }

  internal enum Restaurant {
    internal enum LeaveComment {
      /// Leave comment
      internal static let buttonTitle = Localizable.tr("Localizable", "Restaurant.LeaveComment.buttonTitle")
    }
  }

  internal enum Restaurants {
    /// Restaurants
    internal static let title = Localizable.tr("Localizable", "Restaurants.title")
    internal enum InfoBubble {
      internal enum UnansweredReviews {
        /// You have one unanswered review
        internal static let _1 = Localizable.tr("Localizable", "Restaurants.InfoBubble.unansweredReviews.1")
        /// You have %@ unanswered reviews
        internal static func many(_ p1: Any) -> String {
          return Localizable.tr("Localizable", "Restaurants.InfoBubble.unansweredReviews.many", String(describing: p1))
        }
      }
    }
    internal enum LogOut {
      /// Log out
      internal static let buttonTitle = Localizable.tr("Localizable", "Restaurants.LogOut.buttonTitle")
    }
  }

  internal enum Review {
    /// Review
    internal static let title = Localizable.tr("Localizable", "Review.title")
    internal enum Error {
      internal enum EmptyText {
        /// It seems, that you left review text field empty
        internal static let subtitle = Localizable.tr("Localizable", "Review.Error.EmptyText.subtitle")
        /// Ooops!
        internal static let title = Localizable.tr("Localizable", "Review.Error.EmptyText.title")
      }
    }
  }

  internal enum User {
    /// Change user info
    internal static let title = Localizable.tr("Localizable", "User.title")
    internal enum Id {
      /// Id
      internal static let placeholder = Localizable.tr("Localizable", "User.Id.placeholder")
    }
    internal enum Login {
      /// Login
      internal static let placeholder = Localizable.tr("Localizable", "User.Login.placeholder")
    }
    internal enum SaveError {
      internal enum EmptyValue {
        /// User name should not be empty
        internal static let description = Localizable.tr("Localizable", "User.SaveError.EmptyValue.description")
        /// Empty fields error
        internal static let title = Localizable.tr("Localizable", "User.SaveError.EmptyValue.title")
      }
      internal enum NoChanges {
        /// No changes to save
        internal static let description = Localizable.tr("Localizable", "User.SaveError.NoChanges.description")
      }
    }
  }

  internal enum Users {
    /// Users
    internal static let title = Localizable.tr("Localizable", "Users.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localizable {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
