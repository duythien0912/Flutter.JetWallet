class EventType {
  /// User visits onboarding screen
  static const onboardingView = 'Onboarding view';

  /// User visits sign up page
  static const signUpView = 'Sign up view';
  static const signUpSuccess = 'Sign up';
  static const signUpFailure = 'Sign up failed';

  /// User visits email verification page
  static const emailVerificationView = 'Sign up - email verification view';

  /// User successfully confirmed email be entering verification code
  static const emailConfirmed = 'Sign up - email confirmed';

  /// User visits login page
  static const loginView = 'Login view';
  static const loginSuccess = 'Login';
  static const loginFailure = 'Login failed';

  /// User visits Asset details screen with Chart/About....
  static const assetView = 'Asset View';

  /// User visits Earn program screen (all assets + APY)
  static const earnProgramView = 'Earn program view';

  /// Logout action
  static const logout = 'Logout';

  /// Places where we call kyc popup
  static const kycVerifyProfile = 'KYC - Verify your profile';

  /// Change country code, send country name
  static const changeCountryCode = 'Change country code';

  /// Choose country name and document type in kyc
  static const identityParametersChoosed = 'Identity parameters choosed';

  /// Market filters
  static const marketFilters = 'Filters';

  /// Add asset to watchlist
  static const addToWatchlist = 'Add to watchlist';

  /// Click on market banner, close-open, campaign name
  static const clickMarketBanner = 'Market banner click';

  static const rewardsScreenView = 'Rewards screen view';

  static const inviteFriendView = 'Invite friend view';

  static const earnDetailsView = 'Earn details view';

  static const walletAssetView = 'Wallet asset view';

  /// Quick actions screens
  static const buyView = 'Buy view';
  static const sellView = 'Sell view';
  static const convertView = 'Convert view';
  static const depositView = 'Deposit view';
  static const receiveView = 'Receive view';
  static const sendView = 'Send view';

  /// Quick actions bottom sheet
  static const buySheetView = 'Buy sheet view';
  static const sellSheetView = 'Sell sheet view';
  static const convertSheetView = 'Convert sheet view';
  static const depositSheetView = 'Deposit sheet view';
  static const receiveSheetView = 'Receive sheet view';
  static const sendSheetView = 'Send sheet view';

  /// KYC related events
  static const kycCameraAllowed = 'KYC - Camera allowed';
  static const kycCameraNotAllowed = 'KYC - Camera not allowed';
  static const kycIdentityUploaded = 'KYC - Identity Uploaded';
  static const kycIdentityUploadFailed = 'KYC - Identity upload failed';
  static const kycSelfieUploaded = 'KYC - Selfie uploaded';
  static const kycPhoneConfirmationView = 'KYC - Phone confirmation view';
  static const kycPhoneConfirmed = 'KYC - Phone confirmed';
  static const kycPhoneConfirmFailed = 'KYC - Phone confirm failed';
  static const kycAllowCameraView = 'KYC - Allow camera view';
  static const kycSelfieView = 'KYC - Selfie view';
  static const kycSuccessPageView = 'KYC - Success Page View';
  static const kycChangePhoneNumber = 'KYC - Change Phone Number';
  static const kycIdentityScreenView = 'KYC - Identity screen view';
  static const kycEnterPhoneNumber = 'KYC - Enter phone number';

  /// Buy screen
  static const tapPreviewBuy = 'Tap preview buy';
  static const previewBuyView = 'Confirm buy view';
  static const simplexView = 'Simplex view';
  static const simplexSucsessView = 'Simplex success view';
  static const simplexFailureView = 'Simplex failure view';
  static const tapConfirmBuy = 'Tap on Confirm Buy';

  /// Circle
  static const circleChooseMethod = 'Click on Choose Payment Method';
  static const circlePayFromView = 'Pay from sheet view';
  static const circleTapAddCard = 'Click on Add Bank Card - Circle';
  static const circleContinueDetails = 'Continue with Card Details';
  static const circleContinueAddress = 'Continue with Billing Address';
  static const circleCVVView = 'CVV Sheet view';
  static const circleCloseCVV = 'Close CVV Sheet ';
  static const circleRedirect = 'Redirect to 3D-S';
  static const circleSuccess = 'Success Page';
  static const circleFailed = 'Card Failed Screen View';
  static const circleAdd = 'Click Add Bank Card after Fail';
  static const circleCancel = 'Click Cancel after Fail';

  /// Quick actions
  /// User taps on "Buy" in Quick Actions
  static const tapOnBuy = 'Tap on buy';

  /// User taps on "Buy from card" in Quick Actions
  static const tapOnBuyFromCard = 'Tap on buy from card';

  // [START] Recurring buy ->
  static const setupRecurringBuyView = '"Setup recurring buy" sheet view';
  static const pickRecurringBuyFrequency =
      'Pick frequency on "Setup recurring buy" sheet';
  static const closeRecurringBuySheet = 'Close "Setup recurring buy" sheet';
  // "Reccuring buy" screen displayed after click on the tab
  // called "Recurring buy" in Account
  static const recurringBuyView = 'Recurring buy view';
  // User clicks on the button "Manage" in the recurring buy order
  static const tapManageButton = 'Tap "Manage" button';
  static const recurringBuyDeletionSheetView =
      'Recurring buy deletion sheet view';
  static const cancelRecurringBuyDeletion = 'Cancel recurring buy deletion';
  static const deleteRecurringBuy = 'Delete recurring buy';
  static const pauseRecurringBuy = 'Pause recurring buy';
  static const startRecurringBuy = 'Start recurring buy';
  // <- Recurring buy [END]

  /// Earn
  static const earnClickInfoButton = 'Click on Info button - onboarding';
  static const earnOnBoardingView = 'Onboarding sheet view';
  static const earnClickMore = "Click on 'Learn more' - onboarding";
  static const earnCloseOnboarding = "Close 'Onboarding' sheet";
  static const earnTapAvailable = 'Tap on Asset available for Earn';
  static const earnAvailableView = 'Offers per asset sheet view';
  static const earnSelectOffer = 'Select offer';
  static const earnProgressBar = 'Tap on progress bar(%)';
  static const earnCalculationView = 'Calculation plan sheet view';
  static const earnPreview = 'Preview Earn';
  static const earnConfirm = 'Tap on Confirm Earn button';
  static const earnSuccessPage = 'Earn Success Page View';
  static const earnTapActive = 'Tap on Active Subscription';
  static const earnActiveSheetView = 'Active Subscription Sheet View';
  static const earnCloseActiveSheet = 'Close Active Subscription Sheet View';
  static const earnTapManage = 'Tap on Manage button';
  static const earnManageView = 'Manage Sheet View';
  static const earnCloseManage = 'Close Manage Sheet View';
  static const earnClickTopUp = 'Click on Top up Button';
  static const earnPreviewTopUp = 'Preview Top up';
  static const earnConfirmTopUp = 'Confirm Top up';
  static const earnSuccessTopUp = 'Success Top up page';
  static const earnClickReclaim = 'Click on Reclaim Earn Button';
  static const earnPreviewReclaim = 'Preview Reclaim Earn';
  static const earnConfirmReclaim = 'Confirm Reclaim Earn';
  static const earnSuccessReclaim = 'Success Reclaim Earn Page';
}
