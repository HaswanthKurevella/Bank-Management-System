global class Batch1 implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, OwnerId FROM Account WHERE Owner.Profile.Name = 'System Administrator']);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {
               User targetUser = [SELECT Id FROM User WHERE Profile.Name = 'CapitalInfo' LIMIT 1];
        for (Account acc : scope) {
            acc.OwnerId = targetUser.Id; 
        }
        update scope;

    }
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch process completed!');
}
}