public class TransferTriggerHelper {
    public static void newTransfer(List<Transfer__c> transferList) {
        List<Transaction__c> newTransList = new List<Transaction__c>();
        for (Transfer__c transfer : transferList) {
            if (transfer.Transfer_Amount__c != null &&
                transfer.Benefactor_Account__c != null &&
                transfer.Beneficiary_Account__c != null) {
                
                Transaction__c newTrans = new Transaction__c();
                newTrans.name=transfer.name;
                newTrans.Amount__c = transfer.Transfer_Amount__c;
                newTrans.Sender_Account__c = transfer.Benefactor_Account__c;
                newTrans.Receiver_Account__c = transfer.Beneficiary_Account__c;
                newTransList.add(newTrans);
            }
        }
        if (!newTransList.isEmpty()) {
            try {
                insert newTransList;
            } catch (DmlException e) {
               
                System.debug('DML Exception: ' + e.getMessage());
            }
        }
    }
}