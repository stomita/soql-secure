public class OperandTypes {

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
			return '\'' + String.escapeSingleQuotes(value) + '\'';
		}
	}

	public class DecimalOperand implements Operand {
		public Decimal value { get; set; }
		public DecimalOperand(Decimal value) {
			this.value = value;
		}
		public void validate() {}
		public String toSOQL() {
			return String.valueOf(value);
		}
	}

	public static Pattern DATE_OPERAND_REGEXP =
		Pattern.compile('^([0-9]{4}-[0-9]{2}-[0-9]{2}|TODAY|TOMORROW|YESTERDAY|(NEXT|THIS|LAST)_(WEEK|MONTH|(FISCAL_)?QUARTER|(FISCAL_)?YEAR))');

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
