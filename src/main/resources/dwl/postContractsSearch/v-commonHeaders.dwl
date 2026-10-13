%dw 2.0
output application/json
---
{
	sourceSystemName: attributes.headers.sourceSystemName,
	sourceSystemVersion: attributes.headers.sourceSystemVersion,
	sourceSystemRefId: attributes.headers.sourceSystemRefId,
	transactionId: attributes.headers.transactionid,
}