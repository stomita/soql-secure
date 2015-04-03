public class SingleCondition implements Condition {
	public static Pattern OPERATOR_PATTERN_REGEXP = Pattern.compile('(?i)^(=|!=|>|>=|<|<=|LIKE|IN|NOT IN)$');
	public Field field { get; set; }
	public String operator { get; set; }
	public Operand value { get; set; }

	public SingleCondition() {}

	public SingleCondition(Map<String, Object> config, String baseObjectName) {
		this.field = new Field((String) config.get('field'), baseObjectName);
		this.operator = (String) config.get('operator');
		this.value = createOperand(config.get('value'));
	}

	Operand createOperand(Object v) {
		if (v == null) {
			return new OperandTypes.NullOperand();
		} else if (v instanceOf String) {
			return new OperandTypes.StringOperand((String) v);
		} else if (v instanceOf Decimal) {
			return new OperandTypes.DecimalOperand((Decimal) v);
		} else if (v instanceOf Map<String, Object>) {
			Map<String, Object> m = (Map<String, Object>) v;
			String type = ((String) m.get('type'));
			if (type == 'date') {
				return new OperandTypes.DateOperand((String) m.get('value'));
			} else if (m.get('table') instanceOf String) {
//				this.value = new OperandTypes.SubQueryOperand(m);
			}
		}
		return null;
	}

	public void validate() {
		this.field.validate();
		if (this.operator == null || !OPERATOR_PATTERN_REGEXP.matcher(this.operator).matches()) {
			throw new InvalidQueryException('Condition operator is not valid : ' + this.operator);
		}
		if (this.value == null) {
			throw new InvalidQueryException('Condition operand value is not available');
		} else {
			this.value.validate();
		}
	}

	public String toSOQL() {
		return field.toSOQL() + ' ' + operator + ' ' + value.toSOQL();
	}

}