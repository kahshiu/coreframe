<cfcomponent displayname="fusebox: profile" output=false>

    <cfset this.path="">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

<!---
    <cffunction access="public" name="fuseboxStyle" returntype="any" output="true">
    </cffunction>
--->

    <cffunction access="public" name="home" returntype="any" output="true">
        <cfmodule template="/profile/home.cfm">
    </cffunction>

</cfcomponent>


