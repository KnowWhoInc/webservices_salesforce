public with sharing class KWEODS_Demo_Controller{
/*Peter Churchill, July 2013
Sample Code below explains how to invoke KnowWho's EODS Web Service

The key class in this code is the kweos.KnowWhoEODSWrapper. This acts as the conduit to
the KW Web Service that retrieves elected officials for the address submitted to it.
*/


public kweos.KnowWhoEODSWrapper kweods {get;set;}
public String sResponseCode {get;set;}
public Boolean bErrorCode {get;set;} //If no trials/subscriptions have been setup, this will return TRUE

/* For this example, we are using a simple String Collection to store the address parameters since the service just receives strings.
In the combined EOS example class, you'll see the EOCS Object used to pass in params as an alternative approach. */
public List<String> sparams {get;set;} 

public KWEODS_Demo_Controller() {
    kweods = new kweos.KnowWhoEODSWrapper(); //invoke new instance of wrapper
    sResponseCode = kweods.ResponseCode; //will receive back response based on success of address lookup
    bErrorCode = kweods.bError; //will store error message if error is returned
    setparams(); //setup string collection for page inputs
}

//initial set up of String params to store address data
private void setparams() {
    sparams = new List<String> ();
    //On Page, these params refer to values below
    sparams.add(''); //Address Line
    sparams.add(''); //City
    sparams.add(''); //State
    sparams.add(''); //Postal Code
    sparams.add(''); //Zip 4
    sparams.add(''); //Latitude
    sparams.add(''); //longitude
}


public pagereference getData() {//Page method that processes standard address submission

    try{

        kweods.generateDatabyAddress(sparams[0],sparams[1],sparams[2],sparams[3]);

        sparams[4] = kweods.kweodsdata.KnowWho.Address.Plus4; //For standard address, you will get back the zip 4 that you can use
        sparams[5] = kweods.kweodsdata.KnowWho.Address.Latitude; //For standard address, you will get back the Latitude that you can use
        sparams[6] = kweods.kweodsdata.KnowWho.Address.Longitude; //For standard address, you will get back the Longitude that you can use
        system.debug('RAW' + kweods.rawresults); //EODS Results are returned as raw XML/JSON depending on output requested
        //See EODS Demo Page for more information about how you access Apex Class containing de-serialized JSON
        }

    Catch (Exception Ex) {
        system.debug(Ex.getMessage()); //You can catch submission errors here if required
        }

return null;
}

public pagereference getDatabyZip4() {//Page method that processes submission with zip5 + zip4 (must be just 5 characters for param1, 4 for param2)

    try{
        kweods.generateDatabyZip4(sparams[3],sparams[4]);
    }
        
    Catch (Exception Ex) {
        system.debug(Ex.getMessage()); //You can catch submission errors here if required
    }

return null;
}

public pagereference getDatabyLatLong() {
    /*Page method that processes submission using Lat and Long. Most likely use case would be 
    for identification using a mobile device */

    try{
        kweods.generateDatabyLongLat(sparams[5],sparams[6]);
    }

    Catch (Exception Ex) {
        system.debug(Ex.getMessage()); //You can catch submission errors here if required
    }
return null;
}

//To enable inputs to be reset
public pagereference Reset() {
    setparams();
    return null;
}





}