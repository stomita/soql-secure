@isTest
private class QueryTest {

	@isTest
	static void testQuery() {
		Map<String, Object> config = (Map<String, Object>) JSON.deserializeUntyped(
			'{' +
			'  "fields" : ["Id", "Name", "Account.Id", "Account.Name"], ' +
			'  "table" : "Opportunity", ' +
			'  "condition" : { ' +
			'    "mode" : "AND", ' +
			'    "conditions": [{' +
			'      "field" : "Account.Name", ' +
			'      "operator" : "LIKE", ' +
			'      "value" : "%a%" ' +
			'    }, { ' +
			'      "field" : "Amount", ' +
			'      "operator" : ">=", ' +
			'      "value" : 5000 ' +
			'    }, { ' +
			'      "field" : "Type", ' +
			'      "operator" : "!=", ' +
			'      "value" : null ' +
			'    }, { ' +
			'      "mode" : "OR", ' +
			'      "conditions": [{' +
			'        "field" : "Account.Owner.Username", ' +
			'        "operator" : "!=", ' +
			'        "value" : "user01@example.com" ' +
			'      }, { ' +
			'        "mode" : "AND", ' +
			'        "conditions": [{' +
			'          "field" : "CloseDate", ' +
			'          "operator" : ">=", ' +
			'          "value" : { ' +
			'            "type" : "date", ' +
			'            "value" : "2008-01-01" ' +
			'          } ' +
			'        }, { ' +
			'          "field" : "CloseDate", ' +
			'          "operator" : "<", ' +
			'          "value" : { ' +
			'            "type" : "date", ' +
			'            "value" : "TODAY" ' +
			'          } ' +
			'        }] ' +
			'      }] ' +
			'    }] ' +
			'  }, ' +
			'  "sortInfo": [{ ' +
			'    "field" : "Account.Type", ' +
			'    "direction" : "ASC", ' +
			'    "nullOrder" : "LAST" ' +
			'  }, { ' +
			'    "field" : "Amount", ' +
			'    "direction" : "DESC" ' +
			'  }], ' +
			'  "limit" : 1000 ' +
			'}'
		);
		Query q = new Query(config);
		q.validate();
		String soql = q.toSOQL();
		System.debug(soql);
		String expectedSOQL =
			'SELECT Id, Name, Account.Id, Account.Name ' +
			'FROM Opportunity ' +
			'WHERE ' +
			'Account.Name LIKE \'%a%\' ' +
			'AND ' +
			'Amount >= 5000 ' +
			'AND ' +
			'Type != null ' +
			'AND ' +
			'(' +
			  'Account.Owner.Username != \'user01@example.com\' ' +
				'OR ' +
			  '(CloseDate >= 2008-01-01 AND CloseDate < TODAY)' +
			') ' +
			'ORDER BY Account.Type ASC NULLS LAST, Amount DESC ' +
			'LIMIT 1000';
		System.assert(soql == expectedSOQL, 'unexpected SOQL: ' + soql + '\n expected : ' + expectedSOQL);

		List<SObject> records = q.execute();
		for (SObject rec : records) {
			Opportunity opp = (Opportunity) rec;
			System.assert(opp.Account.Name.substring(0, 1) == 'B');
			System.assert(opp.Amount > 50000);
		}
	}

}
