/*ADOBE SYSTEMS INCORPORATED
Copyright 2012 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.*/
function cfinit(){
if(!window.ColdFusion){
ColdFusion={};
var $C=ColdFusion;
if(!$C.Ajax){
$C.Ajax={};
}
var $A=$C.Ajax;
if(!$C.AjaxProxy){
$C.AjaxProxy={};
}
var $X=$C.AjaxProxy;
if(!$C.Bind){
$C.Bind={};
}
var $B=$C.Bind;
if(!$C.Event){
$C.Event={};
}
var $E=$C.Event;
if(!$C.Log){
$C.Log={};
}
var $L=$C.Log;
if(!$C.Util){
$C.Util={};
}
var $U=$C.Util;
if(!$C.DOM){
$C.DOM={};
}
var $D=$C.DOM;
if(!$C.Spry){
$C.Spry={};
}
var $S=$C.Spry;
if(!$C.Pod){
$C.Pod={};
}
var $P=$C.Pod;
if(!$C.objectCache){
$C.objectCache={};
}
if(!$C.required){
$C.required={};
}
if(!$C.importedTags){
$C.importedTags=[];
}
if(!$C.requestCounter){
$C.requestCounter=0;
}
if(!$C.bindHandlerCache){
$C.bindHandlerCache={};
}
window._cf_loadingtexthtml="<div style=\"text-align: center;\">"+window._cf_loadingtexthtml+"&nbsp;"+CFMessage["loading"]+"</div>";
$C.globalErrorHandler=function(_27a,_27b){
if($L.isAvailable){
$L.error(_27a,_27b);
}
if($C.userGlobalErrorHandler){
$C.userGlobalErrorHandler(_27a);
}
if(!$L.isAvailable&&!$C.userGlobalErrorHandler){
alert(_27a+CFMessage["globalErrorHandler.alert"]);
}
};
$C.handleError=function(_27c,_27d,_27e,_27f,_280,_281,_282,_283){
var msg=$L.format(_27d,_27f);
if(_27c){
$L.error(msg,"http");
if(!_280){
_280=-1;
}
if(!_281){
_281=msg;
}
_27c(_280,_281,_283);
}else{
if(_282){
$L.error(msg,"http");
throw msg;
}else{
$C.globalErrorHandler(msg,_27e);
}
}
};
$C.setGlobalErrorHandler=function(_285){
$C.userGlobalErrorHandler=_285;
};
$A.createXMLHttpRequest=function(){
try{
return new XMLHttpRequest();
}
catch(e){
}
var _286=["Microsoft.XMLHTTP","MSXML2.XMLHTTP.5.0","MSXML2.XMLHTTP.4.0","MSXML2.XMLHTTP.3.0","MSXML2.XMLHTTP"];
for(var i=0;i<_286.length;i++){
try{
return new ActiveXObject(_286[i]);
}
catch(e){
}
}
return false;
};
$A.isRequestError=function(req){
return ((req.status!=0&&req.status!=200)||req.getResponseHeader("server-error"));
};
$A.sendMessage=function(url,_28a,_28b,_28c,_28d,_28e,_28f){
var req=$A.createXMLHttpRequest();
if(!_28a){
_28a="GET";
}
if(_28c&&_28d){
req.onreadystatechange=function(){
$A.callback(req,_28d,_28e);
};
}
if(_28b){
_28b+="&_cf_nodebug=true&_cf_nocache=true";
}else{
_28b="_cf_nodebug=true&_cf_nocache=true";
}
if(window._cf_clientid){
_28b+="&_cf_clientid="+_cf_clientid;
}
if(_28a=="GET"){
if(_28b){
_28b+="&_cf_rc="+($C.requestCounter++);
if(url.indexOf("?")==-1){
url+="?"+_28b;
}else{
url+="&"+_28b;
}
}
$L.info("ajax.sendmessage.get","http",[url]);
req.open(_28a,url,_28c);
req.send(null);
}else{
$L.info("ajax.sendmessage.post","http",[url,_28b]);
req.open(_28a,url,_28c);
req.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
if(_28b){
req.send(_28b);
}else{
req.send(null);
}
}
if(!_28c){
while(req.readyState!=4){
}
if($A.isRequestError(req)){
$C.handleError(null,"ajax.sendmessage.error","http",[req.status,req.statusText],req.status,req.statusText,_28f);
}else{
return req;
}
}
};
$A.callback=function(req,_292,_293){
if(req.readyState!=4){
return;
}
req.onreadystatechange=new Function;
_292(req,_293);
};
$A.submitForm=function(_294,url,_296,_297,_298,_299){
var _29a=$C.getFormQueryString(_294);
if(_29a==-1){
$C.handleError(_297,"ajax.submitform.formnotfound","http",[_294],-1,null,true);
return;
}
if(!_298){
_298="POST";
}
_299=!(_299===false);
var _29b=function(req){
$A.submitForm.callback(req,_294,_296,_297);
};
$L.info("ajax.submitform.submitting","http",[_294]);
var _29d=$A.sendMessage(url,_298,_29a,_299,_29b);
if(!_299){
$L.info("ajax.submitform.success","http",[_294]);
return _29d.responseText;
}
};
$A.submitForm.callback=function(req,_29f,_2a0,_2a1){
if($A.isRequestError(req)){
$C.handleError(_2a1,"ajax.submitform.error","http",[req.status,_29f,req.statusText],req.status,req.statusText);
}else{
$L.info("ajax.submitform.success","http",[_29f]);
if(_2a0){
_2a0(req.responseText);
}
}
};
$C.empty=function(){
};
$C.setSubmitClicked=function(_2a2,_2a3){
var el=$D.getElement(_2a3,_2a2);
el.cfinputbutton=true;
$C.setClickedProperty=function(){
el.clicked=true;
};
$E.addListener(el,"click",$C.setClickedProperty);
};
$C.getFormQueryString=function(_2a5,_2a6){
var _2a7;
if(typeof _2a5=="string"){
_2a7=(document.getElementById(_2a5)||document.forms[_2a5]);
}else{
if(typeof _2a5=="object"){
_2a7=_2a5;
}
}
if(!_2a7||null==_2a7.elements){
return -1;
}
var _2a8,elementName,elementValue,elementDisabled;
var _2a9=false;
var _2aa=(_2a6)?{}:"";
for(var i=0;i<_2a7.elements.length;i++){
_2a8=_2a7.elements[i];
elementDisabled=_2a8.disabled;
elementName=_2a8.name;
elementValue=_2a8.value;
if(!elementDisabled&&elementName){
switch(_2a8.type){
case "select-one":
case "select-multiple":
for(var j=0;j<_2a8.options.length;j++){
if(_2a8.options[j].selected){
if(window.ActiveXObject){
_2aa=$C.getFormQueryString.processFormData(_2aa,_2a6,elementName,_2a8.options[j].attributes["value"].specified?_2a8.options[j].value:_2a8.options[j].text);
}else{
_2aa=$C.getFormQueryString.processFormData(_2aa,_2a6,elementName,_2a8.options[j].hasAttribute("value")?_2a8.options[j].value:_2a8.options[j].text);
}
}
}
break;
case "radio":
case "checkbox":
if(_2a8.checked){
_2aa=$C.getFormQueryString.processFormData(_2aa,_2a6,elementName,elementValue);
}
break;
case "file":
case undefined:
case "reset":
break;
case "button":
_2aa=$C.getFormQueryString.processFormData(_2aa,_2a6,elementName,elementValue);
break;
case "submit":
if(_2a8.cfinputbutton){
if(_2a9==false&&_2a8.clicked){
_2aa=$C.getFormQueryString.processFormData(_2aa,_2a6,elementName,elementValue);
_2a9=true;
}
}else{
_2aa=$C.getFormQueryString.processFormData(_2aa,_2a6,elementName,elementValue);
}
break;
case "textarea":
var _2ad;
if(window.FCKeditorAPI&&(_2ad=$C.objectCache[elementName])&&_2ad.richtextid){
var _2ae=FCKeditorAPI.GetInstance(_2ad.richtextid);
if(_2ae){
elementValue=_2ae.GetXHTML();
}
}
_2aa=$C.getFormQueryString.processFormData(_2aa,_2a6,elementName,elementValue);
break;
default:
_2aa=$C.getFormQueryString.processFormData(_2aa,_2a6,elementName,elementValue);
break;
}
}
}
if(!_2a6){
_2aa=_2aa.substr(0,_2aa.length-1);
}
return _2aa;
};
$C.getFormQueryString.processFormData=function(_2af,_2b0,_2b1,_2b2){
if(_2b0){
if(_2af[_2b1]){
_2af[_2b1]+=","+_2b2;
}else{
_2af[_2b1]=_2b2;
}
}else{
_2af+=encodeURIComponent(_2b1)+"="+encodeURIComponent(_2b2)+"&";
}
return _2af;
};
$A.importTag=function(_2b3){
$C.importedTags.push(_2b3);
};
$A.checkImportedTag=function(_2b4){
var _2b5=false;
for(var i=0;i<$C.importedTags.length;i++){
if($C.importedTags[i]==_2b4){
_2b5=true;
break;
}
}
if(!_2b5){
$C.handleError(null,"ajax.checkimportedtag.error","widget",[_2b4]);
}
};
$C.getElementValue=function(_2b7,_2b8,_2b9){
if(!_2b7){
$C.handleError(null,"getelementvalue.noelementname","bind",null,null,null,true);
return;
}
if(!_2b9){
_2b9="value";
}
var _2ba=$B.getBindElementValue(_2b7,_2b8,_2b9);
if(typeof (_2ba)=="undefined"){
_2ba=null;
}
if(_2ba==null){
$C.handleError(null,"getelementvalue.elnotfound","bind",[_2b7,_2b9],null,null,true);
return;
}
return _2ba;
};
$B.getBindElementValue=function(_2bb,_2bc,_2bd,_2be,_2bf){
var _2c0="";
if(window[_2bb]){
var _2c1=eval(_2bb);
if(_2c1&&_2c1._cf_getAttribute){
_2c0=_2c1._cf_getAttribute(_2bd);
return _2c0;
}
}
var _2c2=$C.objectCache[_2bb];
if(_2c2&&_2c2._cf_getAttribute){
_2c0=_2c2._cf_getAttribute(_2bd);
return _2c0;
}
var el=$D.getElement(_2bb,_2bc);
var _2c4=(el&&((!el.length&&el.length!=0)||(el.length&&el.length>0)||el.tagName=="SELECT"));
if(!_2c4&&!_2bf){
$C.handleError(null,"bind.getbindelementvalue.elnotfound","bind",[_2bb]);
return null;
}
if(el.tagName!="SELECT"){
if(el.length>1){
var _2c5=true;
for(var i=0;i<el.length;i++){
var _2c7=(el[i].getAttribute("type")=="radio"||el[i].getAttribute("type")=="checkbox");
if(!_2c7||(_2c7&&el[i].checked)){
if(!_2c5){
_2c0+=",";
}
_2c0+=$B.getBindElementValue.extract(el[i],_2bd);
_2c5=false;
}
}
}else{
_2c0=$B.getBindElementValue.extract(el,_2bd);
}
}else{
var _2c5=true;
for(var i=0;i<el.options.length;i++){
if(el.options[i].selected){
if(!_2c5){
_2c0+=",";
}
_2c0+=$B.getBindElementValue.extract(el.options[i],_2bd);
_2c5=false;
}
}
}
if(typeof (_2c0)=="object"){
$C.handleError(null,"bind.getbindelementvalue.simplevalrequired","bind",[_2bb,_2bd]);
return null;
}
if(_2be&&$C.required[_2bb]&&_2c0.length==0){
return null;
}
return _2c0;
};
$B.getBindElementValue.extract=function(el,_2c9){
var _2ca=el[_2c9];
if((_2ca==null||typeof (_2ca)=="undefined")&&el.getAttribute){
_2ca=el.getAttribute(_2c9);
}
return _2ca;
};
$L.init=function(){
if(window.YAHOO&&YAHOO.widget&&YAHOO.widget.Logger){
YAHOO.widget.Logger.categories=[CFMessage["debug"],CFMessage["info"],CFMessage["error"],CFMessage["window"]];
YAHOO.widget.LogReader.prototype.formatMsg=function(_2cb){
var _2cc=_2cb.category;
return "<p>"+"<span class='"+_2cc+"'>"+_2cc+"</span>:<i>"+_2cb.source+"</i>: "+_2cb.msg+"</p>";
};
var _2cd=new YAHOO.widget.LogReader(null,{width:"30em",fontSize:"100%"});
_2cd.setTitle(CFMessage["log.title"]||"ColdFusion AJAX Logger");
_2cd._btnCollapse.value=CFMessage["log.collapse"]||"Collapse";
_2cd._btnPause.value=CFMessage["log.pause"]||"Pause";
_2cd._btnClear.value=CFMessage["log.clear"]||"Clear";
$L.isAvailable=true;
}
};
$L.log=function(_2ce,_2cf,_2d0,_2d1){
if(!$L.isAvailable){
return;
}
if(!_2d0){
_2d0="global";
}
_2d0=CFMessage[_2d0]||_2d0;
_2cf=CFMessage[_2cf]||_2cf;
_2ce=$L.format(_2ce,_2d1);
YAHOO.log(_2ce,_2cf,_2d0);
};
$L.format=function(code,_2d3){
var msg=CFMessage[code]||code;
if(_2d3){
for(i=0;i<_2d3.length;i++){
if(!_2d3[i].length){
_2d3[i]="";
}
var _2d5="{"+i+"}";
msg=msg.replace(_2d5,_2d3[i]);
}
}
return msg;
};
$L.debug=function(_2d6,_2d7,_2d8){
$L.log(_2d6,"debug",_2d7,_2d8);
};
$L.info=function(_2d9,_2da,_2db){
$L.log(_2d9,"info",_2da,_2db);
};
$L.error=function(_2dc,_2dd,_2de){
$L.log(_2dc,"error",_2dd,_2de);
};
$L.dump=function(_2df,_2e0){
if($L.isAvailable){
var dump=(/string|number|undefined|boolean/.test(typeof (_2df))||_2df==null)?_2df:recurse(_2df,typeof _2df,true);
$L.debug(dump,_2e0);
}
};
$X.invoke=function(_2e2,_2e3,_2e4,_2e5,_2e6){
return $X.invokeInternal(_2e2,_2e3,_2e4,_2e5,_2e6,false,null,null);
};
$X.invokeInternal=function(_2e7,_2e8,_2e9,_2ea,_2eb,_2ec,_2ed,_2ee){
var _2ef="method="+_2e8+"&_cf_ajaxproxytoken="+_2e9;
if(_2ec){
_2ef+="&_cfclient="+"true";
var _2f0=$X.JSON.encodeInternal(_2e7._variables,_2ec);
_2ef+="&_variables="+encodeURIComponent(_2f0);
var _2f1=$X.JSON.encodeInternal(_2e7._metadata,_2ec);
_2ef+="&_metadata="+encodeURIComponent(_2f1);
}
var _2f2=_2e7.returnFormat||"json";
_2ef+="&returnFormat="+_2f2;
if(_2e7.queryFormat){
_2ef+="&queryFormat="+_2e7.queryFormat;
}
if(_2e7.formId){
var _2f3=$C.getFormQueryString(_2e7.formId,true);
if(_2ea!=null){
for(prop in _2f3){
_2ea[prop]=_2f3[prop];
}
}else{
_2ea=_2f3;
}
_2e7.formId=null;
}
var _2f4="";
if(_2ea!=null){
_2f4=$X.JSON.encodeInternal(_2ea,_2ec);
_2ef+="&argumentCollection="+encodeURIComponent(_2f4);
}
$L.info("ajaxproxy.invoke.invoking","http",[_2e7.cfcPath,_2e8,_2f4]);
if(_2e7.callHandler){
_2e7.callHandler.call(null,_2e7.callHandlerParams,_2e7.cfcPath,_2ef);
return;
}
var _2f5;
var _2f6=_2e7.async;
if(_2ed!=null){
_2f6=true;
_2f5=function(req){
$X.callbackOp(req,_2e7,_2eb,_2ed,_2ee);
};
}else{
if(_2e7.async){
_2f5=function(req){
$X.callback(req,_2e7,_2eb);
};
}
}
var req=$A.sendMessage(_2e7.cfcPath,_2e7.httpMethod,_2ef,_2f6,_2f5,null,true);
if(!_2f6){
return $X.processResponse(req,_2e7);
}
};
$X.callback=function(req,_2fb,_2fc){
if($A.isRequestError(req)){
$C.handleError(_2fb.errorHandler,"ajaxproxy.invoke.error","http",[req.status,_2fb.cfcPath,req.statusText],req.status,req.statusText,false,_2fc);
}else{
if(_2fb.callbackHandler){
var _2fd=$X.processResponse(req,_2fb);
_2fb.callbackHandler(_2fd,_2fc);
}
}
};
$X.callbackOp=function(req,_2ff,_300,_301,_302){
if($A.isRequestError(req)){
var _303=_2ff.errorHandler;
if(_302!=null){
_303=_302;
}
$C.handleError(_303,"ajaxproxy.invoke.error","http",[req.status,_2ff.cfcPath,req.statusText],req.status,req.statusText,false,_300);
}else{
if(_301){
var _304=$X.processResponse(req,_2ff);
_301(_304,_300);
}
}
};
$X.processResponse=function(req,_306){
var _307=true;
for(var i=0;i<req.responseText.length;i++){
var c=req.responseText.charAt(i);
_307=(c==" "||c=="\n"||c=="\t"||c=="\r");
if(!_307){
break;
}
}
var _30a=(req.responseXML&&req.responseXML.childNodes.length>0);
var _30b=_30a?"[XML Document]":req.responseText;
$L.info("ajaxproxy.invoke.response","http",[_30b]);
var _30c;
var _30d=_306.returnFormat||"json";
if(_30d=="json"){
try{
_30c=_307?null:$X.JSON.decode(req.responseText);
}
catch(e){
if(typeof _306._metadata!=="undefined"&&_306._metadata.servercfc&&typeof req.responseText==="string"){
_30c=req.responseText;
}else{
throw e;
}
}
}else{
_30c=_30a?req.responseXML:(_307?null:req.responseText);
}
return _30c;
};
$X.init=function(_30e,_30f,_310){
if(typeof _310==="undefined"){
_310=false;
}
var _311=_30f;
if(!_310){
var _312=_30f.split(".");
var ns=self;
for(i=0;i<_312.length-1;i++){
if(_312[i].length){
ns[_312[i]]=ns[_312[i]]||{};
ns=ns[_312[i]];
}
}
var _314=_312[_312.length-1];
if(ns[_314]){
return ns[_314];
}
ns[_314]=function(){
this.httpMethod="GET";
this.async=false;
this.callbackHandler=null;
this.errorHandler=null;
this.formId=null;
};
_311=ns[_314].prototype;
}else{
_311.httpMethod="GET";
_311.async=false;
_311.callbackHandler=null;
_311.errorHandler=null;
_311.formId=null;
}
_311.cfcPath=_30e;
_311.setHTTPMethod=function(_315){
if(_315){
_315=_315.toUpperCase();
}
if(_315!="GET"&&_315!="POST"){
$C.handleError(null,"ajaxproxy.sethttpmethod.invalidmethod","http",[_315],null,null,true);
}
this.httpMethod=_315;
};
_311.setSyncMode=function(){
this.async=false;
};
_311.setAsyncMode=function(){
this.async=true;
};
_311.setCallbackHandler=function(fn){
this.callbackHandler=fn;
this.setAsyncMode();
};
_311.setErrorHandler=function(fn){
this.errorHandler=fn;
this.setAsyncMode();
};
_311.setForm=function(fn){
this.formId=fn;
};
_311.setQueryFormat=function(_319){
if(_319){
_319=_319.toLowerCase();
}
if(!_319||(_319!="column"&&_319!="row"&&_319!="struct")){
$C.handleError(null,"ajaxproxy.setqueryformat.invalidformat","http",[_319],null,null,true);
}
this.queryFormat=_319;
};
_311.setReturnFormat=function(_31a){
if(_31a){
_31a=_31a.toLowerCase();
}
if(!_31a||(_31a!="plain"&&_31a!="json"&&_31a!="wddx")){
$C.handleError(null,"ajaxproxy.setreturnformat.invalidformat","http",[_31a],null,null,true);
}
this.returnFormat=_31a;
};
$L.info("ajaxproxy.init.created","http",[_30e]);
if(_310){
return _311;
}else{
return ns[_314];
}
};
$U.isWhitespace=function(s){
var _31c=true;
for(var i=0;i<s.length;i++){
var c=s.charAt(i);
_31c=(c==" "||c=="\n"||c=="\t"||c=="\r");
if(!_31c){
break;
}
}
return _31c;
};
$U.getFirstNonWhitespaceIndex=function(s){
var _320=true;
for(var i=0;i<s.length;i++){
var c=s.charAt(i);
_320=(c==" "||c=="\n"||c=="\t"||c=="\r");
if(!_320){
break;
}
}
return i;
};
$C.trim=function(_323){
return _323.replace(/^\s+|\s+$/g,"");
};
$U.isInteger=function(n){
var _325=true;
if(typeof (n)=="number"){
_325=(n>=0);
}else{
for(i=0;i<n.length;i++){
if($U.isInteger.numberChars.indexOf(n.charAt(i))==-1){
_325=false;
break;
}
}
}
return _325;
};
$U.isInteger.numberChars="0123456789";
$U.isArray=function(a){
return (typeof (a.length)=="number"&&!a.toUpperCase);
};
$U.isBoolean=function(b){
if(b===true||b===false){
return true;
}else{
if(b.toLowerCase){
b=b.toLowerCase();
return (b==$U.isBoolean.trueChars||b==$U.isBoolean.falseChars);
}else{
return false;
}
}
};
$U.isBoolean.trueChars="true";
$U.isBoolean.falseChars="false";
$U.castBoolean=function(b){
if(b===true){
return true;
}else{
if(b===false){
return false;
}else{
if(b.toLowerCase){
b=b.toLowerCase();
if(b==$U.isBoolean.trueChars){
return true;
}else{
if(b==$U.isBoolean.falseChars){
return false;
}else{
return false;
}
}
}else{
return false;
}
}
}
};
$U.checkQuery=function(o){
var _32a=null;
if(o&&o.COLUMNS&&$U.isArray(o.COLUMNS)&&o.DATA&&$U.isArray(o.DATA)&&(o.DATA.length==0||(o.DATA.length>0&&$U.isArray(o.DATA[0])))){
_32a="row";
}else{
if(o&&o.COLUMNS&&$U.isArray(o.COLUMNS)&&o.ROWCOUNT&&$U.isInteger(o.ROWCOUNT)&&o.DATA){
_32a="col";
for(var i=0;i<o.COLUMNS.length;i++){
var _32c=o.DATA[o.COLUMNS[i]];
if(!_32c||!$U.isArray(_32c)){
_32a=null;
break;
}
}
}
}
return _32a;
};
$X.JSON=new function(){
var _32d={}.hasOwnProperty?true:false;
var _32e=/^("(\\.|[^"\\\n\r])*?"|[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t])+?$/;
var pad=function(n){
return n<10?"0"+n:n;
};
var m={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r","\"":"\\\"","\\":"\\\\"};
var _332=function(s){
if(/["\\\x00-\x1f]/.test(s)){
return "\""+s.replace(/([\x00-\x1f\\"])/g,function(a,b){
var c=m[b];
if(c){
return c;
}
c=b.charCodeAt();
return "\\u00"+Math.floor(c/16).toString(16)+(c%16).toString(16);
})+"\"";
}
return "\""+s+"\"";
};
var _337=function(o){
var a=["["],b,i,l=o.length,v;
for(i=0;i<l;i+=1){
v=o[i];
switch(typeof v){
case "undefined":
case "function":
case "unknown":
break;
default:
if(b){
a.push(",");
}
a.push(v===null?"null":$X.JSON.encode(v));
b=true;
}
}
a.push("]");
return a.join("");
};
var _33a=function(o){
return "\""+o.getFullYear()+"-"+pad(o.getMonth()+1)+"-"+pad(o.getDate())+"T"+pad(o.getHours())+":"+pad(o.getMinutes())+":"+pad(o.getSeconds())+"\"";
};
this.encode=function(o){
return this.encodeInternal(o,false);
};
this.encodeInternal=function(o,cfc){
if(typeof o=="undefined"||o===null){
return "null";
}else{
if(o instanceof Array){
return _337(o);
}else{
if(o instanceof Date){
if(cfc){
return this.encodeInternal({_date_:o.getTime()},cfc);
}
return _33a(o);
}else{
if(typeof o=="string"){
return _332(o);
}else{
if(typeof o=="number"){
return isFinite(o)?String(o):"null";
}else{
if(typeof o=="boolean"){
return String(o);
}else{
if(cfc&&typeof o=="object"&&typeof o._metadata!=="undefined"){
return "{\"_metadata\":"+this.encodeInternal(o._metadata,false)+",\"_variables\":"+this.encodeInternal(o._variables,cfc)+"}";
}else{
var a=["{"],b,i,v;
for(var i in o){
if(!_32d||o.hasOwnProperty(i)){
v=o[i];
switch(typeof v){
case "undefined":
case "function":
case "unknown":
break;
default:
if(b){
a.push(",");
}
a.push(this.encodeInternal(i,cfc),":",v===null?"null":this.encodeInternal(v,cfc));
b=true;
}
}
}
a.push("}");
return a.join("");
}
}
}
}
}
}
}
};
this.decode=function(json){
if(typeof json=="object"){
return json;
}
if($U.isWhitespace(json)){
return null;
}
var _342=$U.getFirstNonWhitespaceIndex(json);
if(_342>0){
json=json.slice(_342);
}
if(window._cf_jsonprefix&&json.indexOf(_cf_jsonprefix)==0){
json=json.slice(_cf_jsonprefix.length);
}
try{
if(_32e.test(json)){
return eval("("+json+")");
}
}
catch(e){
}
throw new SyntaxError("parseJSON");
};
}();
if(!$C.JSON){
$C.JSON={};
}
$C.JSON.encode=$X.JSON.encode;
$C.JSON.encodeInternal=$X.JSON.encodeInternal;
$C.JSON.decode=$X.JSON.decode;
$C.navigate=function(url,_344,_345,_346,_347,_348){
if(url==null){
$C.handleError(_346,"navigate.urlrequired","widget");
return;
}
if(_347){
_347=_347.toUpperCase();
if(_347!="GET"&&_347!="POST"){
$C.handleError(null,"navigate.invalidhttpmethod","http",[_347],null,null,true);
}
}else{
_347="GET";
}
var _349;
if(_348){
_349=$C.getFormQueryString(_348);
if(_349==-1){
$C.handleError(null,"navigate.formnotfound","http",[_348],null,null,true);
}
}
if(_344==null){
if(_349){
if(url.indexOf("?")==-1){
url+="?"+_349;
}else{
url+="&"+_349;
}
}
$L.info("navigate.towindow","widget",[url]);
window.location.replace(url);
return;
}
$L.info("navigate.tocontainer","widget",[url,_344]);
var obj=$C.objectCache[_344];
if(obj!=null){
if(typeof (obj._cf_body)!="undefined"&&obj._cf_body!=null){
_344=obj._cf_body;
}
}
$A.replaceHTML(_344,url,_347,_349,_345,_346);
};
$A.checkForm=function(_34b,_34c,_34d,_34e,_34f){
var _350=_34c.call(null,_34b);
if(_350==false){
return false;
}
var _351=$C.getFormQueryString(_34b);
$L.info("ajax.submitform.submitting","http",[_34b.name]);
$A.replaceHTML(_34d,_34b.action,_34b.method,_351,_34e,_34f);
return false;
};
$A.replaceHTML=function(_352,url,_354,_355,_356,_357){
var _358=document.getElementById(_352);
if(!_358){
$C.handleError(_357,"ajax.replacehtml.elnotfound","http",[_352]);
return;
}
var _359="_cf_containerId="+encodeURIComponent(_352);
_355=(_355)?_355+"&"+_359:_359;
$L.info("ajax.replacehtml.replacing","http",[_352,url,_355]);
if(_cf_loadingtexthtml){
try{
_358.innerHTML=_cf_loadingtexthtml;
}
catch(e){
}
}
var _35a=function(req,_35c){
var _35d=false;
if($A.isRequestError(req)){
$C.handleError(_357,"ajax.replacehtml.error","http",[req.status,_35c.id,req.statusText],req.status,req.statusText);
_35d=true;
}
var _35e=new $E.CustomEvent("onReplaceHTML",_35c);
var _35f=new $E.CustomEvent("onReplaceHTMLUser",_35c);
$E.loadEvents[_35c.id]={system:_35e,user:_35f};
if(req.responseText.search(/<script/i)!=-1){
try{
_35c.innerHTML="";
}
catch(e){
}
$A.replaceHTML.processResponseText(req.responseText,_35c,_357);
}else{
try{
_35c.innerHTML=req.responseText;
$A.updateLayouttab(_35c);
}
catch(e){
}
}
$E.loadEvents[_35c.id]=null;
_35e.fire();
_35e.unsubscribe();
_35f.fire();
_35f.unsubscribe();
$L.info("ajax.replacehtml.success","http",[_35c.id]);
if(_356&&!_35d){
_356();
}
};
try{
$A.sendMessage(url,_354,_355,true,_35a,_358);
}
catch(e){
try{
_358.innerHTML=$L.format(CFMessage["ajax.replacehtml.connectionerrordisplay"],[url,e]);
}
catch(e){
}
$C.handleError(_357,"ajax.replacehtml.connectionerror","http",[_352,url,e]);
}
};
$A.replaceHTML.processResponseText=function(text,_361,_362){
var pos=0;
var _364=0;
var _365=0;
_361._cf_innerHTML="";
while(pos<text.length){
var _366=text.indexOf("<s",pos);
if(_366==-1){
_366=text.indexOf("<S",pos);
}
if(_366==-1){
break;
}
pos=_366;
var _367=true;
var _368=$A.replaceHTML.processResponseText.scriptTagChars;
for(var i=1;i<_368.length;i++){
var _36a=pos+i+1;
if(_36a>text.length){
break;
}
var _36b=text.charAt(_36a);
if(_368[i][0]!=_36b&&_368[i][1]!=_36b){
pos+=i+1;
_367=false;
break;
}
}
if(!_367){
continue;
}
var _36c=text.substring(_364,pos);
if(_36c){
_361._cf_innerHTML+=_36c;
}
var _36d=text.indexOf(">",pos)+1;
if(_36d==0){
pos++;
continue;
}else{
pos+=7;
}
var _36e=_36d;
while(_36e<text.length&&_36e!=-1){
_36e=text.indexOf("</s",_36e);
if(_36e==-1){
_36e=text.indexOf("</S",_36e);
}
if(_36e!=-1){
_367=true;
for(var i=1;i<_368.length;i++){
var _36a=_36e+2+i;
if(_36a>text.length){
break;
}
var _36b=text.charAt(_36a);
if(_368[i][0]!=_36b&&_368[i][1]!=_36b){
_36e=_36a;
_367=false;
break;
}
}
if(_367){
break;
}
}
}
if(_36e!=-1){
var _36f=text.substring(_36d,_36e);
var _370=_36f.indexOf("<!--");
if(_370!=-1){
_36f=_36f.substring(_370+4);
}
var _371=_36f.lastIndexOf("//-->");
if(_371!=-1){
_36f=_36f.substring(0,_371-1);
}
if(_36f.indexOf("document.write")!=-1||_36f.indexOf("CF_RunContent")!=-1){
if(_36f.indexOf("CF_RunContent")!=-1){
_36f=_36f.replace("CF_RunContent","document.write");
}
_36f="var _cfDomNode = document.getElementById('"+_361.id+"'); var _cfBuffer='';"+"if (!document._cf_write)"+"{document._cf_write = document.write;"+"document.write = function(str){if (_cfBuffer!=null){_cfBuffer+=str;}else{document._cf_write(str);}};};"+_36f+";_cfDomNode._cf_innerHTML += _cfBuffer; _cfBuffer=null;";
}
try{
eval(_36f);
}
catch(ex){
$C.handleError(_362,"ajax.replacehtml.jserror","http",[_361.id,ex]);
}
}
_366=text.indexOf(">",_36e)+1;
if(_366==0){
_365=_36e+1;
break;
}
_365=_366;
pos=_366;
_364=_366;
}
if(_365<text.length-1){
var _36c=text.substring(_365,text.length);
if(_36c){
_361._cf_innerHTML+=_36c;
}
}
try{
_361.innerHTML=_361._cf_innerHTML;
$A.updateLayouttab(_361);
}
catch(e){
}
_361._cf_innerHTML="";
};
$A.updateLayouttab=function(_372){
var _373=_372.id;
if(_373.length>13&&_373.indexOf("cf_layoutarea")==0){
var s=_373.substr(13,_373.length);
var cmp=Ext.getCmp(s);
var _376=_372.innerHTML;
if(cmp){
cmp.update("<div id="+_372.id+">"+_372.innerHTML+"</div>");
}
var _377=document.getElementById(_373);
if(_377){
_377.innerHTML=_376;
}
}
};
$A.replaceHTML.processResponseText.scriptTagChars=[["s","S"],["c","C"],["r","R"],["i","I"],["p","P"],["t","T"]];
$D.getElement=function(_378,_379){
var _37a=function(_37b){
return (_37b.name==_378||_37b.id==_378);
};
var _37c=$D.getElementsBy(_37a,null,_379);
if(_37c.length==1){
return _37c[0];
}else{
return _37c;
}
};
$D.getElementsBy=function(_37d,tag,root){
tag=tag||"*";
var _380=[];
if(root){
root=$D.get(root);
if(!root){
return _380;
}
}else{
root=document;
}
var _381=root.getElementsByTagName(tag);
if(!_381.length&&(tag=="*"&&root.all)){
_381=root.all;
}
for(var i=0,len=_381.length;i<len;++i){
if(_37d(_381[i])){
_380[_380.length]=_381[i];
}
}
return _380;
};
$D.get=function(el){
if(!el){
return null;
}
if(typeof el!="string"&&!(el instanceof Array)){
return el;
}
if(typeof el=="string"){
return document.getElementById(el);
}else{
var _384=[];
for(var i=0,len=el.length;i<len;++i){
_384[_384.length]=$D.get(el[i]);
}
return _384;
}
return null;
};
$E.loadEvents={};
$E.CustomEvent=function(_386,_387){
return {name:_386,domNode:_387,subs:[],subscribe:function(func,_389){
var dup=false;
for(var i=0;i<this.subs.length;i++){
var sub=this.subs[i];
if(sub.f==func&&sub.p==_389){
dup=true;
break;
}
}
if(!dup){
this.subs.push({f:func,p:_389});
}
},fire:function(){
for(var i=0;i<this.subs.length;i++){
var sub=this.subs[i];
sub.f.call(null,this,sub.p);
}
},unsubscribe:function(){
this.subscribers=[];
}};
};
$E.windowLoadImpEvent=new $E.CustomEvent("cfWindowLoadImp");
$E.windowLoadEvent=new $E.CustomEvent("cfWindowLoad");
$E.windowLoadUserEvent=new $E.CustomEvent("cfWindowLoadUser");
$E.listeners=[];
$E.addListener=function(el,ev,fn,_392){
var l={el:el,ev:ev,fn:fn,params:_392};
$E.listeners.push(l);
var _394=function(e){
if(!e){
var e=window.event;
}
fn.call(null,e,_392);
};
if(el.addEventListener){
el.addEventListener(ev,_394,false);
return true;
}else{
if(el.attachEvent){
el.attachEvent("on"+ev,_394);
return true;
}else{
return false;
}
}
};
$E.isListener=function(el,ev,fn,_399){
var _39a=false;
var ls=$E.listeners;
for(var i=0;i<ls.length;i++){
if(ls[i].el==el&&ls[i].ev==ev&&ls[i].fn==fn&&ls[i].params==_399){
_39a=true;
break;
}
}
return _39a;
};
$E.callBindHandlers=function(id,_39e,ev){
var el=document.getElementById(id);
if(!el){
return;
}
var ls=$E.listeners;
for(var i=0;i<ls.length;i++){
if(ls[i].el==el&&ls[i].ev==ev&&ls[i].fn._cf_bindhandler){
ls[i].fn.call(null,null,ls[i].params);
}
}
};
$E.registerOnLoad=function(func,_3a4,_3a5,user){
if($E.registerOnLoad.windowLoaded){
if(_3a4&&_3a4._cf_containerId&&$E.loadEvents[_3a4._cf_containerId]){
if(user){
$E.loadEvents[_3a4._cf_containerId].user.subscribe(func,_3a4);
}else{
$E.loadEvents[_3a4._cf_containerId].system.subscribe(func,_3a4);
}
}else{
func.call(null,null,_3a4);
}
}else{
if(user){
$E.windowLoadUserEvent.subscribe(func,_3a4);
}else{
if(_3a5){
$E.windowLoadImpEvent.subscribe(func,_3a4);
}else{
$E.windowLoadEvent.subscribe(func,_3a4);
}
}
}
};
$E.registerOnLoad.windowLoaded=false;
$E.onWindowLoad=function(fn){
if(window.addEventListener){
window.addEventListener("load",fn,false);
}else{
if(window.attachEvent){
window.attachEvent("onload",fn);
}else{
if(document.getElementById){
window.onload=fn;
}
}
}
};
$C.addSpanToDom=function(){
var _3a8=document.createElement("span");
document.body.insertBefore(_3a8,document.body.firstChild);
};
$E.windowLoadHandler=function(e){
if(window.Ext){
Ext.BLANK_IMAGE_URL=_cf_ajaxscriptsrc+"/resources/ext/images/default/s.gif";
}
$C.addSpanToDom();
$L.init();
$E.registerOnLoad.windowLoaded=true;
$E.windowLoadImpEvent.fire();
$E.windowLoadImpEvent.unsubscribe();
$E.windowLoadEvent.fire();
$E.windowLoadEvent.unsubscribe();
if(window.Ext){
Ext.onReady(function(){
$E.windowLoadUserEvent.fire();
});
}else{
$E.windowLoadUserEvent.fire();
}
$E.windowLoadUserEvent.unsubscribe();
};
$E.onWindowLoad($E.windowLoadHandler);
$B.register=function(_3aa,_3ab,_3ac,_3ad){
for(var i=0;i<_3aa.length;i++){
var _3af=_3aa[i][0];
var _3b0=_3aa[i][1];
var _3b1=_3aa[i][2];
if(window[_3af]){
var _3b2=eval(_3af);
if(_3b2&&_3b2._cf_register){
_3b2._cf_register(_3b1,_3ac,_3ab);
continue;
}
}
var _3b3=$C.objectCache[_3af];
if(_3b3&&_3b3._cf_register){
_3b3._cf_register(_3b1,_3ac,_3ab);
continue;
}
var _3b4=$D.getElement(_3af,_3b0);
var _3b5=(_3b4&&((!_3b4.length&&_3b4.length!=0)||(_3b4.length&&_3b4.length>0)||_3b4.tagName=="SELECT"));
if(!_3b5){
$C.handleError(null,"bind.register.elnotfound","bind",[_3af]);
}
if(_3b4.length>1&&!_3b4.options){
for(var j=0;j<_3b4.length;j++){
$B.register.addListener(_3b4[j],_3b1,_3ac,_3ab);
}
}else{
$B.register.addListener(_3b4,_3b1,_3ac,_3ab);
}
}
if(!$C.bindHandlerCache[_3ab.bindTo]&&typeof (_3ab.bindTo)=="string"){
$C.bindHandlerCache[_3ab.bindTo]=function(){
_3ac.call(null,null,_3ab);
};
}
if(_3ad){
_3ac.call(null,null,_3ab);
}
};
$B.register.addListener=function(_3b7,_3b8,_3b9,_3ba){
if(!$E.isListener(_3b7,_3b8,_3b9,_3ba)){
$E.addListener(_3b7,_3b8,_3b9,_3ba);
}
};
$B.assignValue=function(_3bb,_3bc,_3bd,_3be){
if(!_3bb){
return;
}
if(_3bb.call){
_3bb.call(null,_3bd,_3be);
return;
}
var _3bf=$C.objectCache[_3bb];
if(_3bf&&_3bf._cf_setValue){
_3bf._cf_setValue(_3bd);
return;
}
var _3c0=document.getElementById(_3bb);
if(!_3c0){
$C.handleError(null,"bind.assignvalue.elnotfound","bind",[_3bb]);
}
if(_3c0.tagName=="SELECT"){
var _3c1=$U.checkQuery(_3bd);
var _3c2=$C.objectCache[_3bb];
if(_3c1){
if(!_3c2||(_3c2&&(!_3c2.valueCol||!_3c2.displayCol))){
$C.handleError(null,"bind.assignvalue.selboxmissingvaldisplay","bind",[_3bb]);
return;
}
}else{
if(typeof (_3bd.length)=="number"&&!_3bd.toUpperCase){
if(_3bd.length>0&&(typeof (_3bd[0].length)!="number"||_3bd[0].toUpperCase)){
$C.handleError(null,"bind.assignvalue.selboxerror","bind",[_3bb]);
return;
}
}else{
$C.handleError(null,"bind.assignvalue.selboxerror","bind",[_3bb]);
return;
}
}
_3c0.options.length=0;
var _3c3;
var _3c4=false;
if(_3c2){
_3c3=_3c2.selected;
if(_3c3&&_3c3.length>0){
_3c4=true;
}
}
if(!_3c1){
for(var i=0;i<_3bd.length;i++){
var opt=new Option(_3bd[i][1],_3bd[i][0]);
_3c0.options[i]=opt;
if(_3c4){
for(var j=0;j<_3c3.length;j++){
if(_3c3[j]==opt.value){
opt.selected=true;
}
}
}
}
}else{
if(_3c1=="col"){
var _3c8=_3bd.DATA[_3c2.valueCol];
var _3c9=_3bd.DATA[_3c2.displayCol];
if(!_3c8||!_3c9){
$C.handleError(null,"bind.assignvalue.selboxinvalidvaldisplay","bind",[_3bb]);
return;
}
for(var i=0;i<_3c8.length;i++){
var opt=new Option(_3c9[i],_3c8[i]);
_3c0.options[i]=opt;
if(_3c4){
for(var j=0;j<_3c3.length;j++){
if(_3c3[j]==opt.value){
opt.selected=true;
}
}
}
}
}else{
if(_3c1=="row"){
var _3ca=-1;
var _3cb=-1;
for(var i=0;i<_3bd.COLUMNS.length;i++){
var col=_3bd.COLUMNS[i];
if(col==_3c2.valueCol){
_3ca=i;
}
if(col==_3c2.displayCol){
_3cb=i;
}
if(_3ca!=-1&&_3cb!=-1){
break;
}
}
if(_3ca==-1||_3cb==-1){
$C.handleError(null,"bind.assignvalue.selboxinvalidvaldisplay","bind",[_3bb]);
return;
}
for(var i=0;i<_3bd.DATA.length;i++){
var opt=new Option(_3bd.DATA[i][_3cb],_3bd.DATA[i][_3ca]);
_3c0.options[i]=opt;
if(_3c4){
for(var j=0;j<_3c3.length;j++){
if(_3c3[j]==opt.value){
opt.selected=true;
}
}
}
}
}
}
}
}else{
_3c0[_3bc]=_3bd;
}
$E.callBindHandlers(_3bb,null,"change");
$L.info("bind.assignvalue.success","bind",[_3bd,_3bb,_3bc]);
};
$B.localBindHandler=function(e,_3ce){
var _3cf=document.getElementById(_3ce.bindTo);
var _3d0=$B.evaluateBindTemplate(_3ce,true);
$B.assignValue(_3ce.bindTo,_3ce.bindToAttr,_3d0);
};
$B.localBindHandler._cf_bindhandler=true;
$B.evaluateBindTemplate=function(_3d1,_3d2,_3d3,_3d4,_3d5){
var _3d6=_3d1.bindExpr;
var _3d7="";
if(typeof _3d5=="undefined"){
_3d5=false;
}
for(var i=0;i<_3d6.length;i++){
if(typeof (_3d6[i])=="object"){
var _3d9=null;
if(!_3d6[i].length||typeof _3d6[i][0]=="object"){
_3d9=$X.JSON.encode(_3d6[i]);
}else{
var _3d9=$B.getBindElementValue(_3d6[i][0],_3d6[i][1],_3d6[i][2],_3d2,_3d4);
if(_3d9==null){
if(_3d2){
_3d7="";
break;
}else{
_3d9="";
}
}
}
if(_3d3){
_3d9=encodeURIComponent(_3d9);
}
_3d7+=_3d9;
}else{
var _3da=_3d6[i];
if(_3d5==true&&i>0){
if(typeof (_3da)=="string"&&_3da.indexOf("&")!=0){
_3da=encodeURIComponent(_3da);
}
}
_3d7+=_3da;
}
}
return _3d7;
};
$B.jsBindHandler=function(e,_3dc){
var _3dd=_3dc.bindExpr;
var _3de=new Array();
var _3df=_3dc.callFunction+"(";
for(var i=0;i<_3dd.length;i++){
var _3e1;
if(typeof (_3dd[i])=="object"){
if(_3dd[i].length){
if(typeof _3dd[i][0]=="object"){
_3e1=_3dd[i];
}else{
_3e1=$B.getBindElementValue(_3dd[i][0],_3dd[i][1],_3dd[i][2],false);
}
}else{
_3e1=_3dd[i];
}
}else{
_3e1=_3dd[i];
}
if(i!=0){
_3df+=",";
}
_3de[i]=_3e1;
_3df+="'"+_3e1+"'";
}
_3df+=")";
var _3e2=_3dc.callFunction.apply(null,_3de);
$B.assignValue(_3dc.bindTo,_3dc.bindToAttr,_3e2,_3dc.bindToParams);
};
$B.jsBindHandler._cf_bindhandler=true;
$B.urlBindHandler=function(e,_3e4){
var _3e5=_3e4.bindTo;
if($C.objectCache[_3e5]&&$C.objectCache[_3e5]._cf_visible===false){
$C.objectCache[_3e5]._cf_dirtyview=true;
return;
}
var url=$B.evaluateBindTemplate(_3e4,false,true,false,true);
var _3e7=$U.extractReturnFormat(url);
if(_3e7==null||typeof _3e7=="undefined"){
_3e7="JSON";
}
if(_3e4.bindToAttr||typeof _3e4.bindTo=="undefined"||typeof _3e4.bindTo=="function"){
var _3e4={"bindTo":_3e4.bindTo,"bindToAttr":_3e4.bindToAttr,"bindToParams":_3e4.bindToParams,"errorHandler":_3e4.errorHandler,"url":url,returnFormat:_3e7};
try{
$A.sendMessage(url,"GET",null,true,$B.urlBindHandler.callback,_3e4);
}
catch(e){
$C.handleError(_3e4.errorHandler,"ajax.urlbindhandler.connectionerror","http",[url,e]);
}
}else{
$A.replaceHTML(_3e5,url,null,null,_3e4.callback,_3e4.errorHandler);
}
};
$B.urlBindHandler._cf_bindhandler=true;
$B.urlBindHandler.callback=function(req,_3e9){
if($A.isRequestError(req)){
$C.handleError(_3e9.errorHandler,"bind.urlbindhandler.httperror","http",[req.status,_3e9.url,req.statusText],req.status,req.statusText);
}else{
$L.info("bind.urlbindhandler.response","http",[req.responseText]);
var _3ea;
try{
if(_3e9.returnFormat==null||_3e9.returnFormat==="JSON"){
_3ea=$X.JSON.decode(req.responseText);
}else{
_3ea=req.responseText;
}
}
catch(e){
if(req.responseText!=null&&typeof req.responseText=="string"){
_3ea=req.responseText;
}else{
$C.handleError(_3e9.errorHandler,"bind.urlbindhandler.jsonerror","http",[req.responseText]);
}
}
$B.assignValue(_3e9.bindTo,_3e9.bindToAttr,_3ea,_3e9.bindToParams);
}
};
$A.initSelect=function(_3eb,_3ec,_3ed,_3ee){
$C.objectCache[_3eb]={"valueCol":_3ec,"displayCol":_3ed,selected:_3ee};
};
$S.setupSpry=function(){
if(typeof (Spry)!="undefined"&&Spry.Data){
Spry.Data.DataSet.prototype._cf_getAttribute=function(_3ef){
var val;
var row=this.getCurrentRow();
if(row){
val=row[_3ef];
}
return val;
};
Spry.Data.DataSet.prototype._cf_register=function(_3f2,_3f3,_3f4){
var obs={bindParams:_3f4};
obs.onCurrentRowChanged=function(){
_3f3.call(null,null,this.bindParams);
};
obs.onDataChanged=function(){
_3f3.call(null,null,this.bindParams);
};
this.addObserver(obs);
};
if(Spry.Debug.trace){
var _3f6=Spry.Debug.trace;
Spry.Debug.trace=function(str){
$L.info(str,"spry");
_3f6(str);
};
}
if(Spry.Debug.reportError){
var _3f8=Spry.Debug.reportError;
Spry.Debug.reportError=function(str){
$L.error(str,"spry");
_3f8(str);
};
}
$L.info("spry.setupcomplete","bind");
}
};
$E.registerOnLoad($S.setupSpry,null,true);
$S.bindHandler=function(_3fa,_3fb){
var url;
var _3fd="_cf_nodebug=true&_cf_nocache=true";
if(window._cf_clientid){
_3fd+="&_cf_clientid="+_cf_clientid;
}
var _3fe=window[_3fb.bindTo];
var _3ff=(typeof (_3fe)=="undefined");
if(_3fb.cfc){
var _400={};
var _401=_3fb.bindExpr;
for(var i=0;i<_401.length;i++){
var _403;
if(_401[i].length==2){
_403=_401[i][1];
}else{
_403=$B.getBindElementValue(_401[i][1],_401[i][2],_401[i][3],false,_3ff);
}
_400[_401[i][0]]=_403;
}
_400=$X.JSON.encode(_400);
_3fd+="&method="+_3fb.cfcFunction;
_3fd+="&argumentCollection="+encodeURIComponent(_400);
$L.info("spry.bindhandler.loadingcfc","http",[_3fb.bindTo,_3fb.cfc,_3fb.cfcFunction,_400]);
url=_3fb.cfc;
}else{
url=$B.evaluateBindTemplate(_3fb,false,true,_3ff);
$L.info("spry.bindhandler.loadingurl","http",[_3fb.bindTo,url]);
}
var _404=_3fb.options||{};
if((_3fe&&_3fe._cf_type=="json")||_3fb.dsType=="json"){
_3fd+="&returnformat=json";
}
if(_3fe){
if(_3fe.requestInfo.method=="GET"){
_404.method="GET";
if(url.indexOf("?")==-1){
url+="?"+_3fd;
}else{
url+="&"+_3fd;
}
}else{
_404.postData=_3fd;
_404.method="POST";
_3fe.setURL("");
}
_3fe.setURL(url,_404);
_3fe.loadData();
}else{
if(!_404.method||_404.method=="GET"){
if(url.indexOf("?")==-1){
url+="?"+_3fd;
}else{
url+="&"+_3fd;
}
}else{
_404.postData=_3fd;
_404.useCache=false;
}
var ds;
if(_3fb.dsType=="xml"){
ds=new Spry.Data.XMLDataSet(url,_3fb.xpath,_404);
}else{
ds=new Spry.Data.JSONDataSet(url,_404);
ds.preparseFunc=$S.preparseData;
}
ds._cf_type=_3fb.dsType;
var _406={onLoadError:function(req){
$C.handleError(_3fb.errorHandler,"spry.bindhandler.error","http",[_3fb.bindTo,req.url,req.requestInfo.postData]);
}};
ds.addObserver(_406);
window[_3fb.bindTo]=ds;
}
};
$S.bindHandler._cf_bindhandler=true;
$S.preparseData=function(ds,_409){
var _40a=$U.getFirstNonWhitespaceIndex(_409);
if(_40a>0){
_409=_409.slice(_40a);
}
if(window._cf_jsonprefix&&_409.indexOf(_cf_jsonprefix)==0){
_409=_409.slice(_cf_jsonprefix.length);
}
return _409;
};
$P.init=function(_40b){
$L.info("pod.init.creating","widget",[_40b]);
var _40c={};
_40c._cf_body=_40b+"_body";
$C.objectCache[_40b]=_40c;
};
$B.cfcBindHandler=function(e,_40e){
var _40f=(_40e.httpMethod)?_40e.httpMethod:"GET";
var _410={};
var _411=_40e.bindExpr;
for(var i=0;i<_411.length;i++){
var _413;
if(_411[i].length==2){
_413=_411[i][1];
}else{
_413=$B.getBindElementValue(_411[i][1],_411[i][2],_411[i][3],false);
}
_410[_411[i][0]]=_413;
}
var _414=function(_415,_416){
$B.assignValue(_416.bindTo,_416.bindToAttr,_415,_416.bindToParams);
};
var _417={"bindTo":_40e.bindTo,"bindToAttr":_40e.bindToAttr,"bindToParams":_40e.bindToParams};
var _418={"async":true,"cfcPath":_40e.cfc,"httpMethod":_40f,"callbackHandler":_414,"errorHandler":_40e.errorHandler};
if(_40e.proxyCallHandler){
_418.callHandler=_40e.proxyCallHandler;
_418.callHandlerParams=_40e;
}
$X.invoke(_418,_40e.cfcFunction,_40e._cf_ajaxproxytoken,_410,_417);
};
$B.cfcBindHandler._cf_bindhandler=true;
$U.extractReturnFormat=function(url){
var _41a;
var _41b=url.toUpperCase();
var _41c=_41b.indexOf("RETURNFORMAT");
if(_41c>0){
var _41d=_41b.indexOf("&",_41c+13);
if(_41d<0){
_41d=_41b.length;
}
_41a=_41b.substring(_41c+13,_41d);
}
return _41a;
};
$U.replaceAll=function(_41e,_41f,_420){
var _421=_41e.indexOf(_41f);
while(_421>-1){
_41e=_41e.replace(_41f,_420);
_421=_41e.indexOf(_41f);
}
return _41e;
};
$U.cloneObject=function(obj){
var _423={};
for(key in obj){
var _424=obj[key];
if(typeof _424=="object"){
_424=$U.cloneObject(_424);
}
_423.key=_424;
}
return _423;
};
$C.clone=function(obj,_426){
if(typeof (obj)!="object"){
return obj;
}
if(obj==null){
return obj;
}
var _427=new Object();
for(var i in obj){
if(_426===true){
_427[i]=$C.clone(obj[i]);
}else{
_427[i]=obj[i];
}
}
return _427;
};
$C.printObject=function(obj){
var str="";
for(key in obj){
str=str+"  "+key+"=";
value=obj[key];
if(typeof (value)=="object"){
value=$C.printObject(value);
}
str+=value;
}
return str;
};
}
}
cfinit();
