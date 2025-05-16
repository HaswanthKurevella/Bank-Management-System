trigger ContactTrigger on Contact (before insert,Before Update,after Update) {
    if(Trigger.isBefore&&Trigger.isInsert){
        ContactTriggerHelper.checkSameAddress(Trigger.New);
    }
    if(Trigger.isBefore&&Trigger.isUpdate){
        ContactTriggerHelper.checkSameAddress(Trigger.New);
    }
    if(Trigger.isAfter&&Trigger.isUpdate){
        ContactTriggerHelper.CheckMinBalance(Trigger.New);
    }

}