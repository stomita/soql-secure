public with sharing class Metadata {

	/**
	 *
	 */
	public static SObjectDescription[] describeGlobal() {
		Map<String, SObjectType> gd = Schema.getGlobalDescribe();
		SObjectDescription[] soList = new SObjectDescription[]{ };
		for (SObjectType soType : gd.values()) {
			DescribeSObjectResult d = soType.getDescribe();
			if (d.isAccessible()) {
				soList.add(new SObjectDescription(d.getName(), d.getLabel()));
			}
		}
		return soList;
	}

	/**
	 *
	 */
	public static SObjectDescription describeSObject(String sobjectName) {
		SObject so = (SObject) Type.forName(sobjectName).newInstance();
		DescribeSObjectResult d = so.getSObjectType().getDescribe();
		if (d.isAccessible()) {
			SObjectFieldDescription[] fields = new SObjectFieldDescription[]{ };
			for (SObjectField f: d.fields.getMap().values()) {
				DescribeFieldResult fd = f.getDescribe();
				if (fd.isAccessible()) {
					fields.add(convertToSObjectField(fd));
				}
			}
			return new SObjectDescription(d.getName(), d.getLabel(), fields);
		} else {
			return null;
		}
	}


	private static SObjectFieldDescription convertToSObjectField(DescribeFieldResult fd) {
		SObjectFieldDescription field = new SObjectFieldDescription(fd.getName(), fd.getLabel());
		field.autoNumber = fd.isAutoNumber();
		field.calculated = fd.isCalculated();
	  field.byteLength = fd.getByteLength();
	  field.calculated = fd.isCalculated();
	  field.calculatedFormula = fd.getCalculatedFormula();
		field.cascadeDelete = fd.isCascadeDelete();
		field.caseSensitive = fd.isCaseSensitive();
		// field.controllerName = fd.getControllerName();
		field.createable = fd.isCreateable();
		field.custom = fd.isCustom();
		field.defaultValue = fd.getDefaultValue();
		field.defaultValueFormula = fd.getDefaultValueFormula();
		field.defaultedOnCreate = fd.isDefaultedOnCreate();
		field.dependentPicklist = fd.isDependentPicklist();
		field.deprecatedAndHidden = fd.isDeprecatedAndHidden();
		field.digits = fd.getDigits();
		field.displayLocationInDecimal = fd.isDisplayLocationInDecimal();
		field.externalId = fd.isExternalId();
		//public String extraTypeInfo { get; set; }

	  field.filterable = fd.isFilterable();
	  //public List<Object> filteredLookupInfo { get; set; }
	  field.groupable = fd.isGroupable();
		// field.highScaleNumber = fd.isHighScaleNumber();
		field.htmlFormatted = fd.isHtmlFormatted();
		field.idLookup = fd.isIdLookup();
		field.inlineHelpText = fd.getInlineHelpText();
	  field.length = fd.getLength();
		field.mask = fd.getMask();
		field.maskType = fd.getMaskType();
	  field.nameField = fd.isNameField();
		field.namePointing = fd.isNamePointing();
	  field.nillable = fd.isNillable();
		field.permissionable = fd.isPermissionable();
		field.picklistValues = fd.getPicklistValues();
		field.precision = fd.getPrecision();
		field.queryByDistance = fd.isQueryByDistance();
		field.referenceTargetField = fd.getReferenceTargetField();
	  field.referenceTo = convertReferenceToObjectNames(fd.getReferenceTo());
		field.relationshipName = fd.getRelationshipName();
	  field.relationshipOrder = fd.getRelationshipOrder();
		field.restrictedDelete = fd.isRestrictedDelete();
		field.restrictedPicklist = fd.isRestrictedPicklist();
		field.scale = fd.getScale();
	  // field.soapType = fd.getSoapType();
		field.sortable = fd.isSortable();
		field.type = displayTypeMap.get(fd.getType());
		field.unique = fd.isUnique();
		field.updateable = fd.isUpdateable();
		field.writeRequiresMasterRead = fd.isWriteRequiresMasterRead();

		return field;
	}

	private static Map<Schema.DisplayType, String> displayTypeMap = new Map<Schema.DisplayType, String> {
		Schema.DisplayType.STRING => 'string',
		Schema.DisplayType.BOOLEAN => 'boolean',
		Schema.DisplayType.DOUBLE => 'double',
		Schema.DisplayType.INTEGER => 'integer',
		Schema.DisplayType.PERCENT => 'percent',
		Schema.DisplayType.CURRENCY => 'currency',
		Schema.DisplayType.DATE => 'date',
		Schema.DisplayType.DATETIME => 'datetime',
		Schema.DisplayType.TIME => 'time',
		Schema.DisplayType.PICKLIST => 'picklist',
		Schema.DisplayType.MULTIPICKLIST => 'multipicklist',
		Schema.DisplayType.DATACATEGORYGROUPREFERENCE => 'datacategorygroupreference',
		Schema.DisplayType.BASE64 => 'base64',
		Schema.DisplayType.ID => 'id',
		Schema.DisplayType.REFERENCE => 'reference',
		Schema.DisplayType.TEXTAREA => 'textarea',
		Schema.DisplayType.PHONE => 'phone',
		Schema.DisplayType.COMBOBOX => 'combobox',
		Schema.DisplayType.URL => 'url',
		Schema.DisplayType.EMAIL => 'email',
		Schema.DisplayType.ANYTYPE => 'anytype',
		Schema.DisplayType.LOCATION => 'location',
		Schema.DisplayType.ENCRYPTEDSTRING => 'encryptedstring',
		Schema.DisplayType.COMPLEXVALUE => 'complexvalue',
		Schema.DisplayType.ADDRESS => 'address',
		Schema.DisplayType.SOBJECT => 'sobject'
	};

	private static String[] convertReferenceToObjectNames(SObjectType[] referenceTo) {
		if (referenceTo == null) {
			return null;
		}
		String[] soNames = new String[]{ };
		for (SObjectType soType : referenceTo) {
			DescribeSObjectResult d = soType.getDescribe();
			if (d.isAccessible()) {
				soNames.add(d.getName());
			}
		}
		return soNames;
	}

}
