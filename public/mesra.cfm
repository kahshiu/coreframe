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
    <cfset mesra.DATA.TEXTNODE = "/ Merimen Mesra" >
    <cfset mesra.DATA.COMPILE = {}>
    <cfset sp.DATA.COMPILE.SPAN = mesra>
</cfsilent>

<cfoutput>
<div id="navH$breadcrumb"> </div>
<br>
<div id="navH$tabs" class="tabs" onclick="Tab.selectSinglePageByTab(event.target)"> </div>

<script>
    // generate breadcrumb
    var breadc = #serializeJSON(request.dataF.bread)#
    document.getElementById("navH$breadcrumb").innerHTML = Templater.compileTemplate(breadc.TEMPLATE,breadc.DATA);

    // generate tabs
    var tabs = {
        TEMPLATE:document.getElementById("span").innerHTML
        ,DATA:[
            { ATTR:'pageId="staffseats" id="tabber$staffseats" class="interactive pointer selected"' ,TEXTNODE:"Stf_Seats" }
            ,{ ATTR:'pageId="staffcontacts" id="tabber$staffcontacts" class="interactive pointer"' ,TEXTNODE:"Stf_Contacts" }
            //,{ ATTR:'pageId="page3" class="interactive pointer"' ,TEXTNODE:"Tab 3" }
            //,{ ATTR:'pageId="page4" class="interactive pointer"' ,TEXTNODE:"Tab 4" }
        ]
    }
    document.getElementById("navH$tabs").innerHTML = Templater.compileTemplate(tabs.TEMPLATE,tabs.DATA);

</script>  

<div class="tabpages">
    <div id="staffseats" class="selected">
<pre class="monospaced">
<b>   
===================
Merimen Seating Plan 
===================
</b>

=========         (kosong)   Lina            Allan        || Mike              (kosong)  (kosong)   (kosong)
(kosong)          =================          Sue          || Mardhiah          ============================  
Trevor            Aefa       Sheryl          Asri         || Kian_Yee          WCYeung   Shally     (kosong)         
Lai Ping                                     Hooi_Woon    || Pak_Chin                                        
Fei Bien                                     Shiu         || Lisa                                            
Andrew            (kosong)   (kosong)        Danny        || Jonathan          Afizah      Catherine   Zi    
=========         =================          Seng_Chien   || JJ                ==============================
                  (kosong)   (kosong)        Max          || Suwanto           Siew_Peng   Stanley     Mr_Foo
                                                                                                             
                                                                               Joey       Sheau_Yunn   Carina
=========         (kosong)   Lim1                                              ==============================
Ms Phuah          =============                                                (kosong)   Sharon       (kosong)      
Ms Giam           Mak        (kosong) 
=========          
</pre> 
    </div>

    <div id="staffcontacts" class="">
        <table class="table table-striped">
        <thead>
            <tr>
                <th class="interactive pointer" onclick=renderContacts("name")>&##10597; Name </th>
                <th class="interactive pointer" onclick=renderContacts("role")>&##10597; Role </th>
                <th class="interactive pointer" onclick=renderContacts("skype")>&##10597; Skype</th>
            </tr>
        </thead>
        <tbody id="staffs"> </tbody>
        </table>

        <script>
            var skypelist = {}
            skypelist.TEMPLATE = "<tr> <td>{{$data.name}}</td> <td>{{$data.role}}</td> <td>{{$data.skype}}</td> </tr>"
            skypelist.DATA =
            [{name:"Allan"         , role:"developer:emotor"      , skype:"allan@merimen.com"}
            ,{name:"Asri"          , role:"developer:emotor"      , skype:"m.asrihashim"}
            ,{name:"Carina"        , role:"customer service"      , skype:"yn_susim@yahoo.com"}
            ,{name:"Cyrus Tan"     , role:"developer:emotor"      , skype:"sheng_quan"}
            ,{name:"Danny"         , role:"developer:emotor"      , skype:"dannytan80@hotmail.com"}
            ,{name:"Hui Woon"      , role:"developer:epolicy"     , skype:"huiwoon.soon@hotmail.com"}
            ,{name:"JJ"            , role:"developer:emotor"      , skype:"jacksoo123"}
            ,{name:"Jonathan"      , role:"developer:epolicy"     , skype:"jonathan.ou.siang.how"}
            ,{name:"Kian Yee"      , role:"developer:framework"   , skype:"kianyee84@hotmail.com"}
            ,{name:"Lai Ping"      , role:"boss"                  , skype:"h_lping"}
            ,{name:"Lim"           , role:"superadmin"            , skype:"cylim.merimen"}
            ,{name:"Lina"          , role:"business analyst"      , skype:"lina_tsc@yahoo.com"}
            ,{name:"Lisayii"       , role:"developer:epolicy"     , skype:"lisayii"}
            ,{name:"Mak"           , role:"super-admin"           , skype:"makwinglok"}
            ,{name:"Mardhiah"      , role:"developer:epolicy"     , skype:"maykaito"}
            ,{name:"Max"           , role:"developer:emotor"      , skype:"leongcheenang"}
            ,{name:"Mike"          , role:"developer:emotor"      , skype:"iuvac@hotmail.com"}
            ,{name:"Ms Phuah"      , role:"finance"               , skype:"slphuah168@hotmail.com"}
            ,{name:"Sharon"        , role:"customer service"      , skype:"sharontll@hotmail.com"}
            ,{name:"Sheau Yunn"    , role:"customer service"      , skype:"sheauyunn"}
            ,{name:"Siew Peng"     , role:"business analyst"      , skype:"siewpeng.25"}
            ,{name:"Stanley"       , role:"business analyst"      , skype:"kwoksheng_tin@hotmail.com"}
            ,{name:"Sue"           , role:"developer:framework"   , skype:"sur_saidin"}
            ,{name:"Suwanto"       , role:"developer:integration" , skype:"clainyip"}
            ,{name:"Wong Pak Chin" , role:"developer:emotor"      , skype:"pakchin@hotmail.com"}
            ]

            function renderContacts(sortKey){
                skypelist.DATA = _.sortBy(skypelist.DATA,sortKey||"name")
                document.getElementById("staffs").innerHTML = Templater.compileTemplate(skypelist.TEMPLATE,skypelist.DATA)
            }
            renderContacts()
        </script>
    </div>
<!--- 
    <div id="page3" class="">  </div>
    <div id="page4" class="">  </div>
--->

</div>
</cfoutput>
