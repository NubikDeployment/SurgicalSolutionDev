<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>AutomatedRenewalNotice</fullName>
        <description>Automated Renewal Notice</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SalesTemplates/Renewal_Notice</template>
    </alerts><fieldUpdates>
        <fullName>UpdateStatusofAsset30DayWarning</fullName>
        <field>Entitlement_Status__c</field>
        <literalValue>30 Day Warning</literalValue>
        <name>Update Status of Asset "30 Day Warning"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><tasks>
        <fullName>RenewalNotice</fullName>
        <assignedTo>rnarayan@surgicalsolutions.demo</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please Follow up with customer to make sure we get the renewal business.</description>
        <dueDateOffset>-15</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Asset.UsageEndDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Renewal Notice</subject>
    </tasks></Workflow>