<style>
.tabs span{
    padding: 0.5em;
}
.tabs span.selected {
    border-style:solid;
    border-color:#DDD #DDD #FFF #DDD;
    border-width:2px;
    background:#FFF
}
.tabs {
    border-bottom:2px solid #DDD;
}
.tabpages div {
    display:none;
}
.tabpages div.selected {
    display:block;
}
.pointer {
    cursor:pointer
}
</style>
<div id="navH$breadcrumb"> </div>
<div id="navH$tabs" class="tabs" onclick="Tab.selectTab2(event.target)"> </div>

<cffunction access="public" name="AppendNextDepth" output=false>
    <cfargument name="" required="true">
</cffunction>

<script>
//todo: tabbed pages
//horizontal scroll vertical navigation
//style pointers elements with states
// box around tab pages
var bc1 = {
    TEMPLATE:document.getElementById("span").innerHTML
    ,DATA:{
        ATTR:''
        ,TEXTNODE:"/ <a href=\"javascript:Navbar.writeURL2({route:'public.home'})\">Public</a>"
        ,COMPILE:{
        }
    }
}
var bc = {
    TEMPLATE:document.getElementById("span").innerHTML
    ,DATA:{
        ATTR:''
        ,TEXTNODE:"<a href=\"javascript:Navbar.writeURL2({route:'public.home'})\">Public</a>"
        ,COMPILE:{
            SPAN:bc1
        }
    }
}
var tabs = {
    TEMPLATE:document.getElementById("span").innerHTML
    ,DATA:[
         { ATTR:'pageId="page1" class="pointer selected"' ,TEXTNODE:"Mesra" }
        ,{ ATTR:'pageId="page2" class="pointer"' ,TEXTNODE:"Staff_Seating" }
        ,{ ATTR:'pageId="page3" class="pointer"' ,TEXTNODE:"asdf" }
        ,{ ATTR:'pageId="page4" class="pointer"' ,TEXTNODE:"asdf" }
    ]
}
//document.getElementById("navH$breadcrumb").innerHTML = Templater.compileTemplate(bc.TEMPLATE,bc.DATA);
document.getElementById("navH$tabs").innerHTML = Templater.compileTemplate(tabs.TEMPLATE,tabs.DATA);

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
Tab.selectTab2 = function (el) {
    Tab.selectTab(el)
    Tab.selectPage(document.getElementById(el.getAttribute("pageId")))
}

</script>  

<div class="tabpages">
    <div id="page1" class="selected"> asfasdf12 </div>
    <div id="page2" class=""> asfasdf2 </div>
    <div id="page3" class=""> asfasdf </div>
    <div id="page4" class=""> asfas </div>
</div>
