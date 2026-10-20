%dw 2.0
output application/json skipNullOn = "everywhere"
var criteria = payload.request.getContactRequest default {}
---
{
	host: Mule::p('papi.host'),
	port: Mule::p('papi.port'),
	method: Mule::p('papi.method.get'),
	basePath: Mule::p('papi.basePath'),
	path: Mule::p('papi.path.contacts'),
	headers: {
		"X-Correlation-ID": vars.commonHeaders.transactionId,
		"X-Trace-ID": vars.commonHeaders.traceId,
		sourceSystemName: vars.commonHeaders.sourceSystemName,
		sourceSystemVersion: vars.commonHeaders.sourceSystemVersion,
		sourceSystemRefId: vars.commonHeaders.sourceSystemRefId,
		client_id: Mule::p('secure::papi.client.id'),
		client_secret: Mule::p('secure::papi.client.secret')
	},
	uriParameters: {
	},
	queryParams: ({
		contactId: criteria.contactId,
		email: criteria.email,
		firstName: criteria.firstName,
		lastName: criteria.lastName,
		houseNo: criteria.houseNo,
		street: criteria.street,
		city: criteria.city,
		state: criteria.state,
		zipcode: criteria.zipcode,
		country: criteria.country,
		identityManager: criteria.identityManager,
		identityUniqueId: criteria.identityUniqueId,
		telephone: criteria.telephone,
		accountAddressId: criteria.accountAddressId
	} filterObject ((value) -> value != null and trim(value as String) != ""))
	mapObject ((value, key) -> (key): value as String)
}