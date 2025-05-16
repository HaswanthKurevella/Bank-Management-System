import { LightningElement, track } from 'lwc';
import getRates from '@salesforce/apex/CurrencyConverter.getRates';

export default class CurrencyConverter extends LightningElement {
    @track baseCurrency = 'INR';
    @track targetCurrency = 'USD';
    @track amount = 1;
    @track convertedAmount;
    @track rates = [];
    @track conversionRates = {};

    connectedCallback() {
        this.fetchRates();
    }

    fetchRates() {
        getRates({ baseCurrency: this.baseCurrency })
            .then(result => {
                if (result) {
                    this.rates = Object.keys(result).map(currency => ({ label: currency, value: currency }));
                    this.conversionRates = result;
                }
            })
            .catch(error => {
                console.error('Error fetching rates:', JSON.stringify(error));
            });
    }

    handleBaseCurrencyChange(event) {
        this.baseCurrency = event.target.value;
        this.fetchRates(); // Refresh rates when base currency changes
    }

    handleTargetCurrencyChange(event) {
        this.targetCurrency = event.target.value;
    }

    handleAmountChange(event) {
        this.amount = event.target.value;
    }

    handleConvert() {
        if (this.conversionRates[this.targetCurrency]) {
            this.convertedAmount = (this.amount * this.conversionRates[this.targetCurrency]).toFixed(2);
        } else {
            this.convertedAmount = 'Error';
        }
    }
}