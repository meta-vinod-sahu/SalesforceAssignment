import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import FAX_FIELD from '@salesforce/schema/Contact.Fax';

export default class createContactRecord extends LightningElement
 {
    
    @api objectApiName = "Contact";

    fields = [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD, FAX_FIELD];

    handleSuccess(event)
	{
        const evt = new ShowToastEvent({
            title: "Contact created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
    }

    handleFailure(event)
	{
        const evt = new ShowToastEvent({
            title: "Error!!",
            message: event.detail.error.message,
            variant: "failure"
        });
        this.dispatchEvent(evt);
    }
}