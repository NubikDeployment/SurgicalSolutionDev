<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Account_Record_Type_To_Data_com</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Data_com</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Account Record Type To Data.com</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Assign to Data%2Ecom Record Type</fullName>
        <actions>
            <name>Account_Record_Type_To_Data_com</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.AccountSource</field>
            <operation>equals</operation>
            <value>Data.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Account_Source_Custom__c</field>
            <operation>contains</operation>
            <value>Data.com</value>
        </criteriaItems>
        <description>Used to change the record type to Data.com for Accounts imported from Data.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules></Workflow>