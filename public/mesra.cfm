<cfsilent>
    <cfset span = application.util.CFCs.routing.getHTML("templates","span")>
    <cfset sp = {}>
    <cfset sp.TEMPLATE = span>
    <cfset sp.DATA = {}>
    <cfset sp.DATA.TEXTNODE = "/ <a href='javascript:Navbar.writeURL2({route:""public.starterpack""})'>Starter Pack</a>" >
    <cfset sp.DATA.COMPILE = {}>
    <cfset request.dataF.bread.DATA.COMPILE.SPAN = sp>

    <cfset mesra = {}>
    <cfset mesra.TEMPLATE = span>
    <cfset mesra.DATA = {}>
    <cfset mesra.DATA.TEXTNODE = "/ <a href='javascript:Navbar.writeURL2({route:""public.mesra""})'>Merimen Mesra</a>" >
    <cfset mesra.DATA.COMPILE = {}>
    <cfset sp.DATA.COMPILE.SPAN = mesra>
</cfsilent>

<style>
.interactive:hover{
    background-color:#DDD
}
</style>

<cfoutput>
<div id="navH$breadcrumb"> </div>
<br>
<div id="navH$tabs" class="tabs" onclick="Tab.selectTab2(event.target)"> </div>

<script>
    // generate breadcrumb
    var breadc = #serializeJSON(request.dataF.bread)#
    document.getElementById("navH$breadcrumb").innerHTML = Templater.compileTemplate(breadc.TEMPLATE,breadc.DATA);

    // generate tabs
    var tabs = {
        TEMPLATE:document.getElementById("span").innerHTML
        ,DATA:[
             { ATTR:'pageId="page1" class="interactive pointer selected"' ,TEXTNODE:"Mesra" }
            ,{ ATTR:'pageId="page2" class="interactive pointer"' ,TEXTNODE:"Staff_Seating" }
            ,{ ATTR:'pageId="page3" class="interactive pointer"' ,TEXTNODE:"asdf" }
            ,{ ATTR:'pageId="page4" class="interactive pointer"' ,TEXTNODE:"asdf" }
        ]
    }
    document.getElementById("navH$tabs").innerHTML = Templater.compileTemplate(tabs.TEMPLATE,tabs.DATA);

    //todo:horizontal scroll vertical navigation
    // consider a builder function to make things easy
    //Tab.create = function (config) {
    //
    //}
</script>  

<div class="tabpages">
    <div id="page1" class="selected"> asfasdf12 </div>
    <div id="page2" class=""> asfasdf2 </div>
    <div id="page3" class=""> asfasdf </div>
    <div id="page4" class=""> asfas </div>
</div>
</cfoutput>
