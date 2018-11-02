/*ADOBE SYSTEMS INCORPORATED
Copyright 2012 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.*/
ColdFusion.RichText||(ColdFusion.RichText={});
ColdFusion.RichText.editorState={};
ColdFusion.RichText.buffer=null;
ColdFusion.RichText.registerAfterSet=function(_79e){
if(ColdFusion.RichText.editorState[_79e]){
var _79f=function(){
ColdFusion.RichText.fireChangeEvent(_79e);
};
var _7a0=CKEDITOR.instances[_79e];
_7a0.on("OnAfterSetHTML",_79f);
}else{
setTimeout("ColdFusion.RichText.registerAfterSet('"+_79e+"')",1000);
}
};
ColdFusion.RichText.getEditorObject=function(_7a1){
if(!_7a1){
ColdFusion.handleError(null,"richtext.geteditorobject.missingtextareaname","widget",null,null,null,true);
return;
}
var _7a2=ColdFusion.objectCache[_7a1];
if(_7a2==null||CKEDITOR.editor.prototype.isPrototypeOf(_7a2)==false){
ColdFusion.handleError(null,"richtext.geteditorobject.notfound","widget",[_7a1],null,null,true);
return;
}
return CKEDITOR.instances[_7a2.richtextid];
};
ColdFusion.RichText.setValue=function(_7a3,_7a4){
if(ColdFusion.RichText.editorState[_7a3]){
var _7a5=CKEDITOR.instances[_7a3];
_7a5.setData(_7a4);
_7a5.fire("onAfterSetHTML");
}else{
setTimeout("ColdFusion.RichText.setValue(\""+_7a3+"\",\""+_7a4+"\")",1000);
}
};
ColdFusion.RichText.getValue=function(_7a6){
if(ColdFusion.RichText.editorState[_7a6]){
return CKEDITOR.instances[_7a6].getData();
}else{
ColdFusion.Log.error("richtext.initialize.getvalue.notready","widget",[_7a6]);
return null;
}
};
ColdFusion.RichText.fireChangeEvent=function(_7a7){
var _7a8=ColdFusion.objectCache[_7a7];
ColdFusion.Log.info("richtext.firechangeevent.firechange","widget",[_7a8._cf_name]);
var _7a9=document.getElementById(_7a7);
if(_7a9){
if(_7a9.fireEvent){
_7a9.fireEvent("onchange");
}
if(document.createEvent){
var evt=document.createEvent("HTMLEvents");
if(evt.initEvent){
evt.initEvent("change",true,true);
}
if(_7a9.dispatchEvent){
_7a9.dispatchEvent(evt);
}
}
}
ColdFusion.Event.callBindHandlers(_7a7,null,"change");
};
ColdFusion.RichText.editor_onfocus=function(e){
document.getElementById(e.editor.id+"_top").style.display="block";
};
ColdFusion.RichText.editor_onblur=function(e){
document.getElementById(e.editor.id+"_top").style.display="none";
};
ColdFusion.RichText.setChangeBuffer=function(e){
ColdFusion.RichText.buffer=CKEDITOR.instances[e.editor.name].getData();
};
ColdFusion.RichText.resetChangeBuffer=function(e){
if(ColdFusion.RichText.buffer!=CKEDITOR.instances[e.editor.name].getData()){
ColdFusion.RichText.fireChangeEvent(e.editor.name);
}
ColdFusion.RichText.buffer=null;
};
var parameters={};
CKEDITOR.on("instanceCreated",function(e){
var _7b0=e.editor.name;
if(parameters[_7b0].Id){
ColdFusion.RichText.editorState[parameters[_7b0].Id]=false;
e.editor.richtextid=parameters[_7b0].Id;
ColdFusion.objectCache[parameters[_7b0].Id]=e.editor;
}
if(parameters[_7b0].Name){
e.editor._cf_name=parameters[_7b0].Name;
ColdFusion.objectCache[parameters[_7b0].Name]=e.editor;
}
if(parameters[_7b0].Val){
e.editor.Value=parameters[_7b0].Val;
}
e.editor._cf_setValue=function(_7b1){
ColdFusion.RichText.setValue(_7b0,_7b1);
};
e.editor._cf_getAttribute=function(){
return ColdFusion.RichText.getValue(_7b0);
};
e.editor._cf_register=function(_7b2,_7b3,_7b4){
var _7b5=document.getElementById(_7b0);
if(_7b5){
ColdFusion.Event.addListener(_7b5,_7b2,_7b3,_7b4);
}
};
});
ColdFusion.RichText.initialize=function(Id,Name,Val,_7b9,_7ba,_7bb,_7bc,_7bd,_7be,Skin,_7c0,_7c1,_7c2,_7c3,_7c4){
parameters[Id]={};
parameters[Id].Id=Id;
parameters[Id].Name=Name;
parameters[Id].Val=Val;
var _7c5=function(evt){
if(_7c0==true){
evt.editor.on("focus",ColdFusion.RichText.editor_onfocus);
evt.editor.on("blur",ColdFusion.RichText.editor_onblur);
document.getElementById(evt.editor.id+"_top").style.display="none";
}
evt.editor.on("focus",ColdFusion.RichText.setChangeBuffer);
evt.editor.on("blur",ColdFusion.RichText.resetChangeBuffer);
ColdFusion.RichText.editorState[evt.editor.name]=true;
if(ColdFusion.RichText.OnComplete){
ColdFusion.RichText.OnComplete(evt.editor);
}
};
var _7c7={on:{"instanceReady":_7c5}};
_7c7["toolbar"]="Default";
if(_7bb!=null){
_7c7["height"]=_7bb;
}
if(_7ba!=null){
_7c7["width"]=_7ba;
}
if(_7bc!=null){
_7c7["font_names"]=_7bc;
}
if(_7bd!=null){
_7c7["fontSize_sizes"]=_7bd;
}
if(_7be!=null){
_7c7["format_tags"]=_7be;
}
if(Skin!=null){
_7c7["skin"]=Skin;
}
if(_7c0==true){
_7c7["toolbarCanCollapse"]=false;
}
if(_7c1!=null){
_7c7["toolbar"]=_7c1;
}
var _7c8=CKEDITOR.replace(Id,_7c7);
};
