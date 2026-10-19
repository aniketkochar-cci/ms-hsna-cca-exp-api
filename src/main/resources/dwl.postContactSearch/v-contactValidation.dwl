%dw 2.0
output application/java
var contactValue = payload.request.getContactRequest default {}
---
{
  envelopeOk: !isEmpty(payload.request.sourceSystemName)
           and payload.request.sourceSystemName == "CCA"
           and !isEmpty(payload.request.sourceSystemVersion)
           and !isEmpty(payload.request.sourceSystemRefId),
  hasCriteria: (contactValue pluck $) some ((v) -> !isEmpty(v as String default ""))
}

