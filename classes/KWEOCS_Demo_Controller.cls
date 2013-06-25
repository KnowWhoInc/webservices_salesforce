public class KWEOCS_Demo_Controller {

public String sResults {get;set;}
public String sKWReturnCode {get;set;}
public Map<String, Set<String> > sContactedCodes {get;set;}
public Boolean bError {get;set;}
public Boolean bShowFilters {get;set;}

public kweos.KnowWhoEOCSListUtility kwlists {get;set;}
kweos.KnowWhoEOCSWrapper kw;

public kweos__EOCS_Data__c finaleocs {get;set;}

public KWEOCS_Demo_Controller() {
        finaleocs =  new kweos__EOCS_Data__c();
        kwlists = new kweos.KnowWhoEOCSListUtility();
        kw = new kweos.KnowWhoEOCSWrapper();
       setupdefaulttargets();
        bError = kw.bError;
        bShowFilters = FALSE;
        sKWReturnCode = kw.sReturnCode;
        }

private void setupdefaulttargets() {
finaleocs.kweos__Send_to_US_Senate__c = TRUE;
finaleocs.kweos__Send_to_US_House__c = TRUE;

}
public pagereference submitrecordtokw () {

try{
kw.submitDatatoKW(finaleocs);
system.debug(kw.rawresults);
sKWReturnCode =  kw.sReturnCode;
finaleocs.kweos__Result_Code__c = kw.sReturnCode;

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

upsert finaleocs;
sContactedCodes = kw.eocsresponses;

}
Catch (Exception ex) {
sResults = ex.getmessage();
}
return null;
}

public pagereference showfilters () {
bshowfilters = TRUE;
return null;
}

public pagereference hidefilters () {
bshowfilters = FALSE;
return null;
}


}