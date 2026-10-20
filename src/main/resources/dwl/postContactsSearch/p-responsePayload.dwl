%dw 2.0
output application/json skipNullOn = "everywhere"
var contacts = payload.response.getContactResponse.contactCollection default []
var noMatch = ((vars.httpStatus as String) == "404") or isEmpty(contacts)
fun s(v) = if ( v == null ) "" else v as String
fun boolStr(v) = if ( v == null ) "false" else lower(v as String)
fun mapAddress(a) = {
	addressType: s(a.addressType),
	customerRef: s(a.customerRef),
	accountAddressId: s(a.accountAddressId),
	houseNo: s(a.houseNo),
	addressLine1: s(a.addressLine1),
	addressLine2: s(a.addressLine2),
	city: s(a.city),
	state: s(a.state),
	zipcode: s(a.zipcode),
	country: s(a.country),
	locationType: a.locationType,
	taxExempt: a.taxExempt,
	authUser: a.authUser,
	masterFlag: a.masterFlag default false,
	noOfContracts: a.noOfContracts default 0
}
fun mapContact(c) = {
	contactId: s(c.contactId),
	accountId: c.accountId,
	customerRef: c.customerRef,
	title: c.title,
	firstName: s(c.firstName),
	lastName: s(c.lastName),
	suffix: c.suffix,
	email: s(c.email),
	mobilePhone: s(c.mobilePhone),
	homePhone: s(c.homePhone),
	workPhone: c.workPhone,
	workPhoneExtn: c.workPhoneExtn,
	status: c.status,
	identityManager: c.identityManager,
	identityUniqueId: c.identityUniqueId,
	paperless: boolStr(c.paperless),
	paperlessStatus: s(c.paperlessStatus),
	customerType: c.customerType,
	noEmail: c.noEmail,
	noMail: c.noMail,
	noShare: c.noShare,
	noTeleSales: c.noTeleSales,
	advocateId: c.advocateId,
	totalReferralsMade: c.totalReferralsMade,
	contactSFID: c.contactSFID,
	smsMarketing: c.smsMarketing,
	smsMarketingSubStatus: c.smsMarketingSubStatus,
	smsMarketingSource: c.smsMarketingSource,
	emailMarketingSource: c.emailMarketingSource,
	experianConfidenceMobile: c.experianConfidenceMobile,
	experianCheckDateMobile: c.experianCheckDateMobile,
	verifiedUSAAMemberID: c.verifiedUSAAMemberID,
	unverifiedUSAAMemberID: c.unverifiedUSAAMemberID,
	addressCollection: (c.addressCollection default []) map mapAddress($)
}
---
{
	response: {
		sourceSystemRefId: vars.commonHeaders.sourceSystemRefId default "",
		sourceSystemName: vars.commonHeaders.sourceSystemName default "",
		sourceSystemVersion: vars.commonHeaders.sourceSystemVersion default "",
		transactionId: vars.commonHeaders.transactionId default vars.vCorrelationId,
		outcome: if ( noMatch ) {
			resultCode: "200",
			resultDescription: "No contact found"
		}
		else {
			resultCode: "100",
			resultDescription: "Success"
		},
		(if ( noMatch ) {
			errorDetails: {
				errorDetail: {
					errorCode: "404",
					errorDescription: "No contact found for the supplied search criteria"
				}
			}
		}
		else {
			getContactResponse: {
				contactCollection: contacts map mapContact($)
			}
		})
	}
}