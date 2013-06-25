public with sharing class KWEODS_Demo_Controller{

public kweos.KnowWhoEODSWrapper kweods {get;set;}
public String sResponseCode {get;set;}
public Boolean bErrorCode {get;set;}

public List<String> sparams {get;set;}

public KWEODS_Demo_Controller() {
kweods = new kweos.KnowWhoEODSWrapper();
sResponseCode = kweods.ResponseCode;
bErrorCode = kweods.bError;
//kweods.ResponseFormat = 'XML';
setparams();

}


public pagereference Reset() {
setparams();
return null;
}

public pagereference getData() {

try{

kweods.generateDatabyAddress(sparams[0],sparams[1],sparams[2],sparams[3]);

sparams[4] = kweods.kweodsdata.KnowWho.Address.Plus4;
sparams[5] = kweods.kweodsdata.KnowWho.Address.Latitude;
sparams[6] = kweods.kweodsdata.KnowWho.Address.Longitude;
system.debug('RAW' + kweods.rawresults);
}

Catch (Exception Ex) {
}
return null;
}

public pagereference getDatabyZip4() {

try{

kweods.generateDatabyZip4(sparams[3],sparams[4]);
}

Catch (Exception Ex) {
}
return null;
}

public pagereference getDatabyLatLong() {

try{

kweods.generateDatabyLongLat(sparams[5],sparams[6]);
}

Catch (Exception Ex) {
}
return null;
}

private void setparams() {
sparams = new List<String> ();
sparams.add('');
sparams.add('');
sparams.add('');
sparams.add('');
sparams.add('');
sparams.add('');
sparams.add('');
}



}