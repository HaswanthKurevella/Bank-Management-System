public class WithdrawalHelper {
    public static void newWithdrawal(List<Withdrawal__c> withdrawalList) {
        List<Transaction__c> newTransList = new List<Transaction__c>();
        
        for (Withdrawal__c withdrawal : withdrawalList) {
            // Validate required fields
            if (withdrawal.Bank_Account__c != null && withdrawal.Withdrawal_Amount__c != null) {
                Transaction__c newTrans = new Transaction__c();
                newTrans.Name=Withdrawal.Name;
                newTrans.Amount__c = withdrawal.Withdrawal_Amount__c;
                newTrans.Sender_Account__c = withdrawal.Bank_Account__c;
                newTransList.add(newTrans);
            }
        }
        insert newTransList;
        
        // Insert only if list is not empty
       /* if (!newTransList.isEmpty()) {
            try {
                insert newTransList;
            } catch (DmlException e) {
                // Log error and handle gracefully
                System.debug('Error inserting transactions: ' + e.getMessage());
            }
        }*/
    }
}