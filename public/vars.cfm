<cfset listUnordered = application.util.CFCs.routing.getHTML("templates","listUnordered")>
<cfset listItem = application.util.CFCs.routing.getHTML("templates","listItem")>
<cfset span = application.util.CFCs.routing.getHTML("templates","span")>

<!--- begin: config vertical nav --->
<cfset request.dataF.navV.TEMPLATE = listUnordered>
<cfset request.dataF.navV.DATA = {}>
<cfset request.dataF.navV.DATA.ATTR = ''>
<cfset request.dataF.navV.DATA.TEXTNODE = ''>
<cfset request.dataF.navV.DATA.COMPILE = {}>
<cfset request.dataF.navV.DATA.COMPILE.LIST = []>
<cfset ArrayAppend(request.dataF.navV.DATA.COMPILE.LIST ,{ TEMPLATE:listItem ,DATA:{ATTR:'class="pointer" id="starter"' ,COMPILE:{} ,TEXTNODE:'<a href="javascript:Navbar.writeURL2({route:''public.home''})">Starter Pack</a> [ + ]'  }})>

<cfset sp = {}>
<cfset sp.TEMPLATE = listUnordered>
<cfset sp.DATA = {}>
<cfset sp.DATA.ATTR = ''>
<cfset sp.DATA.TEXTNODE = ''>
<cfset sp.DATA.COMPILE = {}>
<cfset sp.DATA.COMPILE.LIST = []>
<cfset ArrayAppend(sp.DATA.COMPILE.LIST,{ TEMPLATE:listItem ,DATA:{ATTR:'class="pointer" id="starter$meara"',TEXTNODE:'<a href="javascript:Navbar.writeURL2({route:''public.mesra''})">Merimen Mesra</a>' } })>
<cfset ArrayAppend(sp.DATA.COMPILE.LIST,{ TEMPLATE:listItem ,DATA:{ATTR:'class="pointer" id="starter$training"',TEXTNODE:'<a href="javascript:Navbar.writeURL2({route:''public.training''})">Training Developers</a>' } })>

<cfset request.dataF.navV.DATA.COMPILE.LIST[1].DATA.COMPILE.LIST = sp> 
                                                   
<!--- begin: config breadcrumb --->
<cfset request.dataF.bread = {}>
<cfset request.dataF.bread.TEMPLATE = span>
<cfset request.dataF.bread.DATA = {}>
<cfset request.dataF.bread.DATA.TEXTNODE = "<a href='javascript:Navbar.writeURL2({route:""public.home""})'>Public</a>" >
<cfset request.dataF.bread.DATA.COMPILE = {}>


<!--- base reference for CF/javascript

<cfset ArrayAppend(request.dataF.navV.DATA.COMPILE.LIST ,{ TEMPLATE:listItem ,DATA:{ATTR:'' ,COMPILE:{} ,TEXTNODE: application.util.CFCs.templater.compiler({element:"a",attr:{"href":"www.google.com"},innerHTML:"Training"}) }})>

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
