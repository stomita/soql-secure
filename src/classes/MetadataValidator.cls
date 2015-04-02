public with sharing class MetadataValidator {

	private static Map<String, DescribeSObjectResult> cache = new Map<String, DescribeSObjectResult> {};

	private static DescribeSObjectResult describeSObject(String sobjName) {
		sobjName = sobjName.toLowerCase();
		DescribeSObjectResult res = MetadataValidator.cache.get(sobjName);
		if (res == null) {
			SObject so = (SObject) Type.forName(sobjName).newInstance();
			res = so.getSObjectType().getDescribe();
			MetadataValidator.cache.put(sobjName, res);
		}
		return res;
	}

	public static Boolean isObjectAccessible(String sobjName) {
		try {
			SObjectType soType = ((SObject) Type.forName(sobjName).newInstance()).getSObjectType();
			return soType.getDescribe().isAccessible();
		} catch(Exception e) {
			return false;
		}
		return true;
	}

	public static Boolean isFieldAccessible(String fieldName, String sobjName) {
		if (isObjectAccessible(sobjName)) {
			DescribeSObjectResult sobj = describeSObject(sobjName);
			Map<String, SObjectField> fields = sobj.fields.getMap();
			for (SObjectField f : fields.values()) {
				DescribeFieldResult field = f.getDescribe();
				if (field.getName().toLowerCase() == fieldName.toLowerCase()) {
					return field.isAccessible();
				}
			}
		}
		return false;
	}

	/*
	public static String getChildRelationshipObject(String childRelName, String sobjName) {
		if (isObjectAccessible(sobjName)) {
			DescribeSObjectResult sobj = describeSObject(sobjName);
			ChildRelationship[] childRels = sobj.getChildRelationships();
			for (ChildRelationship childRel : childRels) {
				if (childRel.getRelationshipName().toLowerCase() == childRelName.toLowerCase()) {
					return childRel.getChildSObject().getDescribe().getName();
				}
			}
		}
		return null;
	}
	*/

	public static String[] getParentRelationshipObjects(String parentRelName, String sobjName) {
		if (isObjectAccessible(sobjName)) {
			DescribeSObjectResult sobj = describeSObject(sobjName);
			Map<String, SObjectField> fields = sobj.fields.getMap();
			for (SObjectField f : fields.values()) {
				DescribeFieldResult field = f.getDescribe();
				String relationshipName = field.getRelationshipName();
				if (relationshipName != null &&
				    relationshipName.toLowerCase() == parentRelName.toLowerCase() &&
					  isFieldAccessible(field.getName(), sobjName)) {
					String[] parents = new String[] {};
					for (SObjectType refType : field.getReferenceTo()) {
						parents.add(refType.getDescribe().getName());
					}
					return parents;
				}
			}
		}
		return null;
	}

}
