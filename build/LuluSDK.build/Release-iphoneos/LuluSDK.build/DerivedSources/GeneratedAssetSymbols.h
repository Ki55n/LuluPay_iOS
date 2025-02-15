#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.finance.LuluSDK";

/// The "customCyanColor" asset catalog color resource.
static NSString * const ACColorNameCustomCyanColor AC_SWIFT_PRIVATE = @"customCyanColor";

/// The "forgotPin" asset catalog color resource.
static NSString * const ACColorNameForgotPin AC_SWIFT_PRIVATE = @"forgotPin";

/// The "CheckCircle" asset catalog image resource.
static NSString * const ACImageNameCheckCircle AC_SWIFT_PRIVATE = @"CheckCircle";

/// The "Help" asset catalog image resource.
static NSString * const ACImageNameHelp AC_SWIFT_PRIVATE = @"Help";

/// The "Log_out" asset catalog image resource.
static NSString * const ACImageNameLogOut AC_SWIFT_PRIVATE = @"Log_out";

/// The "Visa" asset catalog image resource.
static NSString * const ACImageNameVisa AC_SWIFT_PRIVATE = @"Visa";

/// The "account_icon" asset catalog image resource.
static NSString * const ACImageNameAccountIcon AC_SWIFT_PRIVATE = @"account_icon";

/// The "agreements" asset catalog image resource.
static NSString * const ACImageNameAgreements AC_SWIFT_PRIVATE = @"agreements";

/// The "appearance" asset catalog image resource.
static NSString * const ACImageNameAppearance AC_SWIFT_PRIVATE = @"appearance";

/// The "card_background" asset catalog image resource.
static NSString * const ACImageNameCardBackground AC_SWIFT_PRIVATE = @"card_background";

/// The "cards" asset catalog image resource.
static NSString * const ACImageNameCards AC_SWIFT_PRIVATE = @"cards";

/// The "close" asset catalog image resource.
static NSString * const ACImageNameClose AC_SWIFT_PRIVATE = @"close";

/// The "delete-key" asset catalog image resource.
static NSString * const ACImageNameDeleteKey AC_SWIFT_PRIVATE = @"delete-key";

/// The "link" asset catalog image resource.
static NSString * const ACImageNameLink AC_SWIFT_PRIVATE = @"link";

/// The "logo" asset catalog image resource.
static NSString * const ACImageNameLogo AC_SWIFT_PRIVATE = @"logo";

/// The "money-sack 1" asset catalog image resource.
static NSString * const ACImageNameMoneySack1 AC_SWIFT_PRIVATE = @"money-sack 1";

/// The "notify" asset catalog image resource.
static NSString * const ACImageNameNotify AC_SWIFT_PRIVATE = @"notify";

/// The "password" asset catalog image resource.
static NSString * const ACImageNamePassword AC_SWIFT_PRIVATE = @"password";

/// The "person" asset catalog image resource.
static NSString * const ACImageNamePerson AC_SWIFT_PRIVATE = @"person";

/// The "profile" asset catalog image resource.
static NSString * const ACImageNameProfile AC_SWIFT_PRIVATE = @"profile";

/// The "rate_us" asset catalog image resource.
static NSString * const ACImageNameRateUs AC_SWIFT_PRIVATE = @"rate_us";

/// The "req_money" asset catalog image resource.
static NSString * const ACImageNameReqMoney AC_SWIFT_PRIVATE = @"req_money";

/// The "security" asset catalog image resource.
static NSString * const ACImageNameSecurity AC_SWIFT_PRIVATE = @"security";

/// The "send_money" asset catalog image resource.
static NSString * const ACImageNameSendMoney AC_SWIFT_PRIVATE = @"send_money";

/// The "settings" asset catalog image resource.
static NSString * const ACImageNameSettings AC_SWIFT_PRIVATE = @"settings";

/// The "transfer" asset catalog image resource.
static NSString * const ACImageNameTransfer AC_SWIFT_PRIVATE = @"transfer";

/// The "withdraw" asset catalog image resource.
static NSString * const ACImageNameWithdraw AC_SWIFT_PRIVATE = @"withdraw";

#undef AC_SWIFT_PRIVATE
