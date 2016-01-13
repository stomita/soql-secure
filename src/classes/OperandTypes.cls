public with sharing class OperandTypes {

	public static Operand createOperand(Object v) {
		if (v == null) {
			return new OperandTypes.NullOperand();
		} else if (v instanceOf String) {
			return new OperandTypes.StringOperand((String) v);
		} else if (v instanceOf Decimal) {
			return new OperandTypes.DecimalOperand((Decimal) v);
		} else if (v instanceOf Boolean) {
			return new OperandTypes.BooleanOperand((Boolean) v);
		} else if (v instanceOf Object[]) {
			return new OperandTypes.ArrayOperand((Object[]) v);
		} else if (v instanceOf Map<String, Object>) {
			Map<String, Object> m = (Map<String, Object>) v;
			String type = ((String) m.get('type'));
			if (type == 'date' || type == 'datetime') {
				return new OperandTypes.DateOperand((String) m.get('value'));
			} else if (m.get('table') instanceOf String) {
//				this.value = new OperandTypes.SubQueryOperand(m);
			}
		}
		return null;
	}

	public class NullOperand implements Operand {
		public void validate() {}
		public String toSOQL() {
			return 'null';
		}
	}

	public class StringOperand implements Operand {
		public String value { get; set; }
		public StringOperand(String value) {
			this.value = value;
		}
		public void validate() {}
		public String toSOQL() {
			return '\'' + String.escapeSingleQuotes(this.value) + '\'';
		}
	}

	public class DecimalOperand implements Operand {
		public Decimal value { get; set; }
		public DecimalOperand(Decimal value) {
			this.value = value;
		}
		public void validate() {}
		public String toSOQL() {
			return String.valueOf(this.value);
		}
	}

	public class BooleanOperand implements Operand {
		public Boolean value { get; set; }
		public BooleanOperand(Boolean value) {
			this.value = value;
		}
		public void validate() {}
		public String toSOQL() {
			return String.valueOf(this.value);
		}
	}

	public class ArrayOperand implements Operand {
		public Operand[] values { get; set; }
		public ArrayOperand(Object[] values) {
			this.values = new Operand[] {};
			for (Object value : values) {
				this.values.add(OperandTypes.createOperand(value));
			}
		}
		public void validate() {}
		public String toSOQL() {
			String[] valueStrings = new String[] {};
			for (Operand value : this.values) {
				valueStrings.add(value.toSOQL());
			}
			return '('+String.join(valueStrings, ', ')+')';
		}
	}

	public static Pattern DATE_OPERAND_REGEXP =
		Pattern.compile('^(\\d{4}-\\d{2}-\\d{2}(T\\d{2}:?\\d{2}:?\\d{2}(\\.\\d+)?([\\+\\-]\\d{2}:?\\d{2}|Z))?|' +
		                'YESTERDAY|TODAY|TOMORROW|(NEXT|THIS|LAST)_(WEEK|MONTH|(FISCAL_)?(QUARTER|YEAR))|' +
										'(NEXT|LAST)_90_DAYS|' +
										'(NEXT|LAST)_N_(DAYS|WEEKS|MONTHS|(FISCAL_)?(QUARTERS|YEARS)):\\d+)$');

	public class DateOperand implements Operand {
		public String value { get; set; }
		public DateOperand(String value) {
			this.value = value;
		}
		public void validate() {
			if (!DATE_OPERAND_REGEXP.matcher(this.value).matches()) {
				throw new InvalidQueryException('Operand date value is invalid : ' + this.value);
			}
		}
		public String toSOQL() {
			return value;
		}
	}

	/*
	public class QueryOperand implements Operand {
		public Query query { get; set; }
		public QueryOperand(Map<String, Object> value) {
			this.query = new Query(value);
		}
		public String toSOQL() {
			return query.toSOQL();
		}
	}
	*/

}