public class SortInfo implements QueryElement {
	public Field field { get; set; }
	public String direction { get; set; }
	public String nullOrder { get; set; }

	public SortInfo(Map<String, Object> config, String baseObjectName) {
		this.field = new Field((String) config.get('field'), baseObjectName);
		this.direction = (String) config.get('direction');
		this.nullOrder = (String) config.get('nullOrder');
	}

	public void validate() {
		this.field.validate();
		if (this.direction == null ||
		    (this.direction.toUpperCase() != 'ASC' && this.direction.toUpperCase() != 'DESC') ) {
			throw new InvalidQueryException('Sort direction is not valid : ' + this.direction);
		}
		if (this.nullOrder != null &&
		    this.nullOrder.toUpperCase() != 'LAST' && this.nullOrder.toUpperCase() != 'FIRST') {
			throw new InvalidQueryException('Sort null order is invalid : ' + this.nullOrder);
		}
	}

	public String toSOQL() {
		String str = this.field.toSOQL() + ' ' + this.direction.toUpperCase();
		if (this.nullOrder != null) {
			str += ' NULLS ' + this.nullOrder.toUpperCase();
		}
		return str;
	}
}