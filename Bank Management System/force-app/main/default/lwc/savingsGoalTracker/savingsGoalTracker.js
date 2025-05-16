import { LightningElement, track, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import ContactForAccBal from '@salesforce/messageChannel/ContactForAccBal__c';

export default class SavingsGoalTracker extends LightningElement {
    PresentAccBal = 0;
    @track savingsGoal = 100000; // Default goal
    @track progress = 0;
    @track isModalOpen = false;
    tempGoal;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            ContactForAccBal,
            (message) => {
                this.handleMessage(message);
            }
        );

        // Load saved goal from localStorage
        const savedGoal = localStorage.getItem('savingsGoal');
        if (savedGoal) {
            this.savingsGoal = parseInt(savedGoal, 10);
        }
        this.calculateProgress();
    }

    handleMessage(message) {
        this.PresentAccBal = message.accBalToSend;
        this.calculateProgress();
    }

    calculateProgress() {
        this.progress = Math.min((this.PresentAccBal / this.savingsGoal) * 100, 100);
    }

    get progressStyle() {
        return `width: ${this.progress}%`;
    }

    openModal() {
        this.tempGoal = this.savingsGoal;
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    handleGoalChange(event) {
        this.tempGoal = event.target.value;
    }

    saveGoal() {
        this.savingsGoal = parseInt(this.tempGoal, 10);
        localStorage.setItem('savingsGoal', this.savingsGoal);
        this.calculateProgress();
        this.closeModal();
    }
}