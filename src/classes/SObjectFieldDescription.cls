public with sharing class SObjectFieldDescription {

	@AuraEnabled
	public Boolean autoNumber { get; set; }
	@AuraEnabled
  public Integer byteLength { get; set; }
	@AuraEnabled
  public Boolean calculated { get; set; }
	@AuraEnabled
  public String calculatedFormula { get; set; }
	@AuraEnabled
  public Boolean cascadeDelete { get; set; }
	@AuraEnabled
  public Boolean caseSensitive { get; set; }
	@AuraEnabled
  public String controllerName { get; set; }
	@AuraEnabled
  public Boolean createable { get; set; }
	@AuraEnabled
  public Boolean custom { get; set; }
	@AuraEnabled
  public Object defaultValue { get; set; }
	@AuraEnabled
  public String defaultValueFormula { get; set; }
	@AuraEnabled
  public Boolean defaultedOnCreate { get; set; }
	@AuraEnabled
  public Boolean dependentPicklist { get; set; }
	@AuraEnabled
  public Boolean deprecatedAndHidden { get; set; }
	@AuraEnabled
  public Integer digits { get; set; }
	@AuraEnabled
  public Boolean displayLocationInDecimal { get; set; }
	@AuraEnabled
  public Boolean externalId { get; set; }
	@AuraEnabled
  public String extraTypeInfo { get; set; }
	@AuraEnabled
  public Boolean filterable { get; set; }
	@AuraEnabled
  public List<Object> filteredLookupInfo { get; set; }
	@AuraEnabled
  public Boolean groupable { get; set; }
	@AuraEnabled
  public Boolean highScaleNumber { get; set; }
	@AuraEnabled
  public Boolean htmlFormatted { get; set; }
	@AuraEnabled
  public Boolean idLookup { get; set; }
	@AuraEnabled
  public String inlineHelpText { get; set; }
	@AuraEnabled
  public String label { get; set; }
	@AuraEnabled
  public Integer length { get; set; }
	@AuraEnabled
  public String mask { get; set; }
	@AuraEnabled
  public String maskType { get; set; }
	@AuraEnabled
  public String name { get; set; }
	@AuraEnabled
  public Boolean nameField { get; set; }
	@AuraEnabled
  public Boolean namePointing { get; set; }
	@AuraEnabled
  public Boolean nillable { get; set; }
	@AuraEnabled
  public Boolean permissionable { get; set; }
	@AuraEnabled
  public List<Object> picklistValues { get; set; }
	@AuraEnabled
  public Integer precision { get; set; }
	@AuraEnabled
  public Boolean queryByDistance { get; set; }
	@AuraEnabled
  public String referenceTargetField { get; set; }
	@AuraEnabled
  public List<String> referenceTo { get; set; }
	@AuraEnabled
  public String relationshipName { get; set; }
	@AuraEnabled
  public Integer relationshipOrder { get; set; }
	@AuraEnabled
  public Boolean restrictedDelete { get; set; }
	@AuraEnabled
  public Boolean restrictedPicklist { get; set; }
	@AuraEnabled
  public Integer scale { get; set; }
	@AuraEnabled
  public String soapType { get; set; }
	@AuraEnabled
  public Boolean sortable { get; set; }
	@AuraEnabled
  public String type { get; set; }
	@AuraEnabled
  public Boolean unique { get; set; }
	@AuraEnabled
  public Boolean updateable { get; set; }
	@AuraEnabled
  public Boolean writeRequiresMasterRead { get; set; }

	public SObjectFieldDescription(String name, String label) {
		this.name = name;
		this.label = label;
	}

}
