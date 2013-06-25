public class KWEOS_Demo_Controller{

public String sResults {get;set;}
public String sEODSReturnCode {get;set;}
public String sEOCSReturnCode {get;set;}
    
public String sLatitude {get;set;}
public String sLongitude {get;set;}
    
    
public Map<String, Set<String> > sContactedCodes {get;set;}

public Boolean bEOCSError {get;set;}
public Boolean bEODSError {get;set;}
public Boolean bShowEOCSButton {get;set;}
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
       finaleocs.kweos__subject__c = 'Sign our petition to tell the Government to use Cloud Computing!'; 
       sContactResults = new List<String> ();
       }


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

public pagereference capturePetition () {
    try{
        if (finaleocs.kweos__Message__c != null) {
        finaleocs.kweos__Message__c += '\n';
		finaleocs.kweos__Message__c += String.join(sContactResults, ';');
            
        }
    upsert finaleocs;
        bShowConfirmation = TRUE;
	}
	Catch (Exception ex) {

	}
return null;
}
    
public pagereference getDatabyAddress() {

try{

kwd.generateDatabyAddress(finaleocs.kweos__Address1__c, finaleocs.kweos__City__c, finaleocs.kweos__State__c, finaleocs.kweos__Postal_Code__c);
finaleocs.kweos__Plus_4__c = kwd.kweodsdata.KnowWho.Address.Plus4;
sLatitude = kwd.kweodsdata.KnowWho.Address.Latitude;
sLongitude = kwd.kweodsdata.KnowWho.Address.Longitude;
system.debug('RAW' + kwd.rawresults);
  sContactResults.add(kwd.kweodsdata.KnowWho.USGovernment.ElectedOfficials[2].PersonInformation.ContactId);
  sContactResults.add(kwd.kweodsdata.KnowWho.USGovernment.ElectedOfficials[3].PersonInformation.ContactId);
  sContactResults.add(kwd.kweodsdata.KnowWho.USGovernment.ElectedOfficials[4].PersonInformation.ContactId);
    
bShowEOCSButton = TRUE;
}

Catch (Exception Ex) {
}
return null;
}

public pagereference getDatabyZip4() {

try{
kwd.generateDatabyZip4(finaleocs.kweos__Postal_Code__c, finaleocs.kweos__Plus_4__c );
}
Catch (Exception Ex) {
}
return null;
}

public pagereference getDatabyLatLong() {

try{
kwd.generateDatabyLongLat(sLatitude,sLongitude);
}
Catch (Exception Ex) {
}
return null;
}    
    
public pagereference showfilters () {
bShowEOCSFilters = TRUE;
return null;
}

public pagereference showeocsbutton () {
bShowEOCSButton = TRUE;
return null;
}
    
public pagereference hidefilters () {
bShowEOCSFilters = FALSE;
return null;
}
    
public pagereference Reset() {
finaleocs =  new kweos__EOCS_Data__c();
return null;
}
    
    

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

}