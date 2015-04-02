public class CompositeCondition implements Condition {
	public static Pattern CONDITION_MODE_REGEXP = Pattern.compile('(?i)^(AND|OR|NOT)$');
	public String mode { get; set; }
	public Condition[] conditions { get; set; }
	public Boolean isRoot { get; set; }

	public CompositeCondition() { }

	public CompositeCondition(Map<String, Object> config, String baseObjectName, Boolean isRoot) {
		this.mode = (String) config.get('mode');
		Object[] conditions = (Object[]) config.get('conditions');
		if (conditions != null) {
			this.conditions = new Condition[] {};
			for (Object c : conditions) {
				Map<String, Object> cond = (Map<String, Object>) c;
				if (cond.get('mode') != null) {
					this.conditions.add(new CompositeCondition(cond, baseObjectname));
				} else {
				  this.conditions.add(new SingleCondition(cond, baseObjectName));
				}
			}
		}
		this.isRoot = isRoot;
	}

	public CompositeCondition(Map<String, Object> config, String baseObjectName) {
		this(config, baseObjectName, false);
	}

	public void validate() {
		if (this.mode == null || !CONDITION_MODE_REGEXP.matcher(this.mode).matches()) {
			throw new InvalidQueryException('Condition mode is invalid : ' + this.mode);
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
		String condition = String.join(conditionStrings, ' ' + this.mode + ' ');
		return conditionStrings.size() > 0 && !this.isRoot ? '(' + condition + ')' : condition;
	}

}
