public class KWEOS_Demo_Controller{

/*Peter Churchill, July 2013
Sample Code below explains how to combine KnowWho's Web Services on a single page
See EODS and EOCS sample code for detailed explanation of using each service
*/
public String sResults {get;set;}
public String sEODSReturnCode {get;set;}
public String sEOCSReturnCode {get;set;}
    
public String sLatitude {get;set;} //we will capture address information in an EOCS object, so need fields for Lat and Long
public String sLongitude {get;set;}
    
    
public Map<String, Set<String> > sContactedCodes {get;set;}

public Boolean bEOCSError {get;set;}
public Boolean bEODSError {get;set;}
public Boolean bShowEOCSButton {get;set;} //only show eocs button once we have completed EODS request
public Boolean bShowConfirmation {get;set;}
List<String> sContactResults;    
    

public Boolean bShowEOCSFilters {get;set;}

public kweos.KnowWhoEOCSListUtility kwlists {get;set;}
kweos.KnowWhoEOCSWrapper kwc;
public kweos.KnowWhoEODSWrapper kwd {get;set;}

public kweos__EOCS_Data__c finaleocs {get;set;}

public KWEOS_Demo_Controller() {
       finaleocs =  new kweos__EOCS_Data__c();
       kwlists = new kweos.KnowWhoEOCSListUtility();
       kwc = new kweos.KnowWhoEOCSWrapper();
       kwd = new kweos.KnowWhoEODSWrapper();
       setupdefaulttargets();
       bEOCSError = kwc.bError;
       bEODSError = kwd.bError;
        bShowConfirmation = FALSE;
       bShowEOCSFilters = FALSE;
       sEOCSReturnCode = kwc.sReturnCode;
       sEODSReturnCode = kwd.sReturnCode;
       finaleocs.kweos__subject__c = 'Sign our petition to tell the Government to use Cloud Computing!'; //we can default message on EOCS request
       sContactResults = new List<String> ();

       /*We can reduce the volume of data we get back (and speed up response with additional fitlers
       See Dev Guide for more info on each filter */
       kwd.filterServiceLevel[0] = 'Basic';
       kwd.filterServiceLevel[1] = 'Y';
       kwd.filterServiceLevel[2] = 'N';
       kwd.filterServiceLevel[3] = 'N';
   
   
       }



    
public pagereference getDatabyAddress() {

try{
//for this sample code, we invoke EODS using data from instance of EOCS Object, rather than string variables
kwd.generateDatabyAddress(finaleocs.kweos__Address1__c, finaleocs.kweos__City__c, finaleocs.kweos__State__c, finaleocs.kweos__Postal_Code__c);
setEODSFields();    
bShowEOCSButton = TRUE;
}

Catch (Exception Ex) {
}
return null;
}

public pagereference getDatabyZip4() {
//Using EOCS Object to get data
try{
kwd.generateDatabyZip4(finaleocs.kweos__Postal_Code__c, finaleocs.kweos__Plus_4__c );
setEODSFields();    
bShowEOCSButton = TRUE;
}
Catch (Exception Ex) {
}
return null;
}


//We can submit the EOCS using data capture via EODS - just uncomment this code

/*
public pagereference submitrecordtokw () {

try{
kwc.submitDatatoKW(finaleocs);
system.debug(kwc.rawresults);
sEOCSReturnCode =  kwc.sReturnCode;
finaleocs.kweos__Result_Code__c = kwc.sReturnCode;

upsert finaleocs;
sContactedCodes = kwc.eocsresponses;

}
Catch (Exception ex) {
sResults = ex.getmessage();
}
return null;
}
*/

public pagereference capturePetition () {
  //Rather than submit a messgage to officials, we will just capture it in the EOCS Request object
    try{
        if (finaleocs.kweos__Message__c != null) {
        finaleocs.kweos__Message__c += '\n';
        finaleocs.kweos__Message__c += String.join(sContactResults, ';'); //For demo, just add KnowWho Ids to the message.   
            
        }
    processPicklistCodes();
    upsert finaleocs;
    bShowConfirmation = TRUE;
    }
    Catch (Exception ex) {

    }
return null;
}
    
public pagereference showeocsbutton () {
bShowEOCSButton = TRUE;
return null;
}
    
public pagereference Reset() {
finaleocs =  new kweos__EOCS_Data__c();
return null;
}
    
    
//Moved processing out of submission class to it's own method
private void processPicklistCodes () {
if (!String.isEmpty(finaleocs.kweos__Prefix_Code__c)) {

for (SelectOption a: kwlists.prefixes) {
        if (finaleocs.kweos__Prefix_Code__c == a.getvalue()) {
            finaleocs.kweos__Prefix__c = a.getlabel();
            break;
        }
   }
}

if (!String.isEmpty(finaleocs.kweos__Suffix_Code__c)) {

for (SelectOption a: kwlists.suffixes) {
        if (finaleocs.kweos__Suffix_Code__c == a.getvalue()) {
            finaleocs.kweos__Suffix__c = a.getlabel();
            break;
        }
   }
}

if (!String.isEmpty(finaleocs.kweos__Issue_Code__c)) {

for (SelectOption a: kwlists.issues) {
        if (finaleocs.kweos__Issue_Code__c == a.getvalue()) {
            finaleocs.kweos__Issue__c = a.getlabel();
            break;
        }
   }
}
}

private void setupdefaulttargets() {
finaleocs.kweos__Send_to_US_Senate__c = TRUE;
finaleocs.kweos__Send_to_US_House__c = TRUE;

}

private void setEODSFields () {
//We get back Plus4, Lat and Lon, so we can save them for future use
finaleocs.kweos__Plus_4__c = kwd.kweodsdata.KnowWho.Address.Plus4;
sLatitude = kwd.kweodsdata.KnowWho.Address.Latitude;
sLongitude = kwd.kweodsdata.KnowWho.Address.Longitude;

/*We can access EODS result object in Controller - and then extract values such as KNowWho Ids here.
We can use that data to match yo Sample Code below explains how to combine KnowWho's Web Services on a single page
*/
  sContactResults.add(kwd.kweodsdata.KnowWho.USGovernment.ElectedOfficials[2].PersonInformation.ContactId);
  sContactResults.add(kwd.kweodsdata.KnowWho.USGovernment.ElectedOfficials[3].PersonInformation.ContactId);
  sContactResults.add(kwd.kweodsdata.KnowWho.USGovernment.ElectedOfficials[4].PersonInformation.ContactId);

}

}