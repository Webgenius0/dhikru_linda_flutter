import 'package:dhikru_linda_flutter/features/auth/login/data/rx_login/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/login/model/login_model.dart';
import 'package:dhikru_linda_flutter/features/auth/logout/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/register/data/rx_register/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/register/data/rx_register_verify_otp/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/register/data/rx_resend_otp/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/register/model/register_model.dart';
import 'package:dhikru_linda_flutter/features/auth/register/model/register_verify_otp_model.dart';
import 'package:dhikru_linda_flutter/features/auth/register/model/resend_otp_model.dart';
import 'package:rxdart/rxdart.dart';

// ------------- Register Api Access -----------------//
RegisterRx registerRxObj = RegisterRx(
  empty: RegisterModel(),
  dataFetcher: BehaviorSubject<RegisterModel>(),
);

// ------------- Register Verify Otp Api Access -----------------//
RegisterVerifyOtpRx registerVerifyOtpRxObj = RegisterVerifyOtpRx(
  empty: RegisterVerifyOtpModel(),
  dataFetcher: BehaviorSubject<RegisterVerifyOtpModel>(),
);

// ------------- Login Api Access -----------------//
LoginRx loginRxObj = LoginRx(
  empty: LoginModel(),
  dataFetcher: BehaviorSubject<LoginModel>(),
);

// _____________ LogOut Api Access _____________
LogOutRx logOutRxObj = LogOutRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

// ------------- Resend OTP Api Access -------------
ResendOtpRx resendOtpRxObj = ResendOtpRx(
  empty: ResendOtpModel(),
  dataFetcher: BehaviorSubject<ResendOtpModel>(),
);


// //_________________Delete Account Api Access ______________________//
// DeleteAccountRx deleteAccountRxObj =
//     DeleteAccountRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

// //_________________Update Password Api Access ______________________//
// UpdatePasswordRx updatePasswordRxObj =
//     UpdatePasswordRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

// //_________________Privacy Policy Api Access ______________________//
// PrivacyPolicyRx privacyPolicyRxObj = PrivacyPolicyRx(
//   empty: PrivacyPolicyModel(),
//   dataFetcher: BehaviorSubject<PrivacyPolicyModel>(),
// );

// //_________________Terms And Conditions Api Access ______________________//
// TermsAndConditionsRx termsAndConditionsRxObj = TermsAndConditionsRx(
//   empty: PrivacyPolicyModel(),
//   dataFetcher: BehaviorSubject<PrivacyPolicyModel>(),
// );

// // ------------- Update Profile Api Access -----------------//
// UpdateProfileRx updateProfileRxObj = UpdateProfileRx(
//   empty: {},
//   dataFetcher: BehaviorSubject<Map>(),
// );

// // ------------- Verify Register Otp Api Access -----------------//
// VerifyRegisterOtpRx verifyRegisterOtpRxObj = VerifyRegisterOtpRx(
//   empty: VerifyRegisterOtpModel(),
//   dataFetcher: BehaviorSubject<VerifyRegisterOtpModel>(),
// );

// // ------------- Resend Register Otp Api Access -----------------//
// ResendRegisterOtpRx resendRegisterOtpRxObj = ResendRegisterOtpRx(
//   empty: ResendRegisterOtpModel(),
//   dataFetcher: BehaviorSubject<ResendRegisterOtpModel>(),
// );



// //___________________ Forget Password Api Access ______________________//
// ForgetPasswordRx forgetPasswordRxObj = ForgetPasswordRx(
//   empty: ForgetPasswordModel(),
//   dataFetcher: BehaviorSubject<ForgetPasswordModel>(),
// );

// //___________________ User Info Api Access ______________________//
// UserInfoRx userInfoRxObj = UserInfoRx(
//   empty: UserInfoModel(),
//   dataFetcher: BehaviorSubject<UserInfoModel>(),
// );

// //___________________ Mentor Details Api Access ______________________//
// MentorDetailsRx mentorDetailsRxObj = MentorDetailsRx(
//   empty: MentorDetailsModel(),
//   dataFetcher: BehaviorSubject<MentorDetailsModel>(),
// );

// //___________________ Filter List Api Access ______________________//
// FilterListRx filterListRxObj = FilterListRx(
//   empty: FilterListModel(),
//   dataFetcher: BehaviorSubject<FilterListModel>.seeded(FilterListModel()),
// );

// FilterListRx studentDesignListRxObj = FilterListRx(
//   empty: FilterListModel(),
//   dataFetcher: BehaviorSubject<FilterListModel>.seeded(FilterListModel()),
// );

// FilterListRx contributionListRxObj = FilterListRx(
//   empty: FilterListModel(),
//   dataFetcher: BehaviorSubject<FilterListModel>.seeded(FilterListModel()),
// );

// FilterListRx universityHospitalListRxObj = FilterListRx(
//   empty: FilterListModel(),
//   dataFetcher: BehaviorSubject<FilterListModel>.seeded(FilterListModel()),
// );

// FilterListRx placeListRxObj = FilterListRx(
//   empty: FilterListModel(),
//   dataFetcher: BehaviorSubject<FilterListModel>.seeded(FilterListModel()),
// );

// FilterListRx experienceLevelListRxObj = FilterListRx(
//   empty: FilterListModel(),
//   dataFetcher: BehaviorSubject<FilterListModel>.seeded(FilterListModel()),
// );



// // //_________________Reset Password Api Access ______________________//
// // ResetPasswordRx resetPasswordRxObj = ResetPasswordRx(
// //   empty: ResetPasswordModel(),
// //   dataFetcher: BehaviorSubject<ResetPasswordModel>(),
// // );


// // ------------- Forget Api Access -----------------//
// // ForgetPasswordRx forgetPasswordRxObj = ForgetPasswordRx(
// //   empty: ForgetPasswordModel(),
// //   dataFetcher: BehaviorSubject<ForgetPasswordModel>(),
// // );

// // ------------- Reset Password Api Access -----------------//
// ResetPasswordRx resetPasswordRxObj = ResetPasswordRx(
//   empty: SetNewPasswordModel(),
//   dataFetcher: BehaviorSubject<SetNewPasswordModel>(),
// );


// VerifyForgetPasswordOtpRx verifyForgetPasswordOtpRxObj = VerifyForgetPasswordOtpRx(
//   empty: ForgetPasswordOtpVerifyModel(),
//   dataFetcher: BehaviorSubject<ForgetPasswordOtpVerifyModel>(),
// );

// // //___________________ Verify Otp Api Access ______________________//

// // RegisterVerifyOtpRx registerVerifyOtpRxObj = RegisterVerifyOtpRx(
// //   empty: RegisterVerifyOtpModel(),
// //   dataFetcher: BehaviorSubject<RegisterVerifyOtpModel>(),
// // );

// // VerifyOtpForgetPasswordRx verifyOtpForgetPasswordRxObj =
// //     VerifyOtpForgetPasswordRx(
// //   empty: VerifyOtpForgetPasswordModel(),
// //   dataFetcher: BehaviorSubject<VerifyOtpForgetPasswordModel>(),
// // );

// // //_________________Resend Otp Api Access ______________________//
// // ResendOtpRx resendOtpRxObj = ResendOtpRx(
// //   empty: ResendOtpModel(),
// //   dataFetcher: BehaviorSubject<ResendOtpModel>(),
// // );

// // RegisterPropertyInfoRx registerPropertyInfoRxObj = RegisterPropertyInfoRx(
// //   empty: RegisterPropertyInfoModel(),
// //   dataFetcher: BehaviorSubject<RegisterPropertyInfoModel>(),
// // );

// //_________________LogOut Api Access ______________________//
// LogOutRx logOutRx = LogOutRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

// // //_________________Login Api Access ______________________//
// // LoginRx loginRxObj = LoginRx(
// //   empty: LoginModel(),
// //   dataFetcher: BehaviorSubject<LoginModel>(),
// // );



// // //_________________Resident Registration Api Access ______________________//
// // ResidentRegistrationRx residentRegistrationRxObj = ResidentRegistrationRx(
// //   empty: ResidentRegistrationModel(),
// //   dataFetcher: BehaviorSubject<ResidentRegistrationModel>(),
// // );

// // //_________________Get Property List Api Access ______________________//
// // GetPropertyListRx getpropertylistrxobj = GetPropertyListRx(
// //   empty: PropertyListModel(),
// //   dataFetcher: BehaviorSubject<PropertyListModel>(),
// // );

// // //_________________Delete Property Api Access ______________________//
// // DeletePropertyRx deletePropertyRxObj = DeletePropertyRx(
// //   empty: DeletePropertyModel(),
// //   dataFetcher: BehaviorSubject<DeletePropertyModel>(),
// // );

// // //_________________Update Property Api Access ______________________//
// // UpdatePropertyRx updatePropertyRxObj = UpdatePropertyRx(
// //   empty: UpdatePropertyModel(),
// //   dataFetcher: BehaviorSubject<UpdatePropertyModel>(),
// // );

// // //_________________Get Property Details Api Access ______________________//
// // PropertyDetailsRx propertyDetailsRxObj = PropertyDetailsRx(
// //   empty: PropertyDetailsModel(),
// //   dataFetcher: BehaviorSubject<PropertyDetailsModel>(),
// // );
// // //_________________Get All Resident Api Access ______________________//
// // GetAllResidentRx getAllResidentRxObj = GetAllResidentRx(
// //   empty: AllResidentModel(),
// //   dataFetcher: BehaviorSubject<AllResidentModel>(),
// // );

// // //_________________Delete Resident Api Access ______________________//
// // DeleteResidentRx deleteResidentRxObj = DeleteResidentRx(
// //   empty: DeleteResidentModel(),
// //   dataFetcher: BehaviorSubject<DeleteResidentModel>(),
// // );
// // //_________________ Get Property Api Access ______________________//
// // GetPropertyRx getPropertyRxObj = GetPropertyRx(
// //   empty: PropertyModel(),
// //   dataFetcher: BehaviorSubject<PropertyModel>(),
// // );

// // //_________________ Get Profile Api Access ______________________//
// // ProfileDataRX getProfileRXObj = ProfileDataRX(
// //   empty: ProfileDataGetModel(),
// //   dataFetcher: BehaviorSubject<ProfileDataGetModel>(),
// // );
// // UpdateProfileRx getUpdateProfileRx = UpdateProfileRx(
// //   empty: {},
// //   dataFetcher: BehaviorSubject<Map>(),
// // );
// // //_________________ Get Property Api Access ______________________//
// // AnnouncementTypeRx announcementTypeRxObj = AnnouncementTypeRx(
// //   empty: AnnouncementTypeModel(),
// //   dataFetcher: BehaviorSubject<AnnouncementTypeModel>(),
// // );
// // //_________________ Show Resident Details Api Access ______________________//
// // ShowResidentDetailsRx showResidentDetailsRxObj = ShowResidentDetailsRx(
// //   empty: ShowResidentDetailsModel(),
// //   dataFetcher: BehaviorSubject<ShowResidentDetailsModel>(),
// // );

// // //_________________ Resident Payment Detail Api Access ______________________//
// // ResidentPaymentDetailRx residentPaymentDetailRxObj = ResidentPaymentDetailRx(
// //   empty: ResidentPaymentDetailModel(),
// //   dataFetcher: BehaviorSubject<ResidentPaymentDetailModel>(),
// // );

// // EmergencyCategoryRx emergencyCategoryRxObj = EmergencyCategoryRx(
// //   empty: EmergencyCategoryModel(),
// //   dataFetcher: BehaviorSubject<EmergencyCategoryModel>(),
// // );

// // //_________________ Create Emergency Api Access ______________________//
// // CreateEmergencyRx createEmergencyRxObj = CreateEmergencyRx(
// //   empty: EmergencyCreateModel(),
// //   dataFetcher: BehaviorSubject<EmergencyCreateModel>(),
// // );

// // //_________________ Create Announcement Api Access ______________________//
// // CreateAnnouncementRx createAnnouncementRxObj = CreateAnnouncementRx(
// //   empty: CreateAnnouncementModel(),
// //   dataFetcher: BehaviorSubject<CreateAnnouncementModel>(),
// // );

// // //_________________ Residents Announcement Api Access ______________________//
// // ResidentsAnnouncementRx residentsAnnouncementRxObj = ResidentsAnnouncementRx(
// //   empty: ResidentsAnnouncementModel(),
// //   dataFetcher: BehaviorSubject<ResidentsAnnouncementModel>(),
// // );
// // //_________________ Residents  list Api Access ______________________//
// // GetResidentsListRx getResidentsListRxObj = GetResidentsListRx(
// //   empty: ResidentListModel(),
// //   dataFetcher: BehaviorSubject<ResidentListModel>.seeded(ResidentListModel()),
// // );

// // //_________________ Get New Announcement Api Access ______________________//
// // GetNewAnnouncementRx getNewAnnouncementRxObj = GetNewAnnouncementRx(
// //   empty: NewAnnouncementModel(),
// //   dataFetcher: BehaviorSubject<NewAnnouncementModel>(),
// // );
// // //_________________ Delete Announcement Api Access ______________________//
// // DeleteAnnouncementRx deleteAnnouncementRxObj = DeleteAnnouncementRx(
// //   empty: DeleteAnnouncementModel(),
// //   dataFetcher: BehaviorSubject<DeleteAnnouncementModel>(),
// // );
// // //_________________ Draft Announcement Api Access ______________________//
// // DraftAnnouncementRx draftAnnouncementRxObj = DraftAnnouncementRx(
// //   empty: DraftAnnouncementModel(),
// //   dataFetcher: BehaviorSubject<DraftAnnouncementModel>(),
// // );
// // //_________________ Previous Announcement Api Access ______________________//
// // PreviousAnnouncementRx previousAnnouncementRxObj = PreviousAnnouncementRx(
// //   empty: PreviousAnnouncementModel(),
// //   dataFetcher: BehaviorSubject<PreviousAnnouncementModel>(),
// // );

// // //_________________ Update Announcement Api Access ______________________//
// // UpdateAnnouncementRx updateAnnouncementRx = UpdateAnnouncementRx(
// //   empty: UpdateAnnouncementModel(),
// //   dataFetcher: BehaviorSubject<UpdateAnnouncementModel>(),
// // );

// // ShowAnnouncementDetailsRx showAnnouncementDetailsRxObj =
// //     ShowAnnouncementDetailsRx.instance;

// // //_________________ Maintenance Category Api Access ______________________//
// // MaintenanceCategoryRx maintenanceCategoryRxObj = MaintenanceCategoryRx(
// //   empty: MaintenanceRequestModel(),
// //   dataFetcher: BehaviorSubject<MaintenanceRequestModel>(),
// // );

// // ChangePassRX getChangePassRXObj = ChangePassRX(
// //   empty: {},
// //   dataFetcher: BehaviorSubject<Map>(),
// // );

// // // VerifyEmailRx verifyEmailRxObj = VerifyEmailRx(
// // //     empty: RegisterModel(), dataFetcher: BehaviorSubject<RegisterModel>());

// // //_________________ Faq Api Access ______________________//
// // FaqRx faqRxObj = FaqRx(
// //   empty: FaqModel(),
// //   dataFetcher: BehaviorSubject<FaqModel>(),
// // );
// // //_________________ Category Api Access ______________________//
// // GetPaymentRequestCategoryRx getPaymentRequestCategoryRxObj =
// //     GetPaymentRequestCategoryRx(
// //   empty: PaymentRequestCategoryModel(),
// //   dataFetcher: BehaviorSubject<PaymentRequestCategoryModel>(),
// // );
// // //_________________ Category Api Access ______________________//
// // PaymentRequestCreateRx getPaymentRequestCreateRxObj = PaymentRequestCreateRx(
// //   empty: {},
// //   dataFetcher: BehaviorSubject<Map>(),
// // );

// // // _____________ Add Property Api Access _____________
// // AddPropertyRx addPropertyRxObj = AddPropertyRx(
// //   empty: AddPropertyModel(),
// //   dataFetcher: BehaviorSubject<AddPropertyModel>(),
// // );

// // // _____________ Show Resident By Property Api Access _____________
// // ShowResidentByPropertyRx showResidentByPropertyRxObj = ShowResidentByPropertyRx(
// //   empty: ShowResidentByPropertyModel(),
// //   dataFetcher: BehaviorSubject<ShowResidentByPropertyModel>(),
// // );

// // // _____________ Create Payment Reminder Api Access _____________
// // CreatePaymentReminderRx createPaymentReminderRxObj = CreatePaymentReminderRx(
// //   empty: CreatePaymentReminderModel(),
// //   dataFetcher: BehaviorSubject<CreatePaymentReminderModel>(),
// // );

// // // _____________ Payment Reminder List Api Access _____________
// // PaymentReminderListRx paymentReminderListRxObj = PaymentReminderListRx(
// //   empty: PaymentReminderListModel(),
// //   dataFetcher: BehaviorSubject<PaymentReminderListModel>(),
// // );

// // // _____________ Home Screen  Api Access _____________
// // HomeporichalokRx homeporichalokRxObj = HomeporichalokRx(
// //   empty: HomePorichalokModel(),
// //   dataFetcher: BehaviorSubject<HomePorichalokModel>(),
// // );

// // // _____________ Get Subscription Plan Api Access _____________
// // GeSubscriptionPlanRx geSubscriptionPlanRxObj = GeSubscriptionPlanRx(
// //     empty: UpgradePlanModel(),
// //     dataFetcher: BehaviorSubject<UpgradePlanModel>());

// // // _____________ Get Subscription Plan Api Access _____________
// // GetSecurityCategoryRx getSecurityCategoryRxObj = GetSecurityCategoryRx(
// //     empty: GetCategoryModel(),
// //     dataFetcher: BehaviorSubject<GetCategoryModel>());

// // CreateSecurityContactRx createSecurityContactRxObj = CreateSecurityContactRx(
// //     empty: CreateSecurityContactsModel(),
// //     dataFetcher: BehaviorSubject<CreateSecurityContactsModel>());

// // GetSecurityContactListRx getSecurityContactListRxObj = GetSecurityContactListRx(
// //     empty: ShowSecurityContactsModel(),
// //     dataFetcher: BehaviorSubject<ShowSecurityContactsModel>());

// // // _____________ Delete Security Contact Api Access _____________
// // DeleteSecurityContactRx deleteSecurityContactRxObj = DeleteSecurityContactRx();

// // // _____________ Update Security Contact Api Access _____________
// // UpdateSecurityContactRx updateSecurityContactRxObj = UpdateSecurityContactRx();

// // // _____________ Security Contact Details Api Access _____________
// // SecurityContactDetailsRx securityContactDetailsRxObj =
// //     SecurityContactDetailsRx();

// // // _____________ Document Category Api Access _____________
// // DocumentCategoryRx documentCategoryRxObj = DocumentCategoryRx(
// //   empty: DocumentCategoryModel(),
// //   dataFetcher: BehaviorSubject<DocumentCategoryModel>(),
// // );

// // // _____________ Create Document Api Access _____________
// // CreateDocumentRx createDocumentRxObj = CreateDocumentRx(
// //   empty: CreateDocumentModel(),
// //   dataFetcher: BehaviorSubject<CreateDocumentModel>(),
// // );

// // // _____________ Document List Api Access _____________
// // DocumentListRx documentListRxObj = DocumentListRx(
// //   empty: DocumentListModel(),
// //   dataFetcher: BehaviorSubject<DocumentListModel>(),
// // );

// // // _____________ Delete Document Api Access _____________
// // DeleteDocumentRx deleteDocumentRxObj = DeleteDocumentRx(
// //   empty: DeleteDocumentModel(),
// //   dataFetcher: BehaviorSubject<DeleteDocumentModel>(),
// // );

// // // _____________ My property Api Access _____________
// // GetMyPropertyRx getMyPropertyRxObj = GetMyPropertyRx(
// //   empty: MyPropertyModel(),
// //   dataFetcher: BehaviorSubject<MyPropertyModel>(),
// // );
// // // _____________ My property Api Access _____________
// // GetSecurityContactListResidentRx getSecurityContactListResidentRxObj =
// //     GetSecurityContactListResidentRx(
// //   empty: SecurityContactListModel(),
// //   dataFetcher: BehaviorSubject<SecurityContactListModel>(),
// // );

// // // _____________ Document Details Api Access _____________
// // DocumentDetailsRx documentDetailsRxObj = DocumentDetailsRx(
// //   empty: DocumentDetailsModel(),
// //   dataFetcher: BehaviorSubject<DocumentDetailsModel>(),
// // );

// // // _____________ Update Document Api Access _____________
// // UpdateDocumentRx updateDocumentRxObj = UpdateDocumentRx(
// //   empty: UpdateDocumentModel(),
// //   dataFetcher: BehaviorSubject<UpdateDocumentModel>(),
// // );

// // // _____________ Payment Request List Api Access _____________
// // PaymentRequestListRx paymentRequestListRxObj = PaymentRequestListRx(
// //   empty: RequestPaymentModel(),
// //   dataFetcher: BehaviorSubject<RequestPaymentModel>(),
// // );

// // // _____________ Payment Request Details Api Access _____________
// // PaymentRequestDetailsRx paymentRequestDetailsRxObj = PaymentRequestDetailsRx(
// //   empty: RequestPaymentDetailsModel(),
// //   dataFetcher: BehaviorSubject<RequestPaymentDetailsModel>(),
// // );

// // DeleteAccountRx deleteAccountRxObj =
// //     DeleteAccountRx(empty: Map(), dataFetcher: BehaviorSubject<Map>());

// // // _____________ Search Resident Api Access _____________
// // SearchResidentRx searchResidentRxObj = SearchResidentRx(
// //   empty: SearchResidentModel(),
// //   dataFetcher: BehaviorSubject<SearchResidentModel>(),
// // );

// // // _____________ Neighbors List Api Access _____________
// // NeighborsListRx neighborsListRxObj = NeighborsListRx(
// //   empty: NeighborsListModel(),
// //   dataFetcher: BehaviorSubject<NeighborsListModel>(),
// // );

// // // _____________ Property Porichalok Rules And Regulation Api Access _____________
// // PropertyPorichalokRulesAndRegulationRx
// //     propertyPorichalokRulesAndRegulationRxObj =
// //     PropertyPorichalokRulesAndRegulationRx(
// //         empty: PropertyPorichalokRulesAndRegulationModel(),
// //         dataFetcher:
// //             BehaviorSubject<PropertyPorichalokRulesAndRegulationModel>());
// // // _____________ Support  Api Access _____________
// // SupportRx supportRxObj = SupportRx(
// //   empty: SupportModel(),
// //   dataFetcher: BehaviorSubject<SupportModel>(),
// // );

// // // _____________ Rules and Regulation  Api Access _____________
// // RuleAndRegulationRx ruleAndRegulationRxObj = RuleAndRegulationRx(
// //   empty: RuleAndRegulationModel(),
// //   dataFetcher: BehaviorSubject<RuleAndRegulationModel>(),
// // );

// // // _____________ All Maintenance  Api Access _____________
// // AllMaintenanceRx allMaintenanceRxObj = AllMaintenanceRx(
// //   empty: MaintenanceModel(),
// //   dataFetcher: BehaviorSubject<MaintenanceModel>(),
// // );

// // // _____________ Create Maintenance  Api Access _____________
// // CreateMaintenanceRx createMaintenanceRxObj = CreateMaintenanceRx(
// //   empty: CreateMaintenanceModel(),
// //   dataFetcher: BehaviorSubject<CreateMaintenanceModel>(),
// // );

// // // _____________ Create Maintenance  Api Access _____________
// // DeleteMaintenanceRx deleteMaintenanceRxObj = DeleteMaintenanceRx(
// //   empty: DeleteMaintenanceModel(),
// //   dataFetcher: BehaviorSubject<DeleteMaintenanceModel>(),
// // );
// // // _____________ Create Rules and Regulations  Api Access _____________
// // CreateRulesAndRegulationsRx createRulesAndRegulationRxObj =
// //     CreateRulesAndRegulationsRx(
// //   empty: CreateRulesAndRegulationModel(),
// //   dataFetcher: BehaviorSubject<CreateRulesAndRegulationModel>(),
// // );

// // // _____________ Show Details Rules and Regulations  Api Access _____________
// // ShowDetailsRulesAndRegulationRx showDetailsRulesAndRegulationRxObj =
// //     ShowDetailsRulesAndRegulationRx.showDetailsRulesAndRegulationRxInstance;

// // // _____________ My Property  Api Access _____________
// // MyPropertyRx myPropertyRxObj = MyPropertyRx(
// //   empty: MyPropertyModel(),
// //   dataFetcher: BehaviorSubject<MyPropertyModel>.seeded(MyPropertyModel()),
// // );

// // // _____________ Due Invoice  Api Access _____________
// // DueInvoiceRx dueInvoiceRxObj = DueInvoiceRx(
// //   empty: DueInvoiceModel(),
// //   dataFetcher: BehaviorSubject<DueInvoiceModel>(),
// // );
// // // _____________ Resident Property  Api Access _____________
// // ResidentPropertyRx residentPropertyRxObj = ResidentPropertyRx(
// //   empty: ResidentPropertyModel(),
// //   dataFetcher: BehaviorSubject<ResidentPropertyModel>(),
// // );

// // // _____________ Resident Emergency Request List  Api Access _____________
// // ResidentEmergencyRequestListRx residentEmergencyRequestListRxObj =
// //     ResidentEmergencyRequestListRx(
// //   empty: ResidentListOfEmergencyRequestModel(),
// //   dataFetcher: BehaviorSubject<ResidentListOfEmergencyRequestModel>(),
// // );

// // // _____________ Resident Emergency Request Details  Api Access _____________
// // ResidentEmergencyRequestDetailsRx residentEmergencyRequestDetailsRxObj =
// //     ResidentEmergencyRequestDetailsRx(
// //   empty: ResidentEmergencyRequestListModel(),
// //   dataFetcher: BehaviorSubject<ResidentEmergencyRequestListModel>(),
// // );

// // // _____________ Resident Emergency Request Delete  Api Access _____________
// // ResidentDeleteEmergencyRequestRx residentDeleteEmergencyRequestRxObj =
// //     ResidentDeleteEmergencyRequestRx(
// //   empty: DeleteEmergencyRequestModel(),
// //   dataFetcher: BehaviorSubject<DeleteEmergencyRequestModel>(),
// // );

// // // _____________ Property Porichalok Emergency Request List  Api Access _____________
// // PropertyPorichalokEmergencyRequestRx propertyPorichalokEmergencyRequestRxObj =
// //     PropertyPorichalokEmergencyRequestRx(
// //   empty: PropertyPorichalokEmergencyListModel(),
// //   dataFetcher: BehaviorSubject<PropertyPorichalokEmergencyListModel>(),
// // );

// // // _____________Total Due List  Api Access _____________
// // TotalDueRx totalDueRxObj = TotalDueRx(
// //   empty: TotalDueModel(),
// //   dataFetcher: BehaviorSubject<TotalDueModel>.seeded(TotalDueModel()),
// // );

// // // _____________Statement List Api Access _____________
// // StatementRx statementRxObj = StatementRx(
// //   empty: StatementScreenModel(),
// //   dataFetcher: BehaviorSubject<StatementScreenModel>(),
// // );

// // // _____________First Property Api Access _____________
// // FirstPropertyRx firstPropertyRxObj = FirstPropertyRx(
// //   empty: FirstPropertyModel(),
// //   dataFetcher: BehaviorSubject<FirstPropertyModel>(),
// // );

// // // _____________ All Property List Api Access _____________
// // GetAllPropertyListRx getAllPropertyListRxObj = GetAllPropertyListRx(
// //   empty: AllPropertyListModel(),
// //   dataFetcher: BehaviorSubject<AllPropertyListModel>(),
// // );

// // // _____________ Create Referal Management Api Access _____________
// // CreateReferalManagementRx createReferalManagementRxObj =
// //     CreateReferalManagementRx(
// //   empty: CreateReferalManagementModel(),
// //   dataFetcher: BehaviorSubject<CreateReferalManagementModel>(),
// // );
// // // _____________ Conversation Create  Api Access _____________
// // ConversationCreateRx conversationCreateRxObj = ConversationCreateRx(
// //   empty: {},
// //   dataFetcher: BehaviorSubject<Map>(),
// // );

// // // _____________ Chat List Api Access _____________
// // ChatListRx getChatListRxObj = ChatListRx(
// //   empty: ChatListModel(),
// //   dataFetcher: BehaviorSubject<ChatListModel>(),
// // );
// // // _____________ Chat Message Api Access _____________
// // ChatMessageRx getChatMessageRxObj = ChatMessageRx(
// //   empty: ChatMessageModel(),
// //   dataFetcher: BehaviorSubject<ChatMessageModel>(),
// // );

// // // _____________ Send Message Api Access _____________
// // SendMessageRx getSendMessageRxObj = SendMessageRx(
// //   empty: {},
// //   dataFetcher: BehaviorSubject<Map>(),
// // );

// // // _____________ Payment History Api Access _____________
// // PaymentHistoryRx getPaymentHistoryRxObj = PaymentHistoryRx(
// //   empty: PaymentHistoryModel(),
// //   dataFetcher: BehaviorSubject<PaymentHistoryModel>(),
// // );

// // // _____________ Resident Notification Api Access _____________
// // ResidentNotificationRx residentNotificationRx = ResidentNotificationRx(
// //   empty: ResidentNotificationModel(),
// //   dataFetcher: BehaviorSubject<ResidentNotificationModel>(),
// // );

// // // _____________ Property Notification Api Access _____________
// // PropertyPorichalokNotificationRx propertyPorichalokNotificationRxObj =
// //     PropertyPorichalokNotificationRx(
// //   empty: PropertyNotificationModel(),
// //   dataFetcher: BehaviorSubject<PropertyNotificationModel>(),
// // );

// // // _____________ Cash Payment Api Access _____________
// // CashPaymentRx cashPaymentRxObj = CashPaymentRx(
// //   empty: PaymentWithCashModel(),
// //   dataFetcher: BehaviorSubject<PaymentWithCashModel>(),
// // );

// // // _____________ Online Payment Api Access _____________
// // OnlinePaymentRx onlinePaymentRxObj = OnlinePaymentRx(
// //   empty: PaymentWithOnlineModel(),
// //   dataFetcher: BehaviorSubject<PaymentWithOnlineModel>(),
// // );

// // // _____________ Delete Notification Api Access _____________
// // DeleteNotificationRx deleteNotificationRxObj = DeleteNotificationRx(
// //   empty: DeleteNotificationModel(),
// //   dataFetcher: BehaviorSubject<DeleteNotificationModel>(),
// // );

// // MarkAsPaidOrDeclineRx markAsPaidOrDeclineRxObj = MarkAsPaidOrDeclineRx(
// //   empty: MarkAsPaidOrDeclineModel(),
// //   dataFetcher: BehaviorSubject<MarkAsPaidOrDeclineModel>(),
// // );
