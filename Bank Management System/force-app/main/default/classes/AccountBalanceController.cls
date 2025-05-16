public with sharing class AccountBalanceController {
    @AuraEnabled(cacheable=false)
    public static Decimal getAccountBalance() {
        // Query the User object to retrieve the contactId field
        List<User> users = [SELECT contactId FROM User WHERE Id = :UserInfo.getUserId()];
        
        // Extract the contactId values into a List<Id>
        List<Id> conIds = new List<Id>();
        for (User user : users) {
            conIds.add(user.contactId);
        }
        
        // Use the List<Id> to query the Contact object
        List<Contact> conts = [SELECT Account_Balance__c FROM Contact WHERE Id IN :conIds];
        
        // Return the Account_Balance__c value
        return (conts.isEmpty()) ? 0 : conts[0].Account_Balance__c;
    }
}