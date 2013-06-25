@isTest
public class KW_EOS_Demo2_TESTS {

@isTest
public static void EODS_TEST () {

//Setup Dummy Services
kweos.KnowWhoMockXMLResponses_TEST.setupEODSService();
kweos.KnowWhoMockXMLResponses_TEST.setupEOCSService();
    

kweos.KnowWhoMockXMLResponses_TEST.setupMockInterface();


KWEODS_Demo_Controller kwt = new KWEODS_Demo_Controller();

kwt.sparams[0] = '4205 Test Drive';
kwt.sparams[1] = 'San Diego';
kwt.sparams[2] = 'CA';
kwt.sparams[3] = '92130';
kwt.sparams[4] = '2220';
kwt.sparams[5] = '-333';
kwt.sparams[6] = '-222';

system.debug('R' + kwt.sResponseCode + ':' + kwt.bErrorCode);

test.starttest();  
   kwt.getData(); 
   kwt.getDatabyZip4();
   kwt.getDatabyLatLong();

   kwt.reset();

test.stoptest();

system.assertequals('Hon. Barack Obama', kwt.kweods.kweodsdata.KnowWho.USGovernment.ElectedOfficials[0].PersonInformation.FullName);   
}

@isTest
public static void EOCS_EXAMPLE_TEST () {

//Setup Dummy Services
kweos.KnowWhoMockXMLResponses_TEST.setupEODSService();
kweos.KnowWhoMockXMLResponses_TEST.setupEOCSService();
   

kweos.KnowWhoMockXMLResponses_TEST.setupMockInterface();

KWEOCS_Demo_Controller kwt = new KWEOCS_Demo_Controller();

system.assertequals(FALSE, kwt.bError);

kwt.showfilters();
kwt.hidefilters();

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

test.starttest();
kwt.submitrecordtokw ();
test.stoptest();

system.assertequals('OK', kwt.sKWReturnCode);

}

@isTest
public static void EOS_COMBO_EXAMPLE_TEST () {

//Setup Dummy Services
kweos.KnowWhoMockXMLResponses_TEST.setupEODSService();
kweos.KnowWhoMockXMLResponses_TEST.setupEOCSService();
   

kweos.KnowWhoMockXMLResponses_TEST.setupMockInterface();

KWEOS_Demo_Controller kwt = new KWEOS_Demo_Controller();

kwt.showfilters();
kwt.hidefilters();

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

test.starttest();
kwt.getDatabyAddress ();
kwt.capturePetition();
test.stoptest();


}


}