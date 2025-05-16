public class DepositHelper {
    public static void newDeposit(List<Deposit__c> depositList) {
        List<Transaction__c> newTransList = new List<Transaction__c>();
        
        for (Deposit__c deposit : depositList) {
            // Validate required fields
            if (deposit.Amount__c != null && deposit.Bank_Account__c != null) {
                Transaction__c newTrans = new Transaction__c();
                newTrans.Name = deposit.Name;
                newTrans.Amount__c = deposit.Amount__c;
                newTrans.Receiver_Account__c = deposit.Bank_Account__c;
                newTransList.add(newTrans);
            }
        }
        insert newTransList;
        
        // Insert only if the list is not empty
       /* if (!newTransList.isEmpty()) {
            try {
                insert newTransList;
           } catch (DmlException e) {
                // Log error and handle gracefully
                System.debug('DML Exception occurred: ' + e.getMessage());
            }
        }*/
    }
}