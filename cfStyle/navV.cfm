<cfsilent>
<!--- base reference for CF templater
<cfset test = {}>
<cfset test.a = application.util.CFCs.routing.getHTML("templates","listitem")> 
<cfset test.b = "asdf333">
--->

<!--- base reference for javascript
var navTemplate = {}
navTemplate.span = document.getElementById("span").innerHTML;
navTemplate.list = document.getElementById("listItem").innerHTML;
navTemplate.listUnordered = document.getElementById("listUnordered").innerHTML;

inside2 = { 
    TEMPLATE: navTemplate.listUnordered
    ,DATA: {
        TEXTNODE: ""
        ,ATTR: 'class=""'
        ,COMPILE: {
            LIST: [ 
                 { TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is something' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is something' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is something' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: '' ,TEXTNODE: 'this is something' } }
            ]
        } 
    }
};

navV = { 
    TEMPLATE: navTemplate.listUnordered
    ,DATA: {
        ATTR: ''
        ,TEXTNODE: ''
        ,COMPILE: {
            LIST: [ 
                { TEMPLATE: navTemplate.list ,DATA: { ATTR:'id="navV$training"', TEXTNODE:"Training [ + ]",COMPILE: { LIST: inside2} } }  
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: 'id="navV$training"' ,TEXTNODE: 'this is root 1' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: 'id="navV$training"' ,TEXTNODE: 'this is root 2' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: 'id="navV$training"' ,TEXTNODE: 'this is root 3' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: 'id="navV$training"' ,TEXTNODE: 'this is root 4' } }
                ,{ TEMPLATE: navTemplate.list ,DATA: { ATTR: 'id="navV$training"' ,TEXTNODE: 'this is root 5' } }
            ]
        } 
    }
};
--->
<cfparam name="request.dataF.navV" default=#{template:"",data:""}#>

<cfset listUnordered = application.util.CFCs.routing.getHTML("templates","listUnordered")>
<cfset listItem = application.util.CFCs.routing.getHTML("templates","listItem")>

<cfset request.dataF.navV.TEMPLATE = listUnordered>
<cfset request.dataF.navV.DATA = {}>
<cfset request.dataF.navV.DATA.COMPILE = {}>
<cfset request.dataF.navV.DATA.COMPILE.LIST = []>
<cfset ArrayAppend(request.dataF.navV.DATA.COMPILE.LIST,{ TEMPLATE:listItem ,DATA:{ATTR:'',TEXTNODE:'Training [ + ]' } })>

</cfsilent>
<cfoutput>
<div id="navV" class="navVPlaceHolder" onclick="Navbar.expandSubMenu(this,event)"> </div>
<script>
    var navV = #serializeJSON(request.dataF.navV)#
    document.getElementById("navV").innerHTML = Templater.compileTemplate(navV.TEMPLATE,navV.DATA)
</script>
</cfoutput>
