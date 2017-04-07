<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Set_Status_to_Rejected</fullName>
        <description>Sets the status of the Quote to "Rejected".</description>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Set Status to "Rejected"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_status_to_Approved</fullName>
        <description>Sets the status of the Quote to "Approved".</description>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Set status to "Approved"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Status_to_Submitted</fullName>
        <description>When the Quote is submitted for approval, update the status of the Quote to "Submitted"</description>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Update Status to "Submitted"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates></Workflow>