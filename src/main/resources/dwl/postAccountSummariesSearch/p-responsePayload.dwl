%dw 2.0
output application/json skipNullOn = "everywhere"

var contacts = payload.response.getAccountSummaryResponse.contactCollection default []
var noMatch = ((vars.httpStatus default 200) as String == "404") or isEmpty(contacts)

fun s(v) = if (v == null) "" else v as String

fun mapContract(c) = {
    contractId: s(c.contractId),
    contractPublicRef: s(c.contractPublicRef),
    optionPosition: c.optionPosition,
    version: c.version,
    contractStatusCode: s(c.contractStatusCode),
    contractStatusName: s(c.contractStatusName),
    coverageStartDate: s(c.coverageStartDate),
    coverageEndDate: s(c.coverageEndDate),
    startDate: s(c.startDate),
    productOfferCode: s(c.productOfferCode),
    contractname: s(c.contractname),
    partnerCode: s(c.partnerCode),
    partnerName: s(c.partnerName),
    companyName: s(c.companyName),
    contractStatusDescription: s(c.contractStatusDescription),
    serviceCustomerRef: s(c.serviceCustomerRef),
    serviceCallFee: c.serviceCallFee
}

fun mapAddress(a) = {
    accountAddressId: s(a.accountAddressId),
    customerRef: s(a.customerRef),
    addressType: s(a.addressType),
    houseNo: s(a.houseNo),
    addressLine1: s(a.addressLine1),
    addressLine2: s(a.addressLine2),
    city: s(a.city),
    state: s(a.state),
    zipCode: s(a.zipCode),
    country: s(a.country),
    locationType: a.locationType,
    addressExternalId: s(a.addressExternalId),
    contractCollection: (a.contractCollection default []) map mapContract($)
}

fun mapContact(c) = {
    contactId: s(c.contactId),
    firstName: s(c.firstName),
    lastName: s(c.lastName),
    homephone: s(c.homephone),
    mobilephone: s(c.mobilephone),
    email: s(c.email),
    addressCollection: (c.addressCollection default []) map mapAddress($)
}

---
{
    response: {
        sourceSystemRefId: vars.commonHeaders.sourceSystemRefId default "",
        sourceSystemName: vars.commonHeaders.sourceSystemName default "CCA",
        sourceSystemVersion: vars.commonHeaders.sourceSystemVersion default "1.0",
        transactionId: vars.commonHeaders.transactionId default vars.vCorrelationId,
        outcome: if (noMatch) {
            resultCode: "200",
            resultDescription: "No contact found"
        } else {
            resultCode: "100",
            resultDescription: "Success"
        },
        (if (noMatch) {
            errorDetails: {
                errorDetail: {
                    errorCode: "404",
                    errorDescription: "No contact found for the supplied account summary criteria"
                }
            }
        } else {
            getAccountSummaryResponse: {
                contactCollection: contacts map mapContact($)
            }
        })
    }
}
