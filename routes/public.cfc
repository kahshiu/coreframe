<cfcomponent displayname="fusebox: public" output=false>

    <cfset this.path="">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

    <cffunction access="public" name="fuseboxLinks" returntype="any" output="false">
        <cfset var links3 = [
            {
                element:"li"
                ,innerHTML:"---- Billboard3"
                ,attr:{ href=#application.util.CFCs.routing.writeURL(route="public.billboard")# }
            }
            ,{
                element:"li"
                ,innerHTML:"---- Billboard3"
                ,attr:{ href=#application.util.CFCs.routing.writeURL(route="public.billboard")# }
            }
        ]>
        <cfset var ul3 = {
            element:"ul"
            ,innerHTML:""
            ,attr:{}
            ,innerElements:links3}> 
        <cfset var links2 = [
            {
                element:"li"
                ,innerHTML:"-- Billboard2"
                ,attr:{ href=#application.util.CFCs.routing.writeURL(route="public.billboard")# }
            }
            ,{
                element:"li"
                ,innerHTML:"-- Billboard2"
                ,attr:{class:"hideSub", href=#application.util.CFCs.routing.writeURL(route="public.billboard")# }
                ,innerElements:ul3 
            }
        ]>
        <cfset var ul2 = {
            element:"ul"
            ,innerHTML:""
            ,attr:{}
            ,innerElements:links2
        }> 
        <cfset var links = [
            {
                element:"li"
                ,innerHTML:"Billboard"
                ,innerElements:ul2 
                ,attr:{ class:"hideSub",href=#application.util.CFCs.routing.writeURL(route="public.billboard")# }
            }
            ,{
                element:"li"
                ,innerHTML:""
                ,attr:{href=""}
            }
            ,{
                element:"li"
                ,innerHTML:""
                ,attr:{href=""}
            }
        ]>
        <cfset var ul = {
            element:"ul"
            ,innerHTML:""
            ,attr:{id="nav1"}
            ,innerElements:links}> 
        <cfreturn ul>
    </cffunction>

    <cffunction access="public" name="fuseboxStyle" returntype="any" output="true">
        <cfmodule template="/auth/style.cfm">
    </cffunction>

    <cffunction access="public" name="home" returntype="any" output="true">
        <cfmodule template="/public/home.cfm">
    </cffunction>

    <cffunction access="public" name="billboard" returntype="any" output="true">
        <cfmodule template="/public/billboard.cfm">
    </cffunction>

    <cffunction access="public" name="starterpack" returntype="any" output="true">
        <cfmodule template="/public/starterpack.cfm">
    </cffunction>

    <cffunction access="public" name="mesra" returntype="any" output="true">
        <cfmodule template="/public/mesra.cfm">
    </cffunction>

    <cffunction access="public" name="training" returntype="any" output="true">
        <cfmodule template="/public/training.cfm">
    </cffunction>

</cfcomponent>

