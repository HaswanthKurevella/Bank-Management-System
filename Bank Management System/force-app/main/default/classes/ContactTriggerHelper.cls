public class ContactTriggerHelper {
    private static final Decimal MIN_BALANCE = 500;
    public static void checkSameAddress(list<contact>conList){
        for(contact con:conList){
            if(con.Current_Address_Same_as_Permanent__c==True){
                con.Current_Address__c=con.Permanent_Address__c;
            }
        }
    }
    public static void CheckMinBalance(list<contact>conList){
       List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Contact con:conList){
            if (con.Email != null && con.Account_Balance__c < MIN_BALANCE&&con.KYC__c==True) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{con.Email});
            email.setSubject('Low Account Balance Alert');
            email.setPlainTextBody('Dear ' + con.FirstName + ',\n\n' +
                                   'Your account balance (Rs.'+con.Account_Balance__c+') has dropped below the minimum required balance of 500.\n' +
                                   'Please ensure to maintain the required balance to avoid any inconvenience.\n\n' +
                                   'Best regards,\n' +
                                   'GenC Bank');
            emails.add(email);
        }
            
        }
         try {
             if (!emails.isEmpty()) {
                 Messaging.sendEmail(emails);
             }
         } 
        catch (Exception e) {
        
        System.debug('Error sending emails: ' + e.getMessage());
    }
    }

}