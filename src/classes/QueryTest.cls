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
			'      "value" : "A%" ' +
			'    }, { ' +
			'      "field" : "Amount", ' +
			'      "operator" : ">=", ' +
			'      "value" : 500000 ' +
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
			'            "value" : "TODAY" ' +
			'          } ' +
			'        }, { ' +
			'          "field" : "CloseDate", ' +
			'          "operator" : "<", ' +
			'          "value" : { ' +
			'            "type" : "date", ' +
			'            "value" : "2015-12-31" ' +
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
			'Account.Name LIKE \'A%\' ' +
			'AND ' +
			'Amount >= 500000 ' +
			'AND ' +
			'(' +
			  'Account.Owner.Username != \'user01@example.com\' ' +
				'OR ' +
			  '(CloseDate >= TODAY AND CloseDate < 2015-12-31)' +
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