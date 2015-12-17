public class CompositeCondition implements Condition {
	public static Pattern OPERATOR_PATTERN = Pattern.compile('(?i)^(AND|OR)$');
	public String operator { get; set; }
	public Condition[] conditions { get; set; }
	public Boolean stripParens { get; set; }

	public CompositeCondition(Map<String, Object> config, String baseObjectName, Boolean stripParens) {
		this.operator = (String) config.get('operator');
		Object[] conditions = (Object[]) config.get('conditions');
		if (conditions != null) {
			this.conditions = new Condition[] {};
			for (Object c : conditions) {
				Map<String, Object> cond = (Map<String, Object>) c;
				this.conditions.add(ConditionBuilder.buildCondition(cond, baseObjectName, false));
			}
		}
		this.stripParens = stripParens;
	}

	public void validate() {
		System.debug('Validating Composite Condition: ' + this.operator);
		if (this.operator == null || !OPERATOR_PATTERN.matcher(this.operator).matches()) {
			throw new InvalidQueryException('Invalid logical operator : ' + this.operator);
		}
		if (this.conditions == null || this.conditions.size() == 0) {
			throw new InvalidQueryException('Composite conditions definitions are not found');
		}
		for (Condition condition : this.conditions) {
			condition.validate();
		}
	}

	public String toSOQL() {
		String[] conditionStrings = new String[] {};
		for (Condition cond : this.conditions) {
			conditionStrings.add(cond.toSOQL());
		}
		String condition = String.join(conditionStrings, ' ' + this.operator.toUpperCase() + ' ');
		return conditionStrings.size() > 0 && !this.stripParens ? '(' + condition + ')' : condition;
	}

}