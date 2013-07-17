public class KWEOCS_Demo_Controller {

/*Peter Churchill, July 2013
Sample Code below explains how to invoke KnowWho's EOCS Web Service

The key class in this code is the kweos.KnowWhoEOCSWrapper. This acts as the conduit to
the KW Web Service that submites messages to elected officials for the address/message details submitted to it. 

For thr purposes of demonstration, this page exposes several filters available to a developer. It is not expected that
a constituent would see/access these filters, but it is easier to see/test the functionality when you can set it on a page.
*/

public String sResults {get;set;}
public String sKWReturnCode {get;set;}
public Map<String, Set<String> > sContactedCodes {get;set;} //Will contains KnowWho Ids for officials who received message 
public Boolean bError {get;set;} //If there is a problem accessing service, this will return TRUE
public Boolean bShowFilters {get;set;} //Just for use on this demo page, enables you to show/hide filters

/*The KW service requires codes to be submitted for Pefix/Suffix/Issue, so we provide a simple List utilty to 
create select options for the codes. The full list is available in the Developer Docs if you wish to create you own versions*/
public kweos.KnowWhoEOCSListUtility kwlists {get;set;} 
//The wrapper that submits the request. It does not need to be available on the page, since we submit an object will all the fields to the service
kweos.KnowWhoEOCSWrapper kw;

//Public object that contains all the fields for a valid EOCS request, and where you can capture requests after submission for reporting
public kweos__EOCS_Data__c finaleocs {get;set;}

public KWEOCS_Demo_Controller() {
        finaleocs =  new kweos__EOCS_Data__c(); //initialize eocs object for use on page
        kwlists = new kweos.KnowWhoEOCSListUtility(); //initialize list utlity class for use on page
        kw = new kweos.KnowWhoEOCSWrapper();
        setupdefaulttargets(); //we can restrict/enable levels of goverment for the submissions. 
        bError = kw.bError; //Retrieve any errors from wrapper class based on initialization
        bShowFilters = FALSE; //default to not who filters
        sKWReturnCode = kw.sReturnCode;
        }


private void setupdefaulttargets() {
//We can restrict targets for any EOCS call - in this case, just target US Congress, regardless of my subscription
    finaleocs.kweos__Send_to_US_Senate__c = TRUE;
    finaleocs.kweos__Send_to_US_House__c = TRUE;
}

/*Core Method to submit message to officials for this address. 
NOTE - We don't have to have previously performed an EODS lookup to get officials - the EOCS service will do that for you*/
public pagereference submitrecordtokw () {

try{

/*Submit complete EOCS Object record from page to service. 
Note - the service just needs to receive a complete EOCS object i.e. with values for all fields shown as required on DEMO page. 
But the object can be populated however you need it to be, or pre-populated from a contact/campaign/custom 
object with name, address or issue data */

kw.submitDatatoKW(finaleocs);
sKWReturnCode =  kw.sReturnCode; //retrieve success code, either OK or error due to no matching address lookup etc 
finaleocs.kweos__Result_Code__c = kw.sReturnCode; //set code on EOCS Object for when we save it to database

/*The KnowWho Service uses codes for the three picklist options. So we translate them back to actual readable value here*/

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

/*retrieve the KnowWho Ids - we can then use these if we have KW Directories, 
or match them against EODS data we retrieved earlier*/
sContactedCodes = kw.eocsresponses;

//Insert records so we have a record of who sent a message, and who were the targets
upsert finaleocs;

}
Catch (Exception ex) {
sResults = ex.getmessage();
}
return null;
}

public pagereference showfilters () {//Page Control Methods to show Filters
bshowfilters = TRUE;
return null;
}

public pagereference hidefilters () {//Page Control Methods to hide Filters
bshowfilters = FALSE;
return null;
}


}