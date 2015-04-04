public class NegateCondition implements Condition {
	public String operator { get; set; }
	public Condition condition { get; set; }
	public Boolean stripParens { get; set; }

	public NegateCondition(Map<String, Object> config, String baseObjectName, Boolean stripParens) {
		this.operator = (String) config.get('operator');
		Map<String, Object> condition = (Map<String, Object>) config.get('condition');
		if (condition != null) {
			this.condition = ConditionBuilder.buildCondition(condition, baseObjectName, true);
		}
		this.stripParens = stripParens;
	}

	public void validate() {
		if (this.condition == null) {
			throw new InvalidQueryException('Negating condition is not defined');
		}
		this.condition.validate();
	}

	public String toSOQL() {
		String condition = 'NOT ' + this.condition.toSOQL();
		return !this.stripParens ? '(' + condition + ')' : condition;
	}
}
