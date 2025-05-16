trigger TransferTrigger on Transfer__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        TransferTriggerHelper.newTransfer(Trigger.New);
    }
}