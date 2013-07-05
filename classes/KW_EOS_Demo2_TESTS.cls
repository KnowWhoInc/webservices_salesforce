@isTest
public class KW_EOS_Demo2_TESTS {

/*Peter Churchill, July 2013
Because the code provided is unmanaged, you need to be able to test it like any other Apex Code in order to deploy it.
It is preferable to store as much the differnt parameters for each campaign on an object or a custom setting, but
you will always need to deploy some code. So this sample test script shows you how you can get test coverage
for your code that uses KnowWho Web Services. The three tests below cover the respective sample classes.
*/

@isTest
public static void Sample_EODS_TEST () {

//Because this is in test mode, there is no Service setup, so we create one
kweos.KnowWhoMockXMLResponses_TEST.setupEODSService();
    
/* Because this is in test mode, we can't make a callout - so we setup a mock interface to 
simulate callout and response */
kweos.KnowWhoMockXMLResponses_TEST.setupMockInterface();

KWEODS_Demo_Controller kwt = new KWEODS_Demo_Controller();
system.assertequals(FALSE, kwt.bErrorCode); //Check Services enabled

//Set page params
kwt.sparams[0] = '4205 Test Drive';
kwt.sparams[1] = 'San Diego';
kwt.sparams[2] = 'CA';
kwt.sparams[3] = '92130';
kwt.sparams[4] = '2220';
kwt.sparams[5] = '-333';
kwt.sparams[6] = '-222';

//Wrap call to KW Services in test.StartTest to avoid errors with callouts
test.starttest();  
   kwt.getData(); //we can test all three this way...
   kwt.getDatabyZip4();
   kwt.getDatabyLatLong();
test.stoptest();
kwt.reset();
//Check data comes back from test
system.assertequals('Hon. Barack Obama', kwt.kweods.kweodsdata.KnowWho.USGovernment.ElectedOfficials[0].PersonInformation.FullName);   
}

@isTest
public static void Sample_EOCS_TEST () {

//Because this is in test mode, there is no Service setup, so we create one
kweos.KnowWhoMockXMLResponses_TEST.setupEOCSService();

/* Because this is in test mode, we can't make a callout - so we setup a mock interface to 
simulate callout and response */   
kweos.KnowWhoMockXMLResponses_TEST.setupMockInterface();

KWEOCS_Demo_Controller kwt = new KWEOCS_Demo_Controller();
system.assertequals(FALSE, kwt.bError); //Check Services enabled

//Test Booleans
kwt.showfilters();
kwt.hidefilters();

//Populate EOCS Object with Data
kwt.finaleocs.kweos__Prefix_Code__c = '01';
kwt.finaleocs.kweos__First_Name__c = 'Test FN';
kwt.finaleocs.kweos__Last_Name__c = 'Test LN';
kwt.finaleocs.kweos__Suffix_Code__c = '01';


kwt.finaleocs.kweos__Address1__c = 'Test Street 1';
kwt.finaleocs.kweos__Address2__c = 'Test Street 2';
kwt.finaleocs.kweos__City__c = 'Test City';
kwt.finaleocs.kweos__State__c = 'CA';
kwt.finaleocs.kweos__Postal_Code__c = '22206';

kwt.finaleocs.kweos__Phone__c = '202 555 1234';
kwt.finaleocs.kweos__Email__c = 'testkw@example.com';
kwt.finaleocs.kweos__Issue_Code__c = '53';
kwt.finaleocs.kweos__Subject__c = 'Test Subject';
kwt.finaleocs.kweos__Message__c = 'Test Message';

//Wrap call to KW Services in test.StartTest to avoid errors with callouts
test.starttest();
kwt.submitrecordtokw ();
test.stoptest();
system.assertequals('OK', kwt.sKWReturnCode);
}

@isTest
public static void Sample_EOS_Combined_TEST () {

//Because this is in test mode, there is no Service setup, so we create both
kweos.KnowWhoMockXMLResponses_TEST.setupEODSService();
kweos.KnowWhoMockXMLResponses_TEST.setupEOCSService();

/* Because this is in test mode, we can't make a callout - so we setup a mock interface to 
simulate callout and response */
kweos.KnowWhoMockXMLResponses_TEST.setupMockInterface();

KWEOS_Demo_Controller kwt = new KWEOS_Demo_Controller();

//Populate Data - we have to call both services in one test callout, so set all data
kwt.finaleocs.kweos__Prefix_Code__c = '01';
kwt.finaleocs.kweos__First_Name__c = 'Test FN';
kwt.finaleocs.kweos__Last_Name__c = 'Test LN';
kwt.finaleocs.kweos__Suffix_Code__c = '01';


kwt.finaleocs.kweos__Address1__c = 'Test Street 1';
kwt.finaleocs.kweos__Address2__c = 'Test Street 2';
kwt.finaleocs.kweos__City__c = 'Test City';
kwt.finaleocs.kweos__State__c = 'CA';
kwt.finaleocs.kweos__Postal_Code__c = '22206';

kwt.finaleocs.kweos__Phone__c = '202 555 1234';
kwt.finaleocs.kweos__Email__c = 'testkw@example.com';
kwt.finaleocs.kweos__Issue_Code__c = '53';
kwt.finaleocs.kweos__Subject__c = 'Test Subject';
kwt.finaleocs.kweos__Message__c = 'Test Message';

//We have to call both services in one test invocation
test.starttest();
kwt.getDatabyAddress ();
kwt.getDatabyZip4();
kwt.showeocsbutton();
kwt.capturePetition();
test.stoptest();
//system.assertequals('OK', kwt.sEODSReturnCode);
kwt.reset();
}


}