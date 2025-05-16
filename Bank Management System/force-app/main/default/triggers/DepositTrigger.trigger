trigger DepositTrigger on Deposit__c (after insert) {
	if (Trigger.isAfter && Trigger.isInsert) {
        DepositHelper.newDeposit(Trigger.New);
    }
}