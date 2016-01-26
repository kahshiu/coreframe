<!---
<cfoutput>
    #application.util.CFCs.templater.compiler(request.dataF.links)#
</cfoutput>     
--->
<cfoutput>
<!--- 
<cfset test = {}>
<cfset test.a = "asdf">
<cfset test.b = "asdf333">
<cfdump var=#serializeJSON(test)#>
<cfabort>
--->


<div id="navV" class="navVPlaceHolder">
</div>

<style>
.navVPlaceHolder {
    position:absolute;
}
.navVPlaceHolder ul {
    position: relative; top:0em; right:0em;
    width:10em;
    list-style:none;
}
.navVPlaceHolder li {
    padding-left: 1em;
}
.navVPlaceHolder li>ul{
    display:none
}
.navVPlaceHolder li.expanded>ul{
    display:block
}
</style>

<script type="text/template" id="listUnordered">
<ul {{$data.ATTR}}> 
    {{$data.TEXTNODE}} 
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("LIST")?Templater.compileEach($data.COMPILE.LIST):""}} </ul>
</script>

<script type="text/template" id="listItem">
<li {{$data.ATTR}}> 
    {{$data.TEXTNODE}} 
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("SPAN")?Templater.compileTemplate($data.COMPILE.SPAN.TEMPLATE,$data.COMPILE.SPAN.DATA):""}}
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("LIST")?Templater.compileTemplate($data.COMPILE.LIST.TEMPLATE,$data.COMPILE.LIST.DATA):""}}
</li>
</script>

<script type="text/template" id="span">
<span {{$data.ATTR}}> {{$data.TEXTNODE}} {{$data.INNERHTML}} </span>
</script>

<script>
var navTemplate = {}
navTemplate.span = document.getElementById("span").innerHTML;
navTemplate.list = document.getElementById("listItem").innerHTML;
navTemplate.listUnordered = document.getElementById("listUnordered").innerHTML;

inside2 = { 
    template: navTemplate.listUnordered
    ,data: {
        textNode: ""
        ,attr: 'class=""'
        ,span: Templater.comp
        ,compile: {
            span: { template: navTemplate.span ,data: { attr:'id='+_.uniqueId("navH$") ,textNode:"[+]" } }
            ,list: [ 
                 { template: navTemplate.list ,data: { attr: '' ,textNode: 'this is something' } }
                ,{ template: navTemplate.list ,data: { attr: '' ,textNode: 'this is something' } }
                ,{ template: navTemplate.list ,data: { attr: '' ,textNode: 'this is something' } }
                ,{ template: navTemplate.list ,data: { attr: '' ,textNode: 'this is something' } }
            ]
        } 
    }
};
inside = { 
    template: navTemplate.listUnordered
    ,data: {
        textNode: ""
        ,attr: 'class=""'
        ,compile: {
            span: { template: navTemplate.span ,data: { attr:'id='+_.uniqueId("navH$") ,textNode:"[+]" } }
            ,list: [ 
                ,{ template: navTemplate.list ,data: { attr: '' ,textNode: 'this is something' } }
                ,{ template: navTemplate.list ,data: { attr: '' ,textNode: 'this is something' } }
                ,{ template: navTemplate.list ,data: { attr: '' ,textNode: 'this is something' } }
                ,{ template: navTemplate.list ,data: { attr: '' ,textNode: 'this is something' } }
            ]
        } 
    }
};
inside ={ 
    TEMPLATE: navTemplate.listUnordered
    ,DATA: {
        ATTR: ''
        ,TEXTNODE: ''
        ,COMPILE: {
            LIST: [ 
                { template: navTemplate.list ,data: { compile: { list: inside2
                        ,span: { template: navTemplate.span, data: { attr:'onclick="expandSubMenu(this)" id="navV$training"', textNode:"Training [ + ]" } }  
                        } } } 
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is level 1' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is level 1' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is level 1' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is level 1' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is level 1' } }
            ]
        } 
    }
};
navV ={ 
    TEMPLATE: navTemplate.listUnordered
    ,DATA: {
        ATTR: ''
        ,TEXTNODE: ''
        ,COMPILE: {
            LIST: [ 
                { TEMPLATE: navTemplate.list ,DATA: { COMPILE: { LIST: inside
                        ,SPAN: { TEMPLATE: navTemplate.span, DATA: { ATTR:'onclick="expandSubMenu(this)" id="navV$training"', TEXTNODE:"Training [ + ]" } }  
                        } } } 
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is root 1' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is root 2' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is root 3' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is root 4' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is root 5' } }
            ]
        } 
    }
};

document.getElementById("navV").innerHTML = Templater.compileTemplate(navV.TEMPLATE,navV.DATA)

function expandSubMenu(el){
    $(el.parentNode).hasClass("expanded")?
        $(el.parentNode).removeClass("expanded"):
        $(el.parentNode).addClass("expanded");
}


//TODO if no text node on UL then expand
</script>




</cfoutput>
