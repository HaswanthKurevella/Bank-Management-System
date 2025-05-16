public class TransactionPassbookController {
    public List<Transaction__c> transactions { get; set; }

    public TransactionPassbookController() {
        Id currentUserContactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;

        transactions = [
            SELECT Id, Sender_Name__c, Receiver_Name__c, Amount__c, CreatedDate 
            FROM Transaction__c 
            WHERE Sender_Name__c = :currentUserContactId OR Receiver_Name__c = :currentUserContactId
            ORDER BY CreatedDate DESC // Sorting transactions by creation date
        ];
    }
    public PageReference navigateToPdf() {
        return Page.TransactionPassbook; // Navigate to PDF page
    }
}