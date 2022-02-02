enum KycStatus {
  kycRequired,
  kycInProgress,
  allowed,
  allowedWithKycAlert,
  blocked
}

int kycOperationStatus(KycStatus status) {
  switch (status) {
    case KycStatus.kycRequired:
      return 0;
    case KycStatus.kycInProgress:
      return 1;
    case KycStatus.allowed:
      return 2;
    case KycStatus.allowedWithKycAlert:
      return 3;
    case KycStatus.blocked:
      return 4;
  }
}

enum RequiredVerified {
  proofOfIdentity,
  proofOfAddress,
  proofOfFunds,
  proofOfPhone,
}

String stringRequiredVerified(RequiredVerified type) {
  switch (type) {
    case RequiredVerified.proofOfIdentity:
      return 'Verify your identity';
    case RequiredVerified.proofOfAddress:
      return 'Address verification';
    case RequiredVerified.proofOfFunds:
      return 'Proof source of funds';
    case RequiredVerified.proofOfPhone:
      return 'Secure your account';
  }
}

RequiredVerified requiredVerifiedStatus(int num) {
  switch (num) {
    case 1:
      return RequiredVerified.proofOfIdentity;
    case 2:
      return RequiredVerified.proofOfAddress;
    case 3:
      return RequiredVerified.proofOfFunds;
    default:
      return RequiredVerified.proofOfPhone;
  }
}

enum KycDocumentType {
  unknown,
  governmentId,
  passport,
  driverLicense,
  residentPermit,
  selfieImage,
  addressDocument,
  financialDocument,
}

String stringKycDocumentType(KycDocumentType type) {
  switch (type) {
    case KycDocumentType.unknown:
      return 'unknown';
    case KycDocumentType.governmentId:
      return 'ID card';
    case KycDocumentType.passport:
      return 'International passport';
    case KycDocumentType.driverLicense:
      return 'Driver license';
    case KycDocumentType.residentPermit:
      return 'Residence permit';
    case KycDocumentType.selfieImage:
      return 'Take a selfie';
    case KycDocumentType.addressDocument:
      return 'Address document';
    default:
      return 'Financial document';
  }
}

KycDocumentType kycDocumentType(int type) {
  switch (type) {
    case 0:
      return KycDocumentType.unknown;
    case 1:
      return KycDocumentType.governmentId;
    case 2:
      return KycDocumentType.passport;
    case 3:
      return KycDocumentType.driverLicense;
    case 4:
      return KycDocumentType.residentPermit;
    case 5:
      return KycDocumentType.selfieImage;
    case 6:
      return KycDocumentType.addressDocument;
    case 7:
      return KycDocumentType.financialDocument;
    default:
      return KycDocumentType.unknown;
  }
}

int kycDocumentTypeInt(KycDocumentType type) {
  switch (type) {
    case KycDocumentType.unknown:
      return 0;
    case KycDocumentType.governmentId:
      return 1;
    case KycDocumentType.passport:
      return 2;
    case KycDocumentType.driverLicense:
      return 3;
    case KycDocumentType.residentPermit:
      return 4;
    case KycDocumentType.selfieImage:
      return 5;
    case KycDocumentType.addressDocument:
      return 6;
    case KycDocumentType.financialDocument:
      return 7;
  }
}

enum KycStatusType {
  deposit,
  withdrawal,
  sell,
}

enum ActiveScanButton {
  active,
  notActive,
}

bool activeScanButtonType(ActiveScanButton type) {
  switch (type) {
    case ActiveScanButton.active:
      return true;
    case ActiveScanButton.notActive:
      return false;
  }
}
