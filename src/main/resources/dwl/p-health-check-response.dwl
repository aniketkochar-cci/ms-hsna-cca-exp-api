%dw 2.0
output application/json
---
{
	"status" : p('api.message'),
	"appName" : p('api.name')
}