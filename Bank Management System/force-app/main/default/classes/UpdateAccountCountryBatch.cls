public class UpdateAccountCountryBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : scope) {
            acc.BillingCountry = 'IND';
            acc.ShippingCountry = 'IND';
            accountsToUpdate.add(acc);
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    public void finish(Database.BatchableContext BC) {
       
    }
}