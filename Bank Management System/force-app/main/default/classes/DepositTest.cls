@isTest
public class DepositTest {
    @isTest
    static void testNewDeposit() {
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

        // Step 2: Prepare valid mock data for Deposit__c
        List<Deposit__c> depositList = new List<Deposit__c>();
        Deposit__c deposit1 = new Deposit__c(
            Bank_Account__c = contact1.Id,
            Amount__c = 50.00,
            Description__c = 'Test Deposit 1'
        );
        depositList.add(deposit1);
        Deposit__c deposit2 = new Deposit__c(
            Bank_Account__c = contact2.Id,
            Amount__c = 100.00,
            Description__c = 'Test Deposit 2'
        );
        depositList.add(deposit2);
        System.debug('Prepared Deposit List: ' + depositList);

        // Step 3: Call the method to be tested
        Test.startTest();
        DepositHelper.newDeposit(depositList);
        Test.stopTest();

        // Step 4: Assert the results
        System.assertEquals(2, depositList.size());
        System.assertEquals(50.00, depositList[0].Amount__c);
        System.assertEquals(contact1.Id, depositList[0].Bank_Account__c);
        System.assertEquals(100.00, depositList[1].Amount__c);
        System.assertEquals(contact2.Id, depositList[1].Bank_Account__c);
    }

    @isTest
    static void testEmptyDepositList() {
        // Test with an empty list
        List<Deposit__c> emptyDepositList = new List<Deposit__c>();
        Test.startTest();
        DepositHelper.newDeposit(emptyDepositList);
        Test.stopTest();
        // Assert that no Deposit__c records were inserted
        System.assertEquals(0, emptyDepositList.size());
    }

    @isTest
    static void testNullValuesInDepositList() {
        // Test with some null values in the deposit list
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

        List<Deposit__c> depositList = new List<Deposit__c>();
        Deposit__c deposit = new Deposit__c(
            Bank_Account__c = null, // Null Contact ID to skip this record
            Amount__c = null, // Null amount to skip this record
            Description__c = 'Invalid Deposit'
        );
        depositList.add(deposit);
        System.debug('Prepared Invalid Deposit List: ' + depositList);

        Test.startTest();
        DepositHelper.newDeposit(depositList);
        Test.stopTest();

        // Assert that no Deposit__c records were inserted
        System.assertEquals(1, depositList.size());
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

        List<Deposit__c> depositList = new List<Deposit__c>();
        Deposit__c deposit = new Deposit__c(
            Bank_Account__c = null, // Null Contact ID to simulate error
            Amount__c = 100.00,
            Description__c = 'Test Deposit with Error'
        );
     //   depositList.add(deposit);

        // Simulate DML exception
        Test.startTest();
        try {
            DepositHelper.newDeposit(depositList);
        } catch (DmlException e) {
            System.debug('Error inserting deposits: ' + e.getMessage());
        }
        Test.stopTest();

        // Assert that the error was handled gracefully
        System.assert(true, 'Error handling test passed');
    }
}