public  class PdfGenerateController {
    public Id studentId = ApexPages.currentPage().getParameters().get('id');
    public string pdfName{get;set;}
    
    public PageReference savePdf(){
        
        PageReference pdf = Page.GenerateStudentPdfClone;
        pdf.getParameters().put('id',studentId);
        Attachment attach = new Attachment();
        Blob body;
        try{
            body = pdf.getContentAsPDF();
        }catch(VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }
        attach.Body = body;
        attach.Name = 'StudentPdf.pdf';
        attach.ParentId = studentId;
        attach.IsPrivate = false;
        List<Attachment> attachmentList = [SELECT Id, ParentId FROM Attachment WHERE ParentId = :studentId];
        if(attachmentList.size() > 0)
        {
            delete attachmentList[0];
        }
        
        insert attach;
        PageReference renderOnPage = new PageReference('/'+ studentId);
        renderOnPage.setRedirect(true);
        return renderOnPage;
    }
    
    public Student__c getStudent(){
        Student__c student = [SELECT Id,Name,Class__r.Name,Age__c FROM Student__c];
        return student;
    }
}