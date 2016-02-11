<cfcomponent displayname="fusebox: main" output=false>

    <cfset this.path = "">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

<!---
    <cffunction access="public" name="fuseboxStyle" returntype="any" output="true">
        <cfmodule template="/main/style.cfm"> 
    </cffunction>
--->

    <cffunction access="public" name="home" returntype="any" output="true">
        <cfmodule template="/main/home.cfm">
    </cffunction>

    <cffunction access="public" name="page2" returntype="any" output="true">
        <cfmodule template="/main/page2.cfm">
    </cffunction>


</cfcomponent>
