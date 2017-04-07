<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>Milestone_1st_Response_SUCCESSFUL</fullName>
        <description>Milestone - First Response - SUCCESSFUL</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Entitlement_Milestone_Templates/Milestone_1st_Response_Success</template>
    </alerts><alerts>
        <fullName>Milestone_1st_Response_VIOLATION</fullName>
        <description>Milestone - First Response - VIOLATION</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Entitlement_Milestone_Templates/Milestone_1st_Response_Violation</template>
    </alerts><alerts>
        <fullName>Milestone_1st_Response_Warning</fullName>
        <description>Milestone - First Response - WARNING</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Entitlement_Milestone_Templates/Milestone_1st_Response_Warning</template>
    </alerts><alerts>
        <fullName>Trigger_Laptop_Email</fullName>
        <description>Troubleshoot Audio Flow Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ServiceTemplates/Troubleshoot_Audio_Flow_Confirmation</template>
    </alerts><fieldUpdates>
        <fullName>Assign_to_Tier_1_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier1Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Tier 1 Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>BillingQueueUpdate</fullName>
        <description>This updates the owner of an inbound call to the billing queue, based on the case routing type equal to billing.</description>
        <field>OwnerId</field>
        <lookupValue>Tier1Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Billing Queue Update</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Case_Status_to_Attention</fullName>
        <field>Status</field>
        <literalValue>Attention</literalValue>
        <name>Case Status to "Attention"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Case_Status_to_Warning</fullName>
        <field>Status</field>
        <literalValue>Warning</literalValue>
        <name>Case Status to "Warning"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Check_First_Contact_Close_box</fullName>
        <description>Check the "First Contact Close" box on the case.</description>
        <field>First_Contact_Close__c</field>
        <literalValue>1</literalValue>
        <name>Check First Contact Close box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Complex</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SimpleIssue</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Complex</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Mark_Case_as_Non_Compliant</fullName>
        <field>SLA_Compliant__c</field>
        <literalValue>0</literalValue>
        <name>Mark Case as Non-Compliant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>NewFeature</fullName>
        <field>RecordTypeId</field>
        <lookupValue>TechnicalIssueAdvanced</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>New Feature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>NewFeatureQueueUpdate</fullName>
        <description>This updates the owner of an inbound call to the product management queue when the new feature request case routing type is selected</description>
        <field>OwnerId</field>
        <lookupValue>Tier2Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>New Feature Queue Update</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Resume_SLA_Clock_on_Case</fullName>
        <field>IsStopped</field>
        <literalValue>0</literalValue>
        <name>Resume SLA Clock on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Case_Escalated_to_True</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>Set Case Escalated to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Case_Origin</fullName>
        <field>Origin</field>
        <literalValue>Community</literalValue>
        <name>Set Case Origin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier1Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Case_Owner_to_Tier_2_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier2Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Case Owner to Tier 2 Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Case_Status_to_Escalated</fullName>
        <field>Status</field>
        <literalValue>Escalated</literalValue>
        <name>Set Case Status to Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Case_Status_to_Researching</fullName>
        <field>Status</field>
        <literalValue>Researching</literalValue>
        <name>Set Case Status to Researching</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Case_Status_to_Waiting_on_Customer</fullName>
        <field>Status</field>
        <literalValue>Waiting on customer</literalValue>
        <name>Set Case Status to Waiting on Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Escalated_Flag</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>Set Escalated Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Origin_to_Community</fullName>
        <field>Origin</field>
        <literalValue>Community</literalValue>
        <name>Set Origin to Community</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier1Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Owner1</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier1Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner to Tier 1 Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Stop_SLA_Clock_on_Case</fullName>
        <field>IsStopped</field>
        <literalValue>1</literalValue>
        <name>Stop SLA Clock on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>TechnicalQueueUpdate</fullName>
        <description>This updates the owner of an inbound call to the technical queue when the technical case routing type is selected.</description>
        <field>OwnerId</field>
        <lookupValue>Tier3Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Technical Queue Update</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>TechnicalRecordTypeUpdate</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SimpleIssue</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Technical Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Tier_2</fullName>
        <field>OwnerId</field>
        <lookupValue>Tier2Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Tier 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Case_Owner_to_Social_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Social_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner to Social Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Assign Social Case to Social Queue</fullName>
        <actions>
            <name>Update_Case_Owner_to_Social_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Facebook,Twitter</value>
        </criteriaItems>
        <description>Assign Case with Source "Facebook" or "Twitter" to the Social Queue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules><rules>
        <fullName>Categorise Community Case</fullName>
        <actions>
            <name>Assign_to_Tier_1_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Community</value>
        </criteriaItems>
        <description>Changes Case Origin of Case created in Community to "Community" .</description>
        <triggerType>onCreateOnly</triggerType>
    </rules><rules>
        <fullName>Escalate Case</fullName>
        <actions>
            <name>Set_Escalated_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Tier_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <description>Assign case to "Tier 2 Queue" when Escalated field is checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><rules>
        <fullName>Mark Case closed on First Contact</fullName>
        <actions>
            <name>Check_First_Contact_Close_box</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Mark the "First Contact Close" field when the case moves directly from "New" to "Closed" status.</description>
        <formula>AND( 
NOT(ISNEW()), 
ISCHANGED(Status), 
ISPICKVAL(PRIORVALUE(Status),"New"), 
ISPICKVAL(Status, "Closed") 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules><rules>
        <fullName>Troubleshoot Audio Flow Confirmation Email</fullName>
        <actions>
            <name>Trigger_Laptop_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Send_Email_Trigger__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send a confirmation to the contact after the "Troubleshoot Audio" flow is complete.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><tasks>
        <fullName>EngineeringReview</fullName>
        <assignedTo>rnarayan@surgicalsolutions.demo</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Engineering Review</subject>
    </tasks><tasks>
        <fullName>FeatureRequestSubmitted</fullName>
        <assignedTo>rnarayan@surgicalsolutions.demo</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Feature Request Submitted</subject>
    </tasks><tasks>
        <fullName>Milestone_1st_Response_Successful</fullName>
        <assignedToType>owner</assignedToType>
        <description>The 1st Response milestone for this case was SUCCESSFUL</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Milestone - 1st Response - SUCCESSFUL</subject>
    </tasks><tasks>
        <fullName>Milestone_1st_Response_VIOLATION</fullName>
        <assignedToType>owner</assignedToType>
        <description>Milestone - 1st Response - VIOLATED</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Milestone - 1st Response - VIOLATION</subject>
    </tasks><tasks>
        <fullName>Sendnewstatement</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send new statement</subject>
    </tasks><tasks>
        <fullName>Yourcustomerhadabillingquestion</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Your customer had a billing question</subject>
    </tasks><tasks>
        <fullName>YourcustomerhasopenedaCase</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Your customer has opened a Case</subject>
    </tasks></Workflow>