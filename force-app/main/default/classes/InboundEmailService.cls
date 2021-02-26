global class InboundEmailService implements Messaging.InboundEmailHandler {
    
    String XMLString;
    public List<Contact> contacts;
    Contact tempContact;
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope env){
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        for(Messaging.InboundEmail.textAttachment attachment : email.textAttachments) {
            if(attachment.fileName == 'CreateContacts.xml') {
                XMLString = attachment.body ;
            }
        }
        if(!String.isBlank(XMLString)) {
            XMLparse(XMLString);
        }
        
        return result;
    }
    
    public void XMLparse(String XMLString){
        contacts = new List<Contact>();
        DOM.Document doc=new DOM.Document();
        try{
            doc.load(XMLString);
            DOM.XmlNode rootNode=doc.getRootElement();
            parseXML(rootNode);
            contacts.add(tempContact);
            insert contacts;
        }catch(exception e){
            system.debug(e.getMessage());
        }
    }
    
    private void parseXML(DOM.XMLNode node) {
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            system.debug(node.getName());
            if(node.getName()=='contact'){
                if(tempContact!=null)
                    contacts.add(tempContact);
                tempContact = new Contact();
            }
            if(node.getName()=='firstname')
                tempContact.firstName=node.getText().trim();
            if(node.getName()=='lastname')
                tempContact.lastName=node.getText().trim();
            if(node.getName()=='email')
                tempContact.email=node.getText().trim();
            if(node.getName()=='department')
                tempContact.description=node.getText().trim();
            if(node.getName()=='phone')
                tempContact.phone=node.getText().trim();
        }
        for (Dom.XMLNode child: node.getChildElements()) {
            parseXML(child);
        }
    }
    
}