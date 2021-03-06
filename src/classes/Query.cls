public with sharing class Query implements QueryElement {
	public Field[] fields { get; set; }
	public String table { get; set; }
	public Condition condition { get; set; }
	public SortInfo[] sortInfo { get; set; }
	public Integer queryLimit { get; set; }
	public Integer offset { get; set; }

	public Query(Map<String, Object> config) {
		this.table = (String) config.get('table');
		System.debug('table = ' + this.table);
		this.fields = new Field[] {};
		Object[] fields = (Object[]) config.get('fields');
		if (fields != null) {
			for (Object field : fields) {
				System.debug('field = ' + field);
				this.fields.add(new Field((String) field, this.table));
			}
		}
		Map<String, Object> cond = (Map<String, Object>) config.get('condition');
		if (cond != null) {
			this.condition = ConditionBuilder.buildCondition(cond, this.table, true);
		}
		Object[] sortInfo = (Object[]) config.get('sortInfo');
		if (sortInfo != null) {
			this.sortInfo = new SortInfo[] {};
			for (Object s: sortInfo) {
				this.sortInfo.add(new SortInfo((Map<String, Object>) s, this.table));
			}
		}
		this.queryLimit = (Integer) config.get('limit');
		this.offset = (Integer) config.get('offset');
	}

	public void validate() {
		System.debug('Validating Table: ' + this.table);
		if (!MetadataValidator.isObjectAccessible(this.table)) {
			throw new InvalidQueryException('Querying object is not available or not accessible : ' + this.table);
		}
		if (fields == null) { throw new InvalidQueryException('fields are not defined in query config'); }
		System.debug('Validating Fields: ');
		for (Field field : this.fields) {
			field.validate();
		}
		System.debug('Validating Conditions: ');
		if (this.condition != null) {
			this.condition.validate();
		}
		System.debug('Validating Sort Info: ');
		if (this.sortInfo != null) {
			for (SortInfo sortInfo : this.sortInfo) {
				sortInfo.validate();
			}
		}
		System.debug('Validating Query Limit and Offset: ');
		if (this.queryLimit != null && this.queryLimit <= 0) {
			throw new InvalidQueryException('Query limit should be plus integer: ' + this.queryLimit);
		}
		if (this.offset != null && this.offset <= 0) {
			throw new InvalidQueryException('Query offset should be plus integer: ' + this.queryLimit);
		}
	}

	public String toSOQL() {
		String[] fieldStrings = new String[] {};
		for (Field field : this.fields) {
			fieldStrings.add(field.toSOQL());
		}
		String soql = 'SELECT ' + String.join(fieldStrings, ', ') + ' FROM ' + this.table;
		if (this.condition != null) {
			soql += ' WHERE ' + this.condition.toSOQL();
		}
		if (this.sortInfo != null && this.sortInfo.size() > 0) {
			String[] sortInfoStrings = new String[] {};
			for (SortInfo si: this.sortInfo) {
				sortInfoStrings.add(si.toSOQL());
			}
			soql += ' ORDER BY ' + String.join(sortInfoStrings, ', ');
		}
		if (this.queryLimit != null) {
			soql += ' LIMIT ' + this.queryLimit;
		}
		return soql;
	}

	public List<SObject> execute() {
		this.validate();
		String soql = this.toSOQL();
		return Database.query(soql);
	}

}