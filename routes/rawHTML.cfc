<cfcomponent displayname="fusebox: rawHTML" output=false>

    <cfset this.path="">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

<!---
    <cffunction access="public" name="fuseboxStyle" returntype="any" output="true">
        <cfmodule template="/rawHTML/style.cfm">
    </cffunction>
--->

    <cffunction access="public" name="home" returntype="any" output="true">
        <cfmodule template="/rawHTML/home.cfm">
    </cffunction>

<!---
    <cffunction access="public" name="" returntype="any" output="true">
        <cfmodule template="/rawHTML/login.cfm">
    </cffunction>
--->

</cfcomponent>

