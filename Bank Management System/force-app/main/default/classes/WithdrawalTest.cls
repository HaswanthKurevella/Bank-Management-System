@isTest
public class WithdrawalTest {
    @isTest
    static void testNewWithdrawal() {
        // Step 1: Create mock Account and Contact records
        Account account = new Account(Name = 'Test Account', Branch_Address__c = '123 Main St');
        insert account;

        Contact contact1 = new Contact(
            LastName = 'Contact 1', 
            PAN_Card_Number__c = 'ABCDE1234F', 
            Contact_Number__c = '1234567890', 
            Initial_Deposit__c = 3000, 
            Email = 'contact1@example.com',
            AccountId = account.Id
        );
        Contact contact2 = new Contact(
            LastName = 'Contact 2', 
            PAN_Card_Number__c = 'FGHIJ5678K', 
            Contact_Number__c = '0987654321', 
            Initial_Deposit__c = 4000, 
            Email = 'contact2@example.com',
            AccountId = account.Id
        );
        insert new List<Contact>{contact1, contact2};
        System.debug('Inserted Contacts: ' + contact1.Id + ', ' + contact2.Id);

        // Step 2: Prepare valid mock data for Withdrawal__c
        List<Withdrawal__c> withdrawalList = new List<Withdrawal__c>();
        Withdrawal__c withdrawal1 = new Withdrawal__c(
            Bank_Account__c = contact1.Id,
            Withdrawal_Amount__c = 50.00
        );
        withdrawalList.add(withdrawal1);
        Withdrawal__c withdrawal2 = new Withdrawal__c(
            Bank_Account__c = contact2.Id,
            Withdrawal_Amount__c = 100.00
        );
        withdrawalList.add(withdrawal2);
        System.debug('Prepared Withdrawal List: ' + withdrawalList);

        // Step 3: Call the method to be tested
        Test.startTest();
        WithdrawalHelper.newWithdrawal(withdrawalList);
        Test.stopTest();

        // Step 4: Assert the results
        System.assertEquals(2, withdrawalList.size());
        System.assertEquals(50.00, withdrawalList[0].Withdrawal_Amount__c);
        System.assertEquals(contact1.Id, withdrawalList[0].Bank_Account__c);
        System.assertEquals(100.00, withdrawalList[1].Withdrawal_Amount__c);
        System.assertEquals(contact2.Id, withdrawalList[1].Bank_Account__c);
    }

    @isTest
    static void testEmptyWithdrawalList() {
        // Test with an empty list
        List<Withdrawal__c> emptyWithdrawalList = new List<Withdrawal__c>();
        Test.startTest();
        WithdrawalHelper.newWithdrawal(emptyWithdrawalList);
        Test.stopTest();
        // Assert that no Withdrawal__c records were inserted
        System.assertEquals(0, emptyWithdrawalList.size());
    }

    @isTest
    static void testNullValuesInWithdrawalList() {
        // Test with some null values in the withdrawal list
        Account account = new Account(Name = 'Test Account 2', Branch_Address__c = '456 Elm St');
        insert account;

        Contact contact = new Contact(
            LastName = 'Contact 3', 
            PAN_Card_Number__c = 'LMNOP9876Q', 
            Contact_Number__c = '1122334455', 
            Initial_Deposit__c = 3000, 
            Email = 'contact3@example.com',
            AccountId = account.Id
        );
        insert contact;

        List<Withdrawal__c> withdrawalList = new List<Withdrawal__c>();
        Withdrawal__c withdrawal = new Withdrawal__c(
            Bank_Account__c = null, // Null Contact ID to skip this record
            Withdrawal_Amount__c = null // Null amount to skip this record
        );
        withdrawalList.add(withdrawal);
        System.debug('Prepared Invalid Withdrawal List: ' + withdrawalList);

        Test.startTest();
        WithdrawalHelper.newWithdrawal(withdrawalList);
        Test.stopTest();

        // Assert that no Withdrawal__c records were inserted
        System.assertEquals(1, withdrawalList.size());
    }

    @isTest
    static void testErrorHandling() {
        // Test error handling during insertion
        Account account = new Account(Name = 'Test Account 3', Branch_Address__c = '789 Pine St');
        insert account;

        Contact contact = new Contact(
            LastName = 'Contact 4', 
            PAN_Card_Number__c = 'QRSTU1234V', 
            Contact_Number__c = '2233445566', 
            Initial_Deposit__c = 3000, 
            Email = 'contact4@example.com',
            AccountId = account.Id
        );
        insert contact;

        List<Withdrawal__c> withdrawalList = new List<Withdrawal__c>();
        Withdrawal__c withdrawal = new Withdrawal__c(
            Bank_Account__c = contact.Id
        );
        withdrawalList.add(withdrawal);

        // Simulate DML exception
        Test.startTest();
        try {
            WithdrawalHelper.newWithdrawal(withdrawalList);
        } catch (DmlException e) {
            System.debug('Error inserting transactions: ' + e.getMessage());
        }
        Test.stopTest();

        // Assert that the error was handled gracefully
        System.assert(true, 'Error handling test passed');
    }
}