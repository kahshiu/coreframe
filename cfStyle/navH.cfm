<cfoutput>
<div class="navbar">
    <h4 class="pull-left">#application.applicationname#</h4>
    <div class="clear"></div>
    <ul class="pull-left">
        <li><a href="#application.util.cfcs.routing.writeurl(route="public.home")#">Public</a></li>
        <cfif request.auth.flag>
            <li><a href="#application.util.CFCs.routing.writeURL(route='client.home')#">Client Profile</a></li>
            <li><a href="#application.util.CFCs.routing.writeURL(route='cases.home')#">Cases</a></li>
            <li><a href="#application.util.CFCs.routing.writeURL(route='auth.logout')#">Logout</a></li>
        </cfif>
    </ul>
</div>   
</cfoutput>
