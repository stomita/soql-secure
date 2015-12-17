public class Field implements QueryElement {
	public String[] path { get; set; }
	public String baseObjectName { get; set; }

	public Field(String path, String baseObjectName) {
		this.path = path.split('\\.');
		this.baseObjectName = baseObjectName;
	}

	public void validate() {
		System.debug('Validating field: ' + this.path);
		String sobjName = this.baseObjectName;
		Integer len = this.path.size();
		for (Integer i = 0; i < len; i++) {
			String refName = this.path[i];
			System.debug('Check if sobject ' + sobjName + '.' + refName + ' is accessible field');
			if (i == len - 1) {
				if (!MetadataValidator.isFieldAccessible(refName, sobjName)) {
					throw new InvalidQueryException('Field is not available or not accessible: ' + sobjName + '.' + refName);
				}
			} else {
				String[] parents = MetadataValidator.getParentRelationshipObjects(refName, sobjName);
				for (String parent: parents) {
					System.debug('parent = ' + parent);
				}
				if (parents == null) {
					throw new InvalidQueryException('Parent relationship is not available or not accessible: ' + sobjName + '.' + refName);
				} else {
					sobjName = parents.size() == 1 ? parents[0] : 'Name';
				}
			}
		}
	}

	public String toSOQL() {
		return String.join(this.path, '.');
	}
}