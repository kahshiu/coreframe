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
        if(stopper1>stopper2) throw "Templater.getPlaceholders: Imbalanced interpolation signs";

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
// all validate functions should respect argument signature/ returns as below
// args:
// -- args1: value in question, 
// -- args2: optional params
// return: 
// -- passed: boolean result of validation,
// -- cleaned (optional): cleaned input after validation,
var Validate = Validate || {}

// validate: isData
// params: type: [Array,Boolean,Date,Function,Null,Number,Object,RegExp,String,Undefined]
Validate.isData = function (val,param) {
    param = param || {}
    if( Validate.isEmpty(param.type).passed ) throw "Validate.isData: param.type must be supplied";
    var flag = Util.getType(val)===param.type;
    return { passed: flag, cleaned:flag?val:"" }
}
// helper functions of isData
Validate.isBoolean   = function (val) { return Validate.isData(val,{type:"Boolean"}) }
Validate.isNumber    = function (val) { return Validate.isData(val,{type:"Number"}) }
Validate.isString    = function (val) { return Validate.isData(val,{type:"String"}) }
Validate.isUndefined = function (val) { return Validate.isData(val,{type:"Undefined"}) }
Validate.isNull      = function (val) { return Validate.isData(val,{type:"Null"}) }
Validate.isFunction  = function (val) { return Validate.isData(val,{type:"Function"}) }
Validate.isDate      = function (val) { return Validate.isData(val,{type:"Date"}) }
Validate.isRegExp    = function (val) { return Validate.isData(val,{type:"RegExp"}) }
Validate.isArray     = function (val) { return Validate.isData(val,{type:"Array"}) }
Validate.isObject    = function (val) { return Validate.isData(val,{type:"Object"}) }
Validate.isNumable   = function (val) { return { passed: !isNaN(+val) }; }
Validate.isEmpty     = function (val) { return { passed: val===undefined || val===null || val==="" }; }
Validate.isRequired  = function (val) { 
    var temp = false;
    if(Validate.isArray(val).passed) { 
        temp = (val.length > 0)
    } else if (Validate.isNumber(val).passed) { 
        temp = true;
    } else if (Validate.isString(val).passed) { 
        temp = val.length>0;
    }
    return { passed: temp }; 
}

// validate: isPattern
// param: regex, flags
Validate.isPattern = function (val,params) {
    params = params || {};
    params.flags = params.flags || "";

    if( Validate.isEmpty(val).passed || Validate.isEmpty(params.regex).passed ) return { passed:false, cleaned:"" };
    var flag = new RegExp(params.regex, params.flags).test(val);
    return { passed:flag, cleaned:flag?val:"" }
}

// TODO: implement API
Validate.isEmail = function (val,params) {}
Validate.isPhone = function (val,params) {}
// password complexity
Validate.isComplexity = function (val,params) {}

// validate: isTextDate
// param: regex
Validate.isTextDate = function (val,params) {
    params = params || {}
    params.regex = params.regex|| "\\d{1,2}[/-\\s]\\d{1,2}[/-\\s]\\d{4}";

    if( Validate.isEmpty(val).passed ) return { passed:false, cleaned:"" };
    return Validate.isPattern(val,params)
}
// validate: isDateWithin
// param: 
// -- regex for date,
// -- format for both lower/upper [dd/mm/yyyy],
// -- datepart [dd],
// -- lowerBound,upperBound,
// -- onLowerBound [true],onUpperBound [true]
// -- clean [String,Date]
// returns:
// -- { passed, cleaned } 
Validate.isDateWithin = function (val,params) {
    params = params || {};
    params.clean = params.clean || "String";
    params.onUpperBound = Validate.isEmpty(params.onUpperBound).passed?true: params.onUpperBound;
    params.onLowerBound = Validate.isEmpty(params.onLowerBound).passed?true: params.onLowerBound;

    var compare = {}, result = {}, temp, cleaned = {};
    compare.lower = true;
    compare.upper = true;

    if( !Validate.isTextDate(val,{regex:params.regex}).passed 
            || params.upperBound?!Validate.isTextDate(params.upperBound,{regex:params.regex}).passed: true 
            || params.upperBound?!Validate.isTextDate(params.lowerBound,{regex:params.regex}).passed: true
            ) return { passed:false, cleaned:"" };

    val = Util.toDateObj(val);
    params.upperBound = Util.toDateObj(params.upperBound);
    params.lowerBound = Util.toDateObj(params.lowerBound);
    if(!params.onUpperBound) params.upperBound.setDate(params.upperBound.getDate()-1);
    if(!params.onLowerBound) params.lowerBound.setDate(params.lowerBound.getDate()+1);

    if(params.upperBound) {
        temp = Util.dateCompare(params.datepart,val,params.upperBound)
        compare.upper = temp>=0;
        val = Util.setDateMin(params.datepart,val,params.upperBound,params.format);
    }
    if(params.lowerBound) {
        temp = Util.dateCompare(params.datepart,params.lowerBound,val)
        compare.lower = temp>=0;
        val = Util.setDateMax(params.datepart,val,params.lowerBound,params.format);
    }
    result.passed = compare.lower && compare.upper;
    result.cleaned = 
        params.clean=="Date"?val: 
        params.clean=="String"?Util.toDateText(val,params.format): "";
    return result;
}
// validate: isCurrency
// params:
// -- regex:Array/regex
// -- clean:[String,Number]
// returns:
// -- { passed, cleaned (String ONLY) }
Validate.isCurrency = function (val,params) {
    val = val.toString()
    params = params || {}
    params.regex = params.regex || [ 
            /^(?:(?:\d{1,3}(?:\,\d{3})*)|(?:\d+))(?:\.\d*)?$/
            ,/(^0$)|^(?:0\.(?:\d*)|(?:\.\d*))$/
        ]; 
    params.clean = params.clean || "String";

    var i,result = {},temp;
    result.passed = false;

    if(Validate.isRegExp(params.regex).passed) params.regex = [params.regex];

    for(i=0; i<params.regex.length; i++){
        if(result.passed) break;
        result.passed = params.regex[i].test(val);
    }
    if(params.clean=="String" || params.clean=="Number") {
        temp = Util.formatCurrency(val,2);
        result.cleaned = params.clean=="String"?temp.string:temp.num;
    } else {
        result.cleaned = "";
    }
    return result;
}
// validate: isNumWithin
// params:
// -- onMinNum
// -- onMaxNum
// -- minNum
// -- maxNum
// returns: passed, cleaned (Number ONLY)
Validate.isNumWithin = function (val,param) {
    var result = {passed:false, cleaned:'0'}
        ,temp = Validate.isCurrency(val,{clean:"Number"});
    if( !temp.passed ) return result;

    param.onMinNum = Validate.isEmpty(param.onMinNum).passed?true: param.onMinNum;
    param.onMaxNum = Validate.isEmpty(param.onMaxNum).passed?true: param.onMaxNum;
    param.minNum = param.onMinNum?param.minNum: (param.minNum+1);
    param.maxNum = param.onMaxNum?param.maxNum: (param.maxNum-1);

    result.passed = (param.minNum? (val>=param.minNum):true);
    result.passed = (param.maxNum? (val<=param.maxNum):true) && result.passed;
    result.cleaned = Util.setBounds(val,param.minNum,param.maxNum);
    return result;
}
// TODO:added support for array
Validate.isOption = function (val,param) {
    var result = {passed:false, cleaned:['4','1','2']};
    return result;
}

// validate: isStringWithin
// params:
// -- minLength
// -- maxLength
// returns: passed, cleaned (String ONLY)
Validate.isStringWithin = function (val,param) {
    var result = {passed:false,cleaned:val}; 
    param.minLength = param.minLength?param.minLength:0;
    param.maxLength = param.maxLength?param.maxLength:255;
    result.passed = val.length > param.minLength;
    result.passed = (val.length < param.maxLength) && result.passed;
    result.cleaned = val.substring(0,param.maxLength);
    return result;
}

// generate functions to validate elements
// generate obj with array of elements to hold result
// validation object

/******** Police **********/
function Police (config){
    var config = config || {};

    this.targetClassName = config.targetClassName||"";
    this.messageClassName = config.messageClassName||"alert danger";
    this.messageIdPrefix = config.messageIdPrefix||"validate$";
    this.template = config.template||'<div id="{{$data.messageId}}" class="{{$data.messageClassName}}"></div>';

    this.overallClassName = config.overallClassName||"alert danger";
    this.overallIdPrefix = config.overallIdPrefix||"overall$";
    this.overallTemplate = '<div id="{{$data.overallId}}" class="{{$data.overallClassName}}"></div>';

    this.message = "";
    this.messageBox = [];

    this.options;
    this.cleaned;
    this.isValid = true;
    this.isStopped = false;
    return this;
}
Police.prototype.templateFor = function (rule) {
    var messages = {};
    messages.isRequired = "{{$data.$options.$el.name}} is required.";
    messages.isPattern = "{{$data.$params.regexExample? 'Pattern required is '+$data.$params.regexExample:'Incorrect pattern'}}";
    messages.isTextDate = "Incorrect date supplied";
    messages.isDateWithin = "Date must be within {{$data.$params.lowerBound? ('min:'+Util.toDateText($data.$params.lowerBound)):''}} {{$data.$params.upperBound? ('max:'+Util.toDateText($data.$params.upperBound)):''}}";
    messages.isCurrency = "Incorrect currency supplied";
    messages.overall ="Invalid form fields. Please check."

    return messages[rule] || "";
}
// Police: reset variables
Police.prototype.using = function ($options,config) {
    config = config || {};
    this.message = "";
    if(config.resetMessages) this.resetMessageBox();

    this.options = $options || {};
    this.cleaned = undefined;
    this.isValid = true;
    this.isStopped = false;
    return this;
}
Police.prototype.appendMessage = function (message,delim) {
    message = message || "";
    delim = delim || "<br>";
    this.message = this.message + (this.message.length>0?delim:"") + message; 
}
Police.prototype.resetMessageBox = function () {
    this.messageBox = [];
}

// Police: enforce rules
// args:
// rule {name,value,params}
// $message String, message to display
// $options {$el-targeted element, $selected-selected element, $val-value of selected element, $els-choices of target,if any} 
Police.prototype.enforce = function (rule,$message,$options) {
    if( this.isStopped ) return this;

    rule = rule || {};
    rule.cleanedVal = rule.hasOwnProperty("cleanedVal")?rule.cleanedVal: true;
    rule.stopPropagation = rule.hasOwnProperty("stopPropagation")?rule.stopPropagation: true;
    rule.params = rule.params || {};

    var temp;

    if( !rule.name ) throw "Police.enforce: rule name is required";
    $message = $message || this.templateFor(rule.name);
    $options = $options || this.options;
    rule.val = rule.val || $options.$val || ""; // note: rule.val returns string value/ array/ TODO:callback fn?
    if( rule.cleanedVal && this.cleaned ) { rule.val = this.cleaned; } // enforce cleaned value to display

    // premature exit if not filled in: except isRequired
    if( Validate.isEmpty(rule.val).passed && rule.name!="isRequired") { 
        this.isValid = this.isValid && true;
        this.isStopped = true;
        return this; 
    }

    temp = Validate[rule.name](rule.val,rule.params);
    this.isValid = this.isValid && temp.passed; 
    this.cleaned = temp.hasOwnProperty("cleaned")?temp.cleaned: this.cleaned;

    if (!this.isValid) {
        this.writeCleaned($options);
        temp = Templater.compileTemplate($message,{ $options:$options, $params:rule.params });
        this.appendMessage(temp);
        this.messageBox.push(temp);
        this.isStopped = rule.stopPropagation;
    }
    return this;
}
// Police (helper): writeClean
// args:
// options (of element)
// params (unused as yet)
// TODO:input file,image
Police.prototype.writeCleaned = function (options,params) {
    var i=0,term;
    if(!this.cleaned) return;

    if( options.$els ) {
        // form control: select OR (input checkbox/ radio)
        if(options.$el.nodeName=="SELECT") { term = "selected";
        } else { term = "checked";
        }
        for( i=0;i<options.$els.length;i++ ) { 
            if( this.cleaned.indexOf(options.$els[i].value)>-1 ) {
                options.$els[i].setAttribute(term,"");
            }
        }
    } else {
        options.$el.value = this.cleaned;
    }
}
// TODO: implement API
//disable element
Police.prototype.disable = function (els,params) {
    // els can be array
    // el.disabled = el;

    return this;
}
// Police: implement validation on all form elements
// args:
// el: HTML element
Police.prototype.form = function (el) {
    if(el.nodeName!="FORM") return false; 

    var i,flag=true
        ,isSubmit
        ,formEls = $(el).find("input,select,textarea,button")
        ,overallId
        ,overallEl
    this.resetMessageBox();

    // loop validation for tags BUT submit,reset button: input(text,hidden,password,radio,checkbox,button),select,textarea,button 
    for(i=0;i<formEls.length;i++) {
        isSubmit=formEls[i].nodeName=="input" && (formEls[i].type=="submit" || formEls[i].type=="SUBMIT");
        // event: prevent default event
        if(isSubmit) { event.preventDefault(); }
        this.element(formEls[i]);
    }

    // render overall message
    if( !el.hasAttribute("overallId") ) {
        overallId = _.uniqueId(this.overallIdPrefix);
        el.setAttribute("overallId",overallId);
        $(el).prepend(
            Templater.compileTemplate( this.overallTemplate,{overallId:overallId,overallClassName:this.overallClassName} )
        );
    }
    overallEl = document.getElementById(el.getAttribute("overallId"));
    if(this.isValid) {
        overallEl.style.display = "none";
        overallEl.innerHTML = "";
    } else {
        overallEl.style.display = "block";
        overallEl.innerHTML = this.templateFor("overall");
    }
}
// TODO: implement API
//disable element
Police.prototype.disable = function (els,flag) {
    // els
    // el.disabled = el;

    return this;
}
// Police: implement validation form elements
// args:
// el: HTML element
Police.prototype.element = function (el) {
    var flag = true;

    var i,script = el.getAttribute("validate");
    if( Validate.isEmpty(script).passed ) return true; 
    script = script.trim();

    ( new Function ("$options",script) )( Util.getOptions(el) );
    flag = this.isValid;
    return flag;
}        
// Police: render element/ determine content
// args:
// $template: String, template for message element
// $data: obj, data to fuse into template
Police.prototype.render = function ($template,$data) {
    if( !(this.options && this.options.$el) ) return this;

    if( !this.options.$el.hasAttribute("validateId") ){
        $data = $data || {};
        $data.messageClassName = $data.messageClassName || this.messageClassName || "";
        $data.messageId = $data.messageId || _.uniqueId($data.messageIdPrefix||this.messageIdPrefix);
        this.options.$el.setAttribute("validateId",$data.messageId);
        $(this.options.$el.parentNode).append(
            Templater.compileTemplate( $template||this.template,$data ) 
        );
    }
    // write message
    var errorEl = document.getElementById(this.options.$el.getAttribute("validateId"));
    if(this.isValid){
        errorEl.style.display = "none";
        errorEl.innerHTML = "";
    } else {
        errorEl.style.display = "block";
        errorEl.innerHTML = this.message;
    }
    return this; 
}
// TODO: think about
//dependency on other fields
//unique constrain/ across fields

/******** Utilities ********/
var Util = Util || {}

// [object Array]  // [object Boolean]
// [object Date]   // [object Function]
// [object Null]   // [object Number]
// [object Object] // [object RegExp]
// [object String] // [object Undefined]
Util.getType = function (obj) {
    return Object.prototype.toString.call(obj).slice(8,-1);
}
// name: setBounds
// args:
// -- target: number in question
// -- minbase/ maxbase: left and right boundaries to restrict target in
// return: bounded number
// exmp:
// Util.setBounds(-4,1,10) --> 1
// Util.setBounds(15,1,10) --> 10
// Util.setBounds(6,1,10) --> 6
Util.setBounds = function (targetNum,minbase,maxbase){
    if(maxbase) targetNum = Math.min(targetNum,maxbase);
    if(minbase) targetNum = Math.max(targetNum,minbase);
    return targetNum;
}
// name: circShift
// args:
// -- array: array to shift,returns copy 
// -- motion: -ve:left, +ve:right
// return: copy of array shifted 
// exmp:
// Util.circShift([1,2,3,4,5,6],-2) --> [3, 4, 5, 6, 1, 2]
// Util.circShift([1,2,3,4,5,6],2) --> [5, 6, 1, 2, 3, 4]
Util.circShift = function (array,motion) {
    motion = motion || 0;
    if(motion==0) return array.slice(0);

    result = array.slice(0);
    for (var i=0;i<Math.abs(motion);i++) {
        if(motion<0) {
            result.push(result.shift());
        } else {
            result.unshift(result.pop());
        }
    }
    return result;
}
// name: padding
// args:
// -- target   : number, string to pad
// -- padCount : padding count
// -- mode     : padding pre/post of target [default: "pre"]
// -- padder   : character to pad with, [default: if number:"0", if string:"x" ]
// return:
// all padded result is string
// exmp:
// -- Util.padding(1000,2), result:1000
// -- Util.padding(10,4), result:0010
// -- Util.padding(10,4,"post","x"), result:10xx
Util.padding = function (target,padCount,mode,padder) {
    var padder = padder || (Validate.isString(target).passed?"x":"0")
        ,target = target.toString()
        , count = padCount
        , mode = mode || "pre"
        , pads = ""
        , result;
    if(target.length >= padCount) return target;
    while(count>0){ pads = pads+padder; count--; }
    if(mode == "pre") {
        result = (pads+target).slice(-1*padCount);
    } else {
        result = (target+pads).slice(0,padCount);
    }
    return result;
}
// name: padPattern
// padding target according to desired pattern
// args:
// -- target  : string
// -- pattern : string pattern in alphanumeric characters only, all symbols are delimiters
// -- mode    : pre/post padding
// -- padder  : standard padding char
// return:
// padded string
// exmp:
// Util.padPattern("1/1/1","000/000/00") --> "001/001/01"
// Util.padPattern("10000/1/1","000/000/00") --> "10000/001/01"
// Util.padPattern("10000/1/1","000/000") --> "10000/001/1"
// Util.padPattern("10000/1","000/000/00") --> "10000/001"
Util.padPattern = function (target,pattern,mode,padder) {
    if(Validate.isEmpty(target).passed || Validate.isEmpty(pattern).passed) return target;
    //TODO: reject if pattern not match

    var t={},p={},frag={}
        ,clength=1
        ,re=/[^a-zA-Z0-9]/ 
        ,result = target.slice(0);

    t.pos1 = 0; t.pos2 = 0; t.dpos = -1; t.dchr = "";
    p.pos1 = 0; p.pos2 = 0; p.dpos = -1; p.dchr = "";

    while( t.pos1<target.length && p.pos1<pattern.length ) {
        p.dpos = pattern.substring(p.pos1).search(re);
        p.dchr = pattern.charAt(p.dpos);
        p.pos2 = p.dpos>-1? (p.pos1+p.dpos):pattern.length;
        padLen = p.pos2 - p.pos1;

        t.dpos = target.substring(t.pos1).search(re);
        t.dchr = target.charAt(t.dpos);
        t.pos2 = t.dpos>-1? (t.pos1+t.dpos):target.length;

        frag.raw = target.substring(t.pos1,t.pos2);
        frag.padded = Util.padding(frag.raw,padLen,mode,Validate.isNumable(frag.raw).passed?"0":"x");

        target = target.substring(0,t.pos1) + frag.padded + target.substring(t.pos2)

        t.pos1 = t.pos1 + Math.max(frag.raw.length,frag.padded.length) + (t.dpos>-1?clength:0);
        p.pos1 = p.pos2 + (p.dpos>-1?clength:0);
    }

    return target;
}
// name: superImpose 
// extract data using pattern as mask
// args: 
// -- text    : data
// -- pattern : used as mask
// -- keys    : keys in mask
// return:
// collection of arrays with args.keys as key 
// exmp:
// Util.superImpose("12-rtme-2020","dd-cccc-yyyyy",["dd","cc","yyyy"]) -->
// dd: ["12"]
// cc: ["rt","me"]
// yyyy: ["2020"]
Util.superImpose = function (text,pattern,keys) {
    text = text.toString();
    var i,index,temp,result;
    temp = {};
    result = {};
    for(i=0; i<keys.length; i++){
        result[keys[i]] = [];
        index = 0;
        temp.text = text.substring(index);
        temp.pattern = pattern.substring(index);

        while (index>-1) {
            index = temp.pattern.search(keys[i]);
            if(index<0) break;

            result[keys[i]].push( temp.text.slice(index,index+keys[i].length) );
            index = index+keys[i].length; 
            temp.text = temp.text.substring(index);
            temp.pattern = temp.pattern.substring(index);
            if(temp.text.length==0||temp.pattern==0) break;
        }
    }
    return result;
}

// name: formatCurrency
// number formatted 
// args:
// -- val: String,Number
// -- decimal: decimal at the back 
// returns:
// formatted decimal string
Util.formatCurrency = function (val,decimal) {
    val = val.toString();
    val = parseFloat( val.replace(/[^0-9\.\-]/g,"") );
    if(isNaN(val)) return "";

    var length, pre, post, decimal = decimal || 2, rNum, rString;

    val = val.toFixed(decimal+4); // approximate precision to 4 decimals
    val = Math.round( val*Math.pow(10,decimal) ); // rounding of decimal digits 
    rNum = val/Math.pow(10,decimal);

    val = val.toString(); // prepare for string formatting
    pre = Util.padding(val.slice(0,-1*decimal),1,"pre","0");
    post = Util.padding(val.slice(-1*decimal),decimal,"post","0");
    length = pre.length;
    while(length>3) { 
        length = length-3; 
        pre = pre.slice(0,length) + "," + pre.slice(length); 
    };
    rString =  pre + "." + post; 
    return { string:rString, num:rNum };
}
// name: toDateText
// args:
// -- dateObj: js date obj 
// -- format: date formating (dd,mm,yy,yyyy) [default: "dd/mm/yyyy"]
// return:
// text representation of date obj
Util.toDateText = function (dateObj,format) {
    if(!Validate.isDate(dateObj).passed) return;
    var dd = Util.padding(dateObj.getDate(),2,undefined,"0")
        ,mm = Util.padding(dateObj.getMonth()+1,2,undefined,"0")
        ,yy = Util.padding(dateObj.getFullYear(),2,undefined,"0")
        ,yyyy = Util.padding(dateObj.getFullYear(),4,undefined,"0")
        ,format = format || "dd/mm/yyyy";
    return format.replace(/dd/g,dd).replace(/mm/g,mm).replace(/yyyy/g,yyyy).replace(/yy/g,yy);
}
// name: toDateObj
// args:
// -- datetext: date of text  
// -- format: format of datetext (dd,mm,yy,yyyy) [default: "dd/mm/yyyy"]
// return:
// js date obj of text representation
Util.toDateObj = function (dateText,format) {
    var year=""
        ,format = format || "dd/mm/yyyy"
        ,temp;
    temp = Util.padPattern(dateText,format,undefined,undefined);
    temp = Util.superImpose(temp,format,["dd","mm","yyyy","yy"]);
    if(temp.yyyy.length > 0) year=temp.yyyy[0];
    else if(temp.yy.length > 0) year=temp.yy[0];
    temp.mm[0] = parseInt(temp.mm[0]);
    temp.dd[0] = parseInt(temp.dd[0]);
    return new Date(year,temp.mm[0]-1,temp.dd[0]);
}
// name: distanceFromEpoch 
// args: 
// -- dateobj: js dateobj
// -- setting: object keys: firstDay (shift motion: -ve:left, +ve:right)
// return:
// obj with distance in yyyy,mm,ww,dd,hh,mi,ss,ms
Util.distanceFromEpoch = function (dateObj,setting) {
    setting = setting || {};
    setting.firstDay = setting.firstDay || 1;

    var epoch = new Date(1970,0,1)
    ,yyyy = dateObj.getFullYear()
    ,mm   = dateObj.getMonth()
    ,dd   = dateObj.getDate()
    ,day  = dateObj.getDay()
    ,time = dateObj.getTime()
    ,dayRedex = Util.circShift( [0,1,2,3,4,5,6],setting.firstDay ) 

    ,totalDaysInMonth = new Date(yyyy,mm+1,0).getDate()
    ,offsetDaysInWeek1 = (dayRedex[epoch.getDay()]-dayRedex[setting.firstDay])/7
    ,elapsedDaysInWeek = dayRedex[day]/7
    ,elapsedDaysInMonth = dd/totalDaysInMonth
    ,temp,temp2,temp3,epochRef = {};

    // lower/ upper bounds
    temp = time      ; epochRef["ms"] = [temp, temp, temp]                       ;
    temp = temp/1000 ; epochRef["ss"] = [Math.floor(temp), temp, Math.ceil(temp)];
    temp = temp/60   ; epochRef["mi"] = [Math.floor(temp), temp, Math.ceil(temp)];
    temp = temp/60   ; epochRef["hh"] = [Math.floor(temp), temp, Math.ceil(temp)];
    temp = temp/24   ; epochRef["dd"] = [Math.floor(temp), temp, Math.ceil(temp)];

    temp = yyyy - epoch.getFullYear() + (mm + elapsedDaysInMonth) /12;
    epochRef["yyyy"] = [Math.floor(temp), temp, Math.ceil(temp)];

    temp = ( yyyy - epoch.getFullYear() )*12 + mm + elapsedDaysInMonth
    epochRef["mm"] = [Math.floor(temp), temp, Math.ceil(temp)];

    temp = (time - epoch.getTime() + 1)/(7*24*60*60*1000) + offsetDaysInWeek1;
    temp2 = offsetDaysInWeek1<0?1:0;
    epochRef["ww"] = [Math.floor(temp) + temp2 , temp + temp2, Math.ceil(temp) + temp2 ];

    return epochRef
}
// name: dateDiff
// emulate TSQL datediff 
// args:
// -- datepart : compared datepart yyyy,mm,dd,ww.hh,mi,ss
// -- begin    : js date obj
// -- end      : js date obj
// return:
// return specified difference between 2 dates
Util.dateDiff = function (datepart,begin,end) {
    datepart = datepart || 'dd';
    var d1 = Util.distanceFromEpoch(begin) 
        ,d2 = Util.distanceFromEpoch(end)
        ,reversed=( begin.getTime() > end.getTime() );
    if(reversed) {
        result = d1[datepart][2] - d2[datepart][0];
        result = result * -1;
    } else {
        result = d2[datepart][2] - d1[datepart][0];
    }
    return result;
}
// name: dateCompare
// args: 
// -- datepart : datepart
// -- begin    : js date obj1
// -- end      : js date obj2
// return:
// begin < end, 1
// begin == end, 0
// begin > end, -1
Util.dateCompare = function (datepart,begin,end) {
    datepart = datepart || "dd"
    var d1 = Util.distanceFromEpoch(begin)
        ,d2 = Util.distanceFromEpoch(end)
        ,diff = d2[datepart][0] - d1[datepart][0]
    return diff<0?-1: diff>0?1: 0
}
// name: setDateBounds
// args: 
// -- datepart : datepart
// -- target   : target
// -- dtmin    : js date obj min boundary
// -- dtmax    : js date obj max boundary
// return:
// js date obj bounded within, choose boundaries if otherwise
Util.setDateBounds = function (datepart,target,dtmin,dtmax) {
    if(!Validate.isEmpty(dtmin).passed) target = Util.dateCompare(datepart,dtmin,target)<0?dtmin:target;
    if(!Validate.isEmpty(dtmax).passed) target = Util.dateCompare(datepart,target,dtmax)<0?dtmax:target;
    return target
}
// name: setDateMax
// if same choose dateText1
// args: 
// -- datepart : datepart
// -- date1    : js date obj
// -- date2    : js date obj
// return:
// max between js date object, compared based on datepart, if same choose date1
Util.setDateMax = function (datepart,date1,date2) {
    return Util.dateCompare(datepart,date1,date2)>0?date2:date1
}
// name: setDateMin
// args: 
// -- datepart : datepart
// -- date1    : js date obj
// -- date2    : js date obj
// return:
// min between js date object, compared based on datepart, if same choose date1
Util.setDateMin = function (datepart,date1,date2) {
    return Util.dateCompare(datepart,date1,date2)<0?date2:date1
}
// name: textDateDiff
// convenient helper to dateDiff
// args:
// -- datepart : compared datepart yyyy,mm,dd,ww.hh,mi,ss
// -- begin    : date text string
// -- end      : date text string
// exmp:
// Util.textDateDiff("dd","12/2/2015","24/2/2015") --> 12
Util.textDateDiff = function (datepart,begin,end,format) {
    begin = Util.toDateObj(begin,format);
    end = Util.toDateObj(end,format);
    return Util.dateDiff(datepart,begin,end);
}
Util.textDateCompare = function (datepart,begin,end,format) {
    begin = Util.toDateObj(begin,format);
    end = Util.toDateObj(end,format);
    return Util.dateCompare(datepart,begin,end);
}
Util.setTextDateBounds = function (datepart,target,dtmin,dtmax,format) {
    target = Util.toDateObj(target,format);
    if(!Validate.isEmpty(dtmin).passed) dtmin = Util.toDateObj(dtmin,format);
    if(!Validate.isEmpty(dtmax).passed) dtmax = Util.toDateObj(dtmax,format);
    return Util.setDateBounds(datepart,target,dtmin,dtmax);
}
Util.setTextDateMax = function (datepart,dateText1,dateText2,format) {
    d1 = Util.toDateObj(dateText1,format);
    d2 = Util.toDateObj(dateText2,format);
    return Util.toDateText( Util.setDateMax(datepart,d1,d2) );
}
Util.setTextDateMin = function (datepart,dateText1,dateText2,format) {
    d1 = Util.toDateObj(dateText1,format);
    d2 = Util.toDateObj(dateText2,format);
    return Util.toDateText( Util.setDateMin(datepart,d1,d2) );
}
// name: getOptions
// generate $options of form controls for further processing
Util.getOptions = function (el) {
    var choices,
        choicesType = 
        ( el.nodeName=="SELECT" || (el.nodeName=="INPUT" && (el.type=="checkbox"||el.type=="radio")) )? "multi":
        ( el.nodeName=="TEXTAREA" || (el.nodeName=="INPUT" && (el.type=="text"||el.type=="hidden"||el.type=="file")) )? "single":
        "none";

    // default for input: text,textarea,hidden,button,reset
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
            term=="selected"? $(el).find("option"): 
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
    return {$el:el,$selected:selectedEl,$val:selectedVal,$els:choices}
}
//TODO: step interval
// options:
// min
// max
// flag
Util.stepCount = function (interval,options) {
}


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

    // validation
    var temp = static$Police.element( this.bindTo );
    this.bindTo.value = static$Police.cleaned;
}
DatePicker.prototype.readTarget = function (dateText) {
    if( Validate.isTextDate(dateText).passed ){
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

/******** Genral Navigator */
var Navbar = {}
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
    if(Validate.isArray(navbarEls).passed){
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

/******** Tabs *************/
var Tab = {}
Tab.selectPage = function (el) {
    var $page,pageWrapper = el.parentNode;
    if(pageWrapper.className=="tabpages"){
        for(var i=0;i<pageWrapper.children.length;i++){
            $page = $(pageWrapper.children[i]);
            if(el==pageWrapper.children[i]){
                $page.addClass("selected")
            } else {
                $page.removeClass("selected")
            }
        }
    }
}
Tab.selectTab = function (el) {
    var $tab,tabsWrapper = el.parentNode;
    if(tabsWrapper.className=="tabs"){
        for(var i=0;i<tabsWrapper.children.length;i++){
            $tab = $(tabsWrapper.children[i]);
            if(el==tabsWrapper.children[i]){
                $tab.addClass("selected")
            } else {
                $tab.removeClass("selected")
            }
        }
    }
}
// decorators: select by using el reference
Tab.selectSinglePageByTab = function (el) {
    Tab.selectTab(el)
    Tab.selectPage(document.getElementById(el.getAttribute("pageId")))
}
// decorators: select by using el id
Tab.selectSinglePageByTabId = function (elId) {
    var el = document.getElementById(elId)
    if(el!=null) {
        Tab.selectSinglePageByTab(el)
    }
} 
Tab.decodeTabState = function (url) {
    var obj = Navbar.objectifyQString(url)
        ,delim
        ,keys = Object.keys(obj)
        ,key
        ,elIds;

    for(var i=0; i<keys.length; i++){
        delim = keys[i].indexOf("$");
        prefix = keys[i].slice(0,delim);
        if(prefix=="tabState"){
            elId = obj[keys[i]];
            Tab.selectSinglePageByTabId(elId)
        }
    }
}

// testing
    //todo:horizontal scroll vertical navigation
    // Tab.create = function (config) {
    //
    // }

//from sy
// from meri inside
