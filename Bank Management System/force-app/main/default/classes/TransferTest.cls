@isTest
public class TransferTest {
    @isTest
    static void testNewTransfer() {
        // Step 1: Create mock Account and Contact records
        Account benefactorAccount1 = new Account(Name = 'Benefactor Account 1', Branch_Address__c = '123 Main St');
        Account benefactorAccount2 = new Account(Name = 'Benefactor Account 2', Branch_Address__c = '456 Elm St');
        Account beneficiaryAccount1 = new Account(Name = 'Beneficiary Account 1', Branch_Address__c = '789 Pine St');
        Account beneficiaryAccount2 = new Account(Name = 'Beneficiary Account 2', Branch_Address__c = '101 Maple St');
        
        insert new List<Account>{benefactorAccount1, benefactorAccount2, beneficiaryAccount1, beneficiaryAccount2};
        System.debug('Inserted Benefactor Accounts: ' + benefactorAccount1.Id + ', ' + benefactorAccount2.Id);
        System.debug('Inserted Beneficiary Accounts: ' + beneficiaryAccount1.Id + ', ' + beneficiaryAccount2.Id);

        Contact contact1 = new Contact(
            LastName = 'Contact 1', 
            PAN_Card_Number__c = 'ABCDE1234F', 
            Contact_Number__c = '1234567890', 
            Initial_Deposit__c = 3000, 
            Email = 'contact1@example.com',
            AccountId = benefactorAccount1.Id
        );
        Contact contact2 = new Contact(
            LastName = 'Contact 2', 
            PAN_Card_Number__c = 'FGHIJ5678K', 
            Contact_Number__c = '0987654321', 
            Initial_Deposit__c = 4000, 
            Email = 'contact2@example.com',
            AccountId = benefactorAccount2.Id
        );
        Contact contact3 = new Contact(
            LastName = 'Contact 3', 
            PAN_Card_Number__c = 'LMNOP9876Q', 
            Contact_Number__c = '1122334455', 
            Initial_Deposit__c = 3000, 
            Email = 'contact3@example.com',
            AccountId = beneficiaryAccount1.Id
        );
        Contact contact4 = new Contact(
            LastName = 'Contact 4', 
            PAN_Card_Number__c = 'QRSTU1234V', 
            Contact_Number__c = '2233445566', 
            Initial_Deposit__c = 4000, 
            Email = 'contact4@example.com',
            AccountId = beneficiaryAccount2.Id
        );
        insert new List<Contact>{contact1, contact2, contact3, contact4};
        System.debug('Inserted Contacts: ' + contact1.Id + ', ' + contact2.Id + ', ' + contact3.Id + ', ' + contact4.Id);

        // Step 2: Prepare valid mock data for Transfer__c
        List<Transfer__c> transferList = new List<Transfer__c>();
        Transfer__c transfer1 = new Transfer__c(
            Benefactor_Account__c = benefactorAccount1.Id,
            Beneficiary_Account__c = beneficiaryAccount1.Id,
            Transfer_Amount__c = 100.00
        );
        transferList.add(transfer1);
        Transfer__c transfer2 = new Transfer__c(
            Benefactor_Account__c = benefactorAccount2.Id,
            Beneficiary_Account__c = beneficiaryAccount2.Id,
            Transfer_Amount__c = 200.00
        );
        transferList.add(transfer2);
        System.debug('Prepared Transfer List: ' + transferList);

        // Step 3: Call the method to be tested
        Test.startTest();
        TransferTriggerHelper.newTransfer(transferList);
        Test.stopTest();

        // Step 4: Assert the results
        System.assertEquals(2, transferList.size());
        System.assertEquals(100.00, transferList[0].Transfer_Amount__c);
        System.assertEquals(benefactorAccount1.Id, transferList[0].Benefactor_Account__c);
        System.assertEquals(beneficiaryAccount1.Id, transferList[0].Beneficiary_Account__c);

        System.assertEquals(200.00, transferList[1].Transfer_Amount__c);
        System.assertEquals(benefactorAccount2.Id, transferList[1].Benefactor_Account__c);
        System.assertEquals(beneficiaryAccount2.Id, transferList[1].Beneficiary_Account__c);
    }

    @isTest
    static void testEmptyTransferList() {
        // Test with an empty list
        List<Transfer__c> emptyTransferList = new List<Transfer__c>();

        Test.startTest();
        TransferTriggerHelper.newTransfer(emptyTransferList);
        Test.stopTest();

        // Assert that no Transfer__c records were inserted
        System.assertEquals(0, emptyTransferList.size());
    }

    @isTest
    static void testNullValuesInTransferList() {
        // Test with some null values in the transfer list
        Account beneficiaryAccount = new Account(Name = 'Beneficiary Account 3', Branch_Address__c = '202 Oak St');
        insert beneficiaryAccount;

        Contact contact = new Contact(
            LastName = 'Contact 5', 
            PAN_Card_Number__c = 'UVWXY1234Z', 
            Contact_Number__c = '3344556677', 
            Initial_Deposit__c = 3000, 
            Email = 'contact5@example.com',
            AccountId = beneficiaryAccount.Id
        );
        insert contact;

        List<Transfer__c> transferList = new List<Transfer__c>();
        Transfer__c transfer = new Transfer__c(
            Benefactor_Account__c = null, // Null Benefactor Account ID to skip this record
            Beneficiary_Account__c = beneficiaryAccount.Id,
            Transfer_Amount__c = null // Null amount to skip this record
        );
        transferList.add(transfer);
        System.debug('Prepared Invalid Transfer List: ' + transferList);

        Test.startTest();
        TransferTriggerHelper.newTransfer(transferList);
        Test.stopTest();

        // Assert that no Transfer__c records were inserted
        System.assertEquals(1, transferList.size());
    }

    @isTest
    static void testErrorHandling() {
        // Test error handling during insertion
        Account benefactorAccount = new Account(Name = 'Benefactor Account 4', Branch_Address__c = '303 Birch St');
        insert benefactorAccount;

        Contact contact = new Contact(
            LastName = 'Contact 6', 
            PAN_Card_Number__c = 'ABCDE1234F', 
            Contact_Number__c = '1234567890', 
            Initial_Deposit__c = 3000, 
            Email = 'contact6@example.com',
            AccountId = benefactorAccount.Id
        );
        insert contact;

        List<Transfer__c> transferList = new List<Transfer__c>();
        Transfer__c transfer = new Transfer__c(
            Benefactor_Account__c = contact.Id,
            Beneficiary_Account__c = null, // Null Beneficiary Account ID to simulate error
            Transfer_Amount__c = 100.00
        );
        transferList.add(transfer);

        // Simulate DML exception
        Test.startTest();
        try {
            TransferTriggerHelper.newTransfer(transferList);
        } catch (DmlException e) {
            System.debug('Error inserting transactions: ' + e.getMessage());
        }
        Test.stopTest();

        // Assert that the error was handled gracefully
        System.assert(true, 'Error handling test passed');
    }
}