<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Case_Status_Received_Response</fullName>
        <field>Status</field>
        <literalValue>Response Received</literalValue>
        <name>Case Status - Received Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates><fieldUpdates>
        <fullName>Case_Status_to_Waiting_on_Customer</fullName>
        <field>Status</field>
        <literalValue>Waiting on customer</literalValue>
        <name>Case Status to Waiting on Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates><fieldUpdates>
        <fullName>Stop_Milestone_Timer</fullName>
        <field>IsStopped</field>
        <literalValue>1</literalValue>
        <name>Stop Milestone Timer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates><rules>
        <fullName>Case Status - Email Received</fullName>
        <actions>
            <name>Case_Status_Received_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Violation,Warning,New</value>
        </criteriaItems>
        <description>Used to change the Case Status for when an inbound email is received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><rules>
        <fullName>Case Status - Waiting on Customer</fullName>
        <actions>
            <name>Case_Status_to_Waiting_on_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Stop_Milestone_Timer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <description>Used to change the Case Status for when an email is sent to the customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules></Workflow>