<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>SendApprovedemailtorequestor</fullName>
        <description>Send Approved email to requestor</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TimeOffManager/TimeOffRequestapproved</template>
    </alerts><alerts>
        <fullName>SendRejectedemailtorequestor</fullName>
        <description>Send Rejected email to requestor</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TimeOffManager/TimeOffRequestrejected</template>
    </alerts><fieldUpdates>
        <fullName>SetDateApproved</fullName>
        <field>Date_Approved__c</field>
        <formula>NOW()</formula>
        <name>Set Date Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>SetDateSubmitted</fullName>
        <field>Date_Submitted__c</field>
        <formula>NOW()</formula>
        <name>Set Date Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>SetStatustoApproved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>SetStatustoNotSubmitted</fullName>
        <field>Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Set Status to Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>SetStatustoPending</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Set Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>SetStatustoRejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates></Workflow>