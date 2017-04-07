<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>BigDealAlert</fullName>
        <description>Big Deal Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>rnarayan@surgicalsolutions.demo</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SalesTemplates/BigDealAlert</template>
    </alerts><alerts>
        <fullName>DealRegistrationConverted</fullName>
        <description>Deal Registration Converted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DealRegistrations/DealRegistrationApproved</template>
    </alerts><alerts>
        <fullName>DiscountApprovedemailnotification</fullName>
        <description>Discount Approved email notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Processes/DiscountApproved</template>
    </alerts><alerts>
        <fullName>DiscountRejected</fullName>
        <description>Discount Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Processes/DiscountRejected</template>
    </alerts><alerts>
        <fullName>DiscountRejectedemailnotification</fullName>
        <description>Discount Rejected email notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Processes/DiscountRejected</template>
    </alerts><alerts>
        <fullName>NotifyDealRegOpptAccountOwnerthatdealisClosedWon</fullName>
        <description>Notify Deal Reg Oppt Account Owner that deal is Closed Won</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DealRegistrations/DealRegistrationClosedWon</template>
    </alerts><fieldUpdates>
        <fullName>DiscountApproved</fullName>
        <field>Discount_Approved__c</field>
        <literalValue>Yes</literalValue>
        <name>Discount Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Increment_Push_Counter_Field</fullName>
        <description>Increment the Push Counter by 1</description>
        <field>Push_Counter__c</field>
        <formula>IF( 
ISNULL( Push_Counter__c ), 
1, 
Push_Counter__c + 1 
)</formula>
        <name>Increment Push Counter Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>Account.Name &amp; " - " &amp; TEXT(Type) &amp; " - " &amp; TEXT(ROUND((Amount/1000), 0)) &amp; "K"</formula>
        <name>Update Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Big Deal Alert</fullName>
        <actions>
            <name>BigDealAlert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterThan</operation>
            <value>100000</value>
        </criteriaItems>
        <description>Sends an email notification when a deal closes with an amount greater than $100,000.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><rules>
        <fullName>Opportunity Workflow - Send Task to Owner on Stage Change</fullName>
        <actions>
            <name>SendProposalandPricing</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Proposal/Price Quote</value>
        </criteriaItems>
        <description>Workflow demonstrates how a task can be assigned to a Sales Rep or other User when the Opportunity stage changes. Change this to match the prospect's sales stage and task name you mention in your flow.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Increment_Push_Counter_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Mark opportunities each time their Close Date changes.</description>
        <formula>IF(  CloseDate &gt; PRIORVALUE( CloseDate ),  IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) ,  TRUE,  FALSE),  FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules><tasks>
        <fullName>SendProposalandPricing</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Proposal and Pricing</subject>
    </tasks></Workflow>