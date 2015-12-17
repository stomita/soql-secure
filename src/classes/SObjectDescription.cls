public with sharing class SObjectDescription {

	@AuraEnabled
	public String name { get; set; }
	@AuraEnabled
	public String label { get; set; }
	@AuraEnabled
	public SObjectFieldDescription[] fields { get; set; }

	public SObjectDescription(String name, String label) {
		this.name = name;
		this.label = label;
	}

	public SObjectDescription(String name, String label, SObjectFieldDescription[] fields) {
		this.name = name;
		this.label = label;
		this.fields = fields;
	}

}