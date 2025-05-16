public without sharing class CurrencyConverter {
    @AuraEnabled(cacheable=true)
    public static Map<String, Decimal> getRates(String baseCurrency) {
        String endpoint = 'https://v6.exchangerate-api.com/v6/4c2436ae479598d735d50db4/latest/' + baseCurrency;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setTimeout(10000); 

        HttpResponse response = http.send(request);
        System.debug('API Response: ' + response.getBody());

        if (response.getStatusCode() == 200) {
            try {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                if (jsonResponse.containsKey('conversion_rates')) {
                    Map<String, Object> rawRates = (Map<String, Object>) jsonResponse.get('conversion_rates');
                    Map<String, Decimal> conversionRates = new Map<String, Decimal>();

                    for (String key : rawRates.keySet()) {
                        conversionRates.put(key, Decimal.valueOf(String.valueOf(rawRates.get(key))));
                    }
                    
                    return conversionRates;
                } else {
                    throw new CalloutException('Error: Missing conversion_rates in API response.');
                }
            } catch (Exception e) {
                throw new CalloutException('Error parsing response: ' + e.getMessage());
            }
        } else {
            throw new CalloutException('API Error: ' + response.getStatus());
        }
    }
}