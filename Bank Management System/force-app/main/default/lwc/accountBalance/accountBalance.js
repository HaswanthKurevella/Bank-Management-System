import { LightningElement,track,wire } from 'lwc';
import getAccountBalance from '@salesforce/apex/AccountBalanceController.getAccountBalance';
import {publish,MessageContext} from 'lightning/messageService';
import ContactForAccBal from '@salesforce/messageChannel/ContactForAccBal__c';

export default class AccountBalance extends LightningElement {
    @track accountBalance;
    @track error;
    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        this.refreshBalance();
    }

    refreshBalance(){
        
      getAccountBalance()
        .then(result => {
            this.accountBalance = result; //set the fetched account balance
            this.error=undefined;//clear any errors
            const payload={accBalToSend:this.accountBalance};
            publish(this.messageContext,ContactForAccBal,payload);
        })
        .catch(error => {
            this.error = error;
            this.accountBalance = undefined;
            this.error=error.body.message||'An error occured while fetching the account balance';
            console.log('Error',error);
            
        });
        
    }
    handleRefresh(){
        this.refreshBalance();
    }
}