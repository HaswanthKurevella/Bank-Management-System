trigger WithdrawalTrigger on Withdrawal__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        WithdrawalHelper.newWithdrawal(Trigger.New);
    }
}