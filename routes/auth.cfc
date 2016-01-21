<cfcomponent displayname="fusebox: auth" output=false>

    <cfset this.path="">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

    <cffunction access="public" name="fuseboxStyle" returntype="any" output="true">
        <cfmodule template="/auth/style.cfm">
    </cffunction>

    <cffunction access="public" name="home" returntype="any" output="true">
        <cfmodule template="/auth/home.cfm">
    </cffunction>

    <cffunction access="public" name="login" returntype="any" output="true">
        <cfmodule template="/auth/login.cfm">
    </cffunction>

    <cffunction access="public" name="warning" returntype="any" output="true">
        <cfmodule template="/auth/warning.cfm">
    </cffunction>

</cfcomponent>
