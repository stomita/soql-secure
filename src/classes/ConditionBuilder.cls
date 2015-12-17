public class ConditionBuilder {
  public static Condition buildCondition(Map<String, Object> config, String baseObjectName, Boolean stripParens) {
    if (config.get('field') != null) {
			return new SingleCondition(config, baseObjectName);
		} else {
			String operator = (String) config.get('operator');
			if (operator != null && operator.toUpperCase() == 'NOT') {
				return new NegateCondition(config, baseObjectName, stripParens);
			} else {
				return new CompositeCondition(config, baseObjectName, stripParens);
			}
		}
		return null;
	}
}