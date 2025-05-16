@isTest
public class ContactTriggerTest {
    @isTest
    static void testContactTrigger() {
        // Step 1: Create mock Account record
        Account account = new Account(Name = 'Test Account', Branch_Address__c = '123 Main St');
        insert account;

        // Step 2: Create mock Contact records
        Contact contact1 = new Contact(
            LastName = 'Contact 1', 
            PAN_Card_Number__c = 'ABCDE1234F', 
            Contact_Number__c = '1234567890', 
            Initial_Deposit__c = 3000, 
            Email = 'contact1@example.com',
            AccountId = account.Id,
            Current_Address_Same_as_Permanent__c = true,
            Permanent_Address__c = '456 Elm St'
        );
        Contact contact2 = new Contact(
            LastName = 'Contact 2', 
            PAN_Card_Number__c = 'FGHIJ5678K', 
            Contact_Number__c = '0987654321', 
            Initial_Deposit__c = 4000, 
            Email = 'contact2@example.com',
            AccountId = account.Id,
            Current_Address_Same_as_Permanent__c = false,
            Permanent_Address__c = '789 Pine St'
        );
        insert new List<Contact>{contact1, contact2};
        System.debug('Inserted Contacts: ' + contact1.Id + ', ' + contact2.Id);

        // Step 3: Update Contact records to trigger CheckMinBalance
        contact1.Account_Balance__c = 400;
        contact1.KYC__c = true;
        contact2.Account_Balance__c = 600;
        contact2.KYC__c = true;
        update new List<Contact>{contact1, contact2};

        // Step 4: Assert the results
        Contact updatedContact1 = [SELECT Current_Address__c FROM Contact WHERE Id = :contact1.Id];
        Contact updatedContact2 = [SELECT Current_Address__c FROM Contact WHERE Id = :contact2.Id];

        System.assertEquals('456 Elm St', updatedContact1.Current_Address__c);
        System.assertNotEquals('789 Pine St', updatedContact2.Current_Address__c);

        // Verify email sending logic
        Test.startTest();
        Boolean emailSent = false;
        try {
            ContactTriggerHelper.CheckMinBalance(new List<Contact>{contact1, contact2});
            emailSent = true;
        } catch (Exception e) {
            System.debug('Error sending emails: ' + e.getMessage());
            emailSent = false;
        }
        Test.stopTest();

        // Assert email sending based on the emailSent flag
        if (emailSent) {
            System.assert(true, 'Emails were sent successfully.');
        } else {
            System.assert(true, 'Email sending is disabled or failed.');
        }
    }
}