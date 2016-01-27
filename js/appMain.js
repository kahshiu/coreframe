/******** Templater ********/
var Templater = Templater || {};
Templater.getPlaceholders = function (template,config) {
    var config = config||{};
    config.interpolation = config.interpolation||["{{","}}"];

    var sumLength = config.interpolation.join("").length;
    var placeholders = [];
    var expressions = [];
    var stopper1 = 0;
    var stopper2 = 0;

    while(template.length>0) {
        stopper1 = template.search(config.interpolation[0]);
        stopper2 = template.search(config.interpolation[1])+config.interpolation[1].length;

        if(stopper1 == -1 || stopper2 == -2) break;;
        if(stopper1>stopper2) throw "Imbalanced interpolation signs";

        if( !(config.setting == 'strict' && stopper2-stopper1 == sumLength) ){
            placeholders.push(template.slice(stopper1,stopper2))
            expressions.push(
                template.slice(
                    stopper1+config.interpolation[0].length
                    ,stopper2-config.interpolation[1].length
                )
            );
        }
        template = template.slice(stopper2);
    }
    return { brac:placeholders,expr:expressions };
}
Templater.compileTemplate = function (template,$data,$index,$parent,$root){
    var i=0;
    var j=0;
    var hldr,frag="";
    var expr,expr0,expr1,expr1curr,expr1fn,expr1param1,expr1param2,expr1param3,expr1param4,expr1param5;

    //if(_.isArray($data)) {
    if(Object.prototype.toString.call( $data ) === '[object Array]') {
        //console.log($root)
        for(j=0;j<$data.length;j++){
            if($root === undefined) $root = $data;
            frag = frag + Templater.compileTemplate(template,$data[j],j,$parent,$root);
        }
    }else{
        hldr = Templater.getPlaceholders(template,{keys:true})
        frag = template.slice(0)
        $root = $root||$data
        for(i=0;i<hldr.brac.length;i++){
            expr = hldr.expr[i].split("|");
            expr0 = expr[0];
            expr1 = expr[1];

// evaluate expression
            val = (new Function(
                "$data"
                ,"$index"
                ,"$parent"
                ,"$root"
                ,'var result={{expr}};if(result===undefined || result===null) {result=""}; return result'.replace("{{expr}}",expr0)
            ))( $data,$index,$parent,$root );

// evaluate fn on expression
            if(expr1) {
                expr1 = expr1.split(",")
                for(m=0;m<expr1.length;m++){
                    expr1fn = expr1[m];
                    expr1param1 = val;
                    expr1param2 = $data;
                    expr1param3 = $index;
                    expr1param4 = $parent;
                    expr1param5 = $root;
                    val = (new Function (
                        "$val"
                        ,"$data"
                        ,"$index"
                        ,"$parent"
                        ,"$root"
                        ,'var result=window.{{expr}}($val,$data,$index,$parent,$root);if(result===undefined || result===null) {result=""}; return result'.replace("{{expr}}",expr1fn)
                    ))( expr1param1,expr1param2,expr1param3,expr1param4,expr1param5 );
                }
            }
            frag = frag.replace(hldr.brac[i],val);
        }
    }
    return frag;
}          
Templater.compileEach = function (arr){
    var i, total = "";
    for(i=0; i<arr.length; i++){
        total = total + Templater.compileTemplate(arr[i].TEMPLATE, arr[i].DATA);
    }
    return total;
}

/******** Validate ********/
var Validate = Validate || {}
Validate.isBoolean = function (obj) {
    return Object.prototype.toString.call(obj) === "[object Boolean]";
}
Validate.isNumber = function (obj) {
    return Object.prototype.toString.call(obj) === "[object Number]";
}
Validate.isString = function (obj) {
    return Object.prototype.toString.call(obj) === "[object String]";
}
Validate.isUndefined = function (obj) {
    return Object.prototype.toString.call(obj) === "[object Undefined]";
}
Validate.isNull = function (obj) {
    return Object.prototype.toString.call(obj) === "[object Null]";
}
Validate.isFunction = function (obj) {
    return Object.prototype.toString.call(obj) === "[object Function]";
}
Validate.isDate = function (obj) {
    return Object.prototype.toString.call(obj) === "[object Date]";
}
Validate.isRegExp = function (obj) {
    return Object.prototype.toString.call(obj) === "[object RegExp]";
}
Validate.isArray = function (obj) {
    return Object.prototype.toString.call(obj) === "[object Array]";
}
Validate.isObject = function (obj) {
    return Object.prototype.toString.call(obj) === "[object Object]";
}
Validate.isTextDateObj = function (obj) {
    //todo: validate text to date obj
    return true
}

//
Validate.isRequired = function (obj) {
    return obj!==undefined && obj!==null && ( Validate.isNumber(obj) || (Validate.isString(obj)&&obj.length>0) )
}
Validate.isLater = function (obj,bar,includeDay,format) {
    includeDay = includeDay || true
    obj = Util.toDateObj(obj,format)
    bar = Util.toDateObj(bar,format)
    return (includeDay && obj>=bar) || (!includeDay && obj>bar)
}
Validate.isEarlier = function (obj,bar,includeDay,format) {
    includeDay = includeDay || true;
    obj = Util.toDateObj(obj,format)
    bar = Util.toDateObj(bar,format)
    return (includeDay && obj<=bar) || (!includeDay && obj<bar)
}
//
Validate.isCurrency = function (obj) {
    var i,obj = obj.toString()
        ,result = false 
        ,pattern = [ 
            /^(?:(?:\d{1,3}(?:\,\d{3})*)|(?:\d+))(?:\.\d*)?$/
            ,/(^0$)|^(?:0\.(?:\d*)|(?:\.\d*))$/
        ]; 
    for(i=0; i<pattern.length; i++){
        if(result) break;
        result = pattern[i].test(obj);
    }
    return result;
}
Validate.element = function (el) {
    var flag;

    if(el.nodeName=="FORM") {
        // TODO: loop through validation for all form elements 
        flag = true;

    } else {
        // default for input: text,hidden,button,reset
        var i,script = el.getAttribute("validate").trim() || "";
        var choices,
            choicesType = 
            ( el.nodeName=="SELECT" || (el.nodeName=="INPUT" && (el.type=="checkbox"||el.type=="radio")) )? "multi":
            ( el.nodeName=="INPUT" && (el.type=="text"||el.type=="hidden"||el.type=="file") )? "single":
            "none";

        var selectedEl = el,
            selectedVal = el.value || el.innerHTML, 
            selectedValType = 
            ( el.nodeName=="SELECT" && (el.hasAttribute("multiple")||el.hasAttribute("MULTIPLE")) ) || ( el.nodeName=="INPUT" && el.type=="checkbox" )? "multi": 
            ( el.nodeName=="SELECT" && !(el.hasAttribute("multiple")||el.hasAttribute("MULTIPLE")) ) || ( el.nodeName=="INPUT" && el.type=="radio" )? "single":
            "none";

        var term = 
            el.nodeName=="SELECT"? "selected": 
            el.nodeName=="INPUT" && (el.type=="checkbox"||el.type=="radio")? "checked": 
            "none";

        if(choicesType == "multi") { 
            selectedEl = []; 
            selectedVal = [];
            choices = 
                term=="selected"? el.children: 
                term=="checked"? document.getElementsByName(el.name): 
                undefined;

            for(i=0; i<choices.length; i++){
                if( choices[i].selected || choices[i].checked ) {
                    selectedEl.push( choices[i] )
                    selectedVal.push( choices[i].value );

                    if( selectedValType == "single" ){
                        selectedEl = selectedEl[0];
                        selectedVal = selectedVal[0];
                        break;
                    }
                }
            } 
        }
        flag = script==""? true:( new Function ("$options",script) )( {$el:el,$selected:selectedEl,$val:selectedVal,$els:choices} );
    }
    return flag;
}        











// consider moving to util
Validate.cleanCurrency = function (obj,decimal) {
    var index, length, pre, post, decimal = decimal || 2, result = "";
    if(Validate.isCurrency(obj)){
        obj = parseFloat( obj.toString().replace(/\,/g,"") );              //normalise to int
        obj = Math.round( obj.toFixed(decimal+4)*Math.pow(10,decimal) ); //truncate with percision of additional 4 decimal points
        obj = obj.toString();

        if(obj == "0") { pre = "0"; post="00" }
        else {
            pre = obj.slice(0,obj.length-2);
            post = obj.slice(-2);
            length = pre.length;
            while(length>3) { length = length-3; pre = pre.slice(0,length) + "," + pre.slice(length); };
        }
        result =  pre + "." + post; 
    }
    return result;
}

// generate functions to validate elements
//generate obj with array of elements to hold result
// validation object

//Validator.
//required
//min
//max
//minlength
//max
//range no
//range date
//pattern
//email
//phone
//number (without symbols?)
//digits only
//step
//dependency on other fields
//password complexity
//unique constrain/ across fields

/******** Checker **********/
function Checker (config){
    var config = config || {};

    this.options
    this.msgClassName = config.msgClassName || "";
    this.elClassName = config.elClassName || "";
    this.errTemplate = config.template || '<div message class="{{$data.msgClassName}}" id="{{$data.msgId}}"></div>';
    this.errMessage = "";
    this.errMessages = [];
    this.defMessages = {}
    this.defMessages.isRequired = "{{$data.$el.id}} is required."

    this.flag = true;
    this.lazy = true; // stop with first flag of false
}
// checker: reset variables
Checker.prototype.using = function ($options) {
    this.options = $options || {};
    this.errMessage = "";
    this.errMessages = [];
    this.flag = true;
    return this;
}
// checker: enforce rules 
Checker.prototype.enforce = function (rule,params,$message,$options) {
    if (!this.flag && this.lazy) { return this; }

    $options = $options || this.options;
    this.flag = this.flag && (Validate.hasOwnProperty(rule)? Validate[rule]($options.$val):true); 
    this.registerMessage(rule,$message,$options);
    return this;
}
Checker.prototype.registerMessage = function (rule,$message,$options) {
    if (!this.flag) {
        var message = Templater.compileTemplate( $message||this.defMessages.hasOwnProperty(rule)?this.defMessages[rule]:"",$options);
        this.errMessage = message;
        this.errMessages.push(message);
    }
}
// checker: render element/ determine content
Checker.prototype.render = function (template,$data) {
    if( this.options && this.options.hasOwnProperty("$el") ) { 
        if(!this.options.$el.hasAttribute("validateId")){
            $data = $data || {};
            $data.msgClassName = 
                $data.msgClassName!==undefined 
                && $data.msgClassName!==null 
                && $data.msgClassName!==""? $data.msgClassName:
                this.msgClassName!==undefined 
                && this.msgClassName!==null 
                && this.msgClassName!==""? this.msgClassName: "";
            $data.msgId = 
                $data.msgId!==undefined 
                && $data.msgId!==null 
                && $data.msgId!==""? $data.msgId: _.uniqueId("validate$");
            this.options.$el.setAttribute("validateId",$data.msgId);

            $(this.options.$el.parentNode).append(
                Templater.compileTemplate( template||this.errTemplate,$data ) 
            );
        }
        //if(this.options.$el.nextElementSibling===null 
        //        || !this.options.$el.nextElementSibling.hasAttribute("message")
        //        ) {
        //    $data = $data || {};
        //    $data.msgClassName = 
        //        $data.msgClassName!==undefined 
        //        && $data.msgClassName!==null 
        //        && $data.msgClassName!==""? $data.msgClassName:
        //        this.msgClassName!==undefined 
        //        && this.msgClassName!==null 
        //        && this.msgClassName!==""? this.msgClassName: "";
        //    //this.options.parent.appendChild()

        //    $(this.options.$el).parent().append(
        //        Templater.compileTemplate( template||this.errTemplate,$data ) 
        //    );
        //}
        // write message
        var errorEl = document.getElementById(this.options.$el.getAttribute("validateId"))
        if(this.flag){
            // todo make this into class
            errorEl.style.display = "none";
            errorEl.innerHTML = "";
        } else {
            errorEl.style.display = "block";
            errorEl.innerHTML = this.errMessage;
        }
    }
    return this; 
}


/******** Utilities ********/
var Util = Util || {}
Util.dateDiff = function (datePart,startDate,endDate) {

}
Util.setRange = function (targetNum,minbase,maxbase){
    var temp;
    if(maxbase) temp = Math.min(targetNum,maxbase);
    if(minbase) temp = Math.max(targetNum,minbase);
    return temp;
}
Util.zeroPadding = function (targetNum,padCount,mode) {
    var targetNum = targetNum.toString(), count = padCount, padding = "", mode = mode || "pre", result;
    if(targetNum.length == padCount) return targetNum;
    while(count>0){ padding = padding+"0"; count--; }
    if(mode == "pre") {
        result = (padding+targetNum).slice(-1*padCount);
    } else {
        result = (targetNum+padding).slice(0,padCount);
    }
    return result;
}
Util.getImposed = function (text,pattern,keys) {
    var i,index,temp,result;
    temp = {};
    result = {};
    for(i=0; i<keys.length; i++){
        index = 0;
        result[keys[i]] = [];
        while (index>-1) {
            temp.text = text.substring(index);
            temp.pattern = pattern.substring(index);
            index = temp.pattern.search(keys[i]);
            if(index<0) break;
            result[keys[i]].push( temp.text.slice(index,index+keys[i].length) );
            index = index+keys[i].length; 
            if(index>=temp.pattern.length) break;
        }
    }
    return result;
}
Util.toDateText = function (dateObj,format) {
    if(!Validate.isDate(dateObj)) return;
    var dd = Util.zeroPadding(dateObj.getDate(),2)
        ,mm = Util.zeroPadding(dateObj.getMonth()+1,2)
        ,yy = Util.zeroPadding(dateObj.getFullYear(),2)
        ,yyyy = Util.zeroPadding(dateObj.getFullYear(),4)
        ,format = format || "dd/mm/yyyy";
    return format.replace(/dd/g,dd).replace(/mm/g,mm).replace(/yyyy/g,yyyy).replace(/yy/g,yy);
}
Util.toDateObj = function (dateText,format) {
    var year=""
        ,format = format || "dd/mm/yyyy"
        ,temp = Util.getImposed(dateText,format,["dd","mm","yyyy","yy"]);
    if(temp.yyyy.length > 0) year=temp.yyyy[0];
    else if(temp.yy.length > 0) year=temp.yy[0];
    return new Date(year,temp.mm[0]-1,temp.dd[0]);
}
Util.maxDate = function (dateObj1,dateObj2) {
    return ( dateObj1.getTime()<dateObj2.getTime() )? dateObj2: dateObj1;
}
Util.maxDateText = function (dateText1,dateText2,format) {
    return Util.maxDate(Util.toDateObj(dateText1,format),Util.toDateObj(dateText2,format));
}
/*Templater.compileTemplate = function (template,$data,$index,$parent,$root){
    var i=0;
    var j=0;
    var hldr,frag="";
    var expr,expr0,expr1,expr1curr,expr1fn,expr1param1,expr1param2,expr1param3,expr1param4,expr1param5;

    //if(_.isArray($data)) {
    if(Object.prototype.toString.call( $data ) === '[object Array]') {
        //console.log($root)
        for(j=0;j<$data.length;j++){
            if($root === undefined) $root = $data;
            frag = frag + Templater.compileTemplate(template,$data[j],j,$parent,$root);
        }
    }else{
        hldr = Templater.getPlaceholders(template,{keys:true})
        frag = template.slice(0)
        $root = $root||$data
        for(i=0;i<hldr.brac.length;i++){
            expr = hldr.expr[i].split("|");
            expr0 = expr[0];
            expr1 = expr[1];

// evaluate expression
            val = (new Function(
                "$data"
                ,"$index"
                ,"$parent"
                ,"$root"
                ,'var result={{expr}};if(result===undefined || result===null) {result=""}; return result'.replace("{{expr}}",expr0)
            ))( $data,$index,$parent,$root );

// evaluate fn on expression
            if(expr1) {
                expr1 = expr1.split(",")
                for(m=0;m<expr1.length;m++){
                    expr1fn = expr1[m];
                    expr1param1 = val;
                    expr1param2 = $data;
                    expr1param3 = $index;
                    expr1param4 = $parent;
                    expr1param5 = $root;
                    val = (new Function (
                        "$val"
                        ,"$data"
                        ,"$index"
                        ,"$parent"
                        ,"$root"
                        ,'var result=window.{{expr}}($val,$data,$index,$parent,$root);if(result===undefined || result===null) {result=""}; return result'.replace("{{expr}}",expr1fn)
                    ))( expr1param1,expr1param2,expr1param3,expr1param4,expr1param5 );
                }
            }
            frag = frag.replace(hldr.brac[i],val);
        }
    }
    return frag;
}          

Templater.compileEach = function (arr){
    var i, total = "";
    for(i=0; i<arr.length; i++){
    }
    return total;
}
*/

/******** DatePicker *******/
function DatePicker (templates) {
    // templates 
    templates = templates || {}
    this.datePickerHost      = templates.datePickerHost      || document.getElementById("tDatePicker$host").innerHTML;
    this.datePickerOptions   = templates.datePickerOptions   || document.getElementById("option").innerHTML;
    this.datePickerContainer = templates.datePickerContainer || document.getElementById("tDatePicker$payload").innerHTML;
    this.datePickerTable     = templates.datePickerTable     || document.getElementById("table").innerHTML;
    this.datePickerRow       = templates.datePickerRow       || document.getElementById("tableRow").innerHTML;
    this.datePickerCell      = templates.datePickerCell      || document.getElementById("tableCell").innerHTML;
    this.datePickerHeadCell  = templates.datePickerHeadCell  || document.getElementById("tableHeadCell").innerHTML;

    // state
    this.openNext = true;

    // generate host HTML
    this.hosts = [];
    this.renderHost();
} 
DatePicker.prototype.bindTarget = function (targetEl) {
    if( targetEl )
    {
        this.bindTo = targetEl
        if( targetEl.value == "" )
        {
            this.dateObj = new Date();
            //this.updateTarget();
        } else {
            this.readTarget(targetEl.value);
        }
    }
}
DatePicker.prototype.bindHost = function (targetEl) {
    if( targetEl ) {
        if(this.host && this.host != targetEl) {
            this.host.innerHTML = "";
            this.openNext = true;
        }
        this.host = targetEl;
    }
}
DatePicker.prototype.rebind = function (targetEl,hostEl) {
    if(targetEl && hostEl) {
        this.bindTarget(targetEl);
        this.bindHost(hostEl);
        if(this.openNext) {
            this.renderHTML();
        } else {
            this.host.innerHTML = "";
        }
        this.openNext = !this.openNext;
    }
}
DatePicker.prototype.updateTarget = function () {
    this.bindTo.value = Util.toDateText(this.dateObj);
    Validate.element(this.bindTo);
    if( this.bindTo.value != Util.toDateText(this.dateObj) ){ 
        this.readTarget(this.bindTo.value)
    }
}
DatePicker.prototype.readTarget = function (dateText) {
    if( Validate.isTextDateObj(dateText) ){
        this.dateObj = Util.toDateObj(dateText);
    } else {
        this.dateObj = new Date();
    }
}
DatePicker.prototype.pickToday = function (el,evt) {
    this.dateObj = new Date();
    this.renderHTML();
    this.updateTarget();
}
DatePicker.prototype.pickDate = function (el,evt) {
    if(evt.target.tagName == "TD")
    {
        var combined = evt.target.id.split("$")
        this.dateObj.setFullYear(combined[0]);
        this.dateObj.setMonth(combined[1]);
        this.dateObj.setDate(combined[2]);
        this.renderHTML();
        this.updateTarget();
    }
}
DatePicker.prototype.pickMonth = function (el,evt) {
    this.dateObj.setMonth( evt.target.value );
    this.renderHTML();
    this.updateTarget();
}
DatePicker.prototype.nudgeDate = function (el,evt,mode) {
    mode = mode || "plus";
    var currdd = this.dateObj.getDate()+(mode=="plus"?1:-1);
    this.dateObj.setDate(currdd);
    this.renderHTML();
    this.updateTarget();
}
DatePicker.prototype.nudgeMonth = function (el,evt,mode) {
    mode = mode || "plus"
    var currmm = this.dateObj.getMonth()+(mode=="plus"?1:-1)
    this.dateObj.setMonth(currmm);
    this.renderHTML();
    this.updateTarget();
}
DatePicker.prototype.nudgeYear = function (el,evt,mode) {
    mode = mode || "plus";
    var curryyyy = this.dateObj.getFullYear()+(mode=="plus"?1:-1);
    this.dateObj.setFullYear(curryyyy);
    this.renderHTML();
    this.updateTarget();
}
DatePicker.prototype.renderHost = function (){
    var temp = document.getElementsByClassName("DP");
    for(var i=0; i<temp.length; i++) {

        // generate and store host ids
        var hostId = "datePickerHost$"+Math.round( 1000*Math.random() )
            ,placeholderId = "datePickerPlaceholder$"+Math.round( 1000*Math.random() );
        var host = {
            TEMPLATE: this.datePickerHost
            ,DATA: {
                TARGETID: temp[i].id
                ,ATTRHOST:'class="datePickerHost"'
                ,HOSTID: hostId
                ,PLACEHOLDERID: placeholderId
            }
        };                             
        this.hosts.push(hostId);
        $(temp[i]).after( Templater.compileTemplate( host.TEMPLATE, host.DATA ) );
    }
    temp = null;
}
DatePicker.prototype.genWeekArray = function (today,startDay){
    var offset, rows=6, columns=7, wArr=[], cwArr, attrComb;

    if(startDay=="mon") offset = 1;
    else if(startDay=="tue") offset = 2;
    else if(startDay=="wed") offset = 3;
    else if(startDay=="thu") offset = 4;
    else if(startDay=="fri") offset = 5;
    else if(startDay=="sat") offset = 6;
    else {offset = 0;}

    var yyyy = today.getFullYear()
        , mm = today.getMonth()
        , firstDay = new Date(yyyy,mm,1).getDay()
        , dd = 1-(firstDay==0?7:firstDay)+offset
        , currDateObj
        , isCurrMonth;

    for(var j=0; j<rows; j++){
        cwArr=[];
        for(var i=0; i<columns; i++){
            currDateObj = new Date(yyyy,mm,dd);
            datediff = (100*currDateObj.getFullYear()) - (100*today.getFullYear()) + currDateObj.getMonth() - today.getMonth();
            attrComb = ['id="{{id}}"','class="{{class}}"'];
            attrComb[0] = attrComb[0]
                .replace("{{id}}",currDateObj.getFullYear()+"{{id}}")
                .replace("{{id}}","${{id}}")
                .replace("{{id}}",currDateObj.getMonth()+"{{id}}")
                .replace("{{id}}","${{id}}")
                .replace("{{id}}",currDateObj.getDate());
            attrComb[1] = attrComb[1]
                .replace("{{class}}",(datediff>0?"dpNext":datediff<0?"dpPrev":"dpCurr")+" {{class}}")
                .replace("{{class}}",currDateObj.getMonth()==today.getMonth() && currDateObj.getDate()==today.getDate()?"today":"");
            cwArr[i]={
                ATTR: attrComb.join(" ")
                ,INNERHTML: currDateObj.getDate()
            };
            dd++
        }
        wArr[j]=cwArr.slice(0);
    }
    return wArr; 
}
DatePicker.prototype.renderHTML = function (){
    var weeks = this.genWeekArray(this.dateObj,"mon")
    var datePicker = {
        TEMPLATE: this.datePickerContainer
        ,DATA:{
            ATTR:'class="datePicker"'
            ,ATTRYEAR:'class="year"'
            ,ATTRCAL :'class="nudgeContainer"'
            ,ATTRYY  :'class="nudgeContainer"'
            ,ATTRMM  :'class="nudgeContainer"'
            ,ATTRDD  :'class="nudgeContainer"'
            ,ATTRYYLA:'class="nudger" onclick=static$DP.nudgeYear(this,event,"minus")'
            ,ATTRYYRA:'class="nudger" onclick=static$DP.nudgeYear(this,event)'
            ,ATTRMMLA:'class="nudger" onclick=static$DP.nudgeMonth(this,event,"minus")'
            ,ATTRMMRA:'class="nudger" onclick=static$DP.nudgeMonth(this,event)'
            ,ATTRDDLA:'class="nudger" onclick=static$DP.nudgeDate(this,event,"minus")'
            ,ATTRDDRA:'class="nudger" onclick=static$DP.nudgeDate(this,event)'
            ,YEAR:this.dateObj.getFullYear()
            ,MONTH: [
                 { TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=0"  ,INNERHTML: "Jan"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=1"  ,INNERHTML: "Feb"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=2"  ,INNERHTML: "Mar"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=3"  ,INNERHTML: "Apr"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=4"  ,INNERHTML: "May"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=5"  ,INNERHTML: "Jun"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=6"  ,INNERHTML: "Jul"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=7"  ,INNERHTML: "Aug"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=8"  ,INNERHTML: "Sep"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=9"  ,INNERHTML: "Oct"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=10" ,INNERHTML: "Nov"} }
                ,{ TEMPLATE: this.datePickerOptions ,DATA: { ATTR:"value=11" ,INNERHTML: "Dec"} }
            ]
            ,DATE:this.dateObj.getDate()
            ,COMPILE: {
                CALENDAR:{
                    TEMPLATE: this.datePickerTable
                    ,DATA: {
                        ATTR:'onclick=static$DP.pickDate(this,event)'
                        ,COMPILE: {
                            HEADROWS: [
                                 { TEMPLATE: this.datePickerRow ,DATA: { COMPILE: { TEMPLATE: this.datePickerHeadCell ,DATA: [
                                         {ATTR:"" ,INNERHTML:"Mon"}
                                        ,{ATTR:"" ,INNERHTML:"Tue"}
                                        ,{ATTR:"" ,INNERHTML:"Wed"}
                                        ,{ATTR:"" ,INNERHTML:"Thu"}
                                        ,{ATTR:"" ,INNERHTML:"Fri"}
                                        ,{ATTR:"" ,INNERHTML:"Sat"}
                                        ,{ATTR:"" ,INNERHTML:"Sun"}
                                    ] } } }
                            ]
                            ,BODYROWS: [
                                 { TEMPLATE: this.datePickerRow ,DATA: { COMPILE: { TEMPLATE: this.datePickerCell ,DATA: weeks[0] } } }
                                ,{ TEMPLATE: this.datePickerRow ,DATA: { COMPILE: { TEMPLATE: this.datePickerCell ,DATA: weeks[1] } } }
                                ,{ TEMPLATE: this.datePickerRow ,DATA: { COMPILE: { TEMPLATE: this.datePickerCell ,DATA: weeks[2] } } }
                                ,{ TEMPLATE: this.datePickerRow ,DATA: { COMPILE: { TEMPLATE: this.datePickerCell ,DATA: weeks[3] } } }
                                ,{ TEMPLATE: this.datePickerRow ,DATA: { COMPILE: { TEMPLATE: this.datePickerCell ,DATA: weeks[4] } } }
                                ,{ TEMPLATE: this.datePickerRow ,DATA: { COMPILE: { TEMPLATE: this.datePickerCell ,DATA: weeks[5] } } }
                            ]
                        }
                    }
                }                 
            }
        }
    }      
    datePicker.DATA.MONTH[this.dateObj.getMonth()].DATA.ATTR += " selected";
    this.host.innerHTML = Templater.compileTemplate( datePicker.TEMPLATE, datePicker.DATA );
}

Navbar = {}
Navbar.objectifyQString = function (url) {
    var url = url || window.location.href
        ,qString = {} 
        ,delimPos 
        ,arr = url.slice(url.indexOf("?")+1).split("&");

    for(var i=0;i<arr.length;i++){
        delimPos = arr[i].indexOf("=");
        qString[ arr[i].slice(0,delimPos) ] = arr[i].slice(delimPos+1)
    }

    return qString
}
Navbar.stringifyQString = function (obj) {
    var total = [];
    for(var key in obj){
        total.push( key+"="+obj[key] );
    }
    return total.join("&");
}

Navbar.encodeSubmenuState = function (navbarEls) {
    var full="",key,value;
    if(Validate.isArray(navbarEls)){
        for(var i=0;i<navbarEls.length;i++){
            full=full+Navbar.encodeSubmenuState(navbarEls[i]);
        }
    } else {
        key = "state${{elId}}=".replace("{{elId}}",navbarEls.id) ,value = [];
        $(navbarEls).find(".expanded").each(function(index,element){
            value.push(element.id);
        })
        full = key+value.join("|");
    }
    return full;
} 
Navbar.decodeSubmenuState = function (url) {
    var obj = Navbar.objectifyQString(url)
        ,delim
        ,keys = Object.keys(obj)
        ,key
        ,elIds;

    for(var i=0; i<keys.length; i++){
        delim = keys[i].indexOf("$");
        prefix = keys[i].slice(0,delim);
        if(prefix=="state"){
            elIds = obj[keys[i]].split("|");
            for(var j=0; j<elIds.length; j++){
                $(document.getElementById(elIds[j])).addClass("expanded")
            }
        }
    }
} 

Navbar.writeURL = function (qstring) {
    var urlTemplate = "{{$data.hostname}}{{$data.subdir}}index.cfm?{{$data.qstring}}&{{$data.urltoken}}", urlData = {};
    urlData.hostname = window.request.hostname;
    urlData.subdir = window.request.subdir;
    urlData.qstring = qstring;
    urlData.urltoken = window.request.urltoken;
    return Templater.compileTemplate(urlTemplate,urlData);
} 

Navbar.writeURL2 = function (qstring) {
    window.location = Navbar.writeURL( 
            [Navbar.stringifyQString(qstring),Navbar.encodeSubmenuState(request.navbars)].join("&")
            );
}

Navbar.expandSubmenu = function (el,evt) {
    if(evt.target.nodeName=="LI" 
        && evt.target.children.length>0 
        && evt.target.children[evt.target.children.length-1].nodeName=="UL")
    {
        var $el = $(evt.target);
        $el.hasClass("expanded")? $el.removeClass("expanded"): $el.addClass("expanded");
    }
}
