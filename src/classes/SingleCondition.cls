public class SingleCondition implements Condition {
	public static Pattern OPERATOR_PATTERN = Pattern.compile('(?i)^(=|!=|>|>=|<|<=|LIKE|IN|NOT IN)$');
	public String operator { get; set; }
	public Field field { get; set; }
	public Operand value { get; set; }

	public SingleCondition(Map<String, Object> config, String baseObjectName) {
		this.operator = (String) config.get('operator');
		this.field = new Field((String) config.get('field'), baseObjectName);
		this.value = OperandTypes.createOperand(config.get('value'));
	}

	public void validate() {
		this.field.validate();
		if (this.operator == null || !OPERATOR_PATTERN.matcher(this.operator).matches()) {
			throw new InvalidQueryException('Invalid condition operator : ' + this.operator);
		}
		if (this.value == null) {
			throw new InvalidQueryException('Condition operand is not available');
		} else {
			this.value.validate();
		}
	}

	public String toSOQL() {
		return field.toSOQL() + ' ' + operator + ' ' + value.toSOQL();
	}

}
