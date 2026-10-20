%dw 2.0
output application/json skipNullOn = "everywhere"
var criteria = payload.request.getAccountSummaryRequest default {}
---
{
	host: Mule::p('papi..host'),
	port: Mule::p('papi..port'),
	method: Mule::p('papi..method.get'),
	basePath: Mule::p('papi..basePath'),
	path: Mule::p('papi..path.contacts'),
	headers: {
		"X-Correlation-ID": vars.commonHeaders.transactionId,
		"X-Trace-ID": vars.commonHeaders.traceId,
		sourceSystemName: vars.commonHeaders.sourceSystemName,
		sourceSystemVersion: vars.commonHeaders.sourceSystemVersion,
		sourceSystemRefId: vars.commonHeaders.sourceSystemRefId
	},
	uriParameters: {
	},
	queryParams: ({
		contactId: criteria.contactId,
		accountAddressId: criteria.accountAddressId,
		contractStatusActive: criteria.contractStatusActive,
		customerRef: criteria.customerRef
	} filterObject ((value) -> value != null and trim(value as String) != ""))
	mapObject ((value, key) -> (key): value as String)
}