# soql-secure
A library to build/execute SOQL from JSON definition in Apex with secure FLS check

## Usage

#### Server(Apex)

```java
public with sharing class MyRemoteController {    
    @RemoteAction
    public static List<SObject> query(String queryJSON) {
        Map<String, Object> qconfig = (Map<String, Object>) JSON.deserializeUntyped(queryJSON);
        Query query = new Query(qconfig);
        query.validate(); // HERE we check FLS and other access control
        return Database.query(query.toSOQL());
    }
}
```

### Client (JavaScript in Visualforce) 

```javascript
// Define query in JSON
var queryConfig = {
  "fields": [ "Id", "Name", "Account.Name" ],
  "table": "Contact",
  "condition": {
    "operator": "AND",
    "conditions": [{
       "field": "CloseDate",
       "operator": "=",
       "value": { "type": "date", "value": "THIS_MONTH" }
    }, {
       "field": "Amount",
       "operator": ">",
       "value": 20000
    }]
  },
  "sortInfo": [{
    "field": "CloseDate",
    "direction": "ASC"
  }],
  "limit": 10000
};
// Pass the query config to Apex through JavaScript Remoting. JSON should be serialized in advance.
MyRemoteController.query(JSON.stringify(queryConfig), function(records, event) {
  if (event.status) {
    console.log(records);
  } else {
    console.error(event.message + ': ' + event.where);
  }
});
```

## Comparison between other solutions

1. REST/SOAP API
  - Consumes API request quota

2. JavaScript Remoting 
  - Doesn't have enough flexibility to build query in client side (JavaScript)

3. RemoteTK
  - Not secure because it doesn't check FLS, cannot be used in production
  - Recently removed from official Toolkit

4. Visualforce Remote Objects
  - Target Object/Field must be pre-defined in Page definition
  - Not supporting relationship query
