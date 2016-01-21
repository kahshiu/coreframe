<cfcomponent displayname="fusebox: error" output=false>

    <cfset this.path = "">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

    <cffunction access="public" name="fuseboxStyle" returntype="any" output="true">
        <cfmodule template="/error/style.cfm"> 
    </cffunction>

    <cffunction access="public" name="home" returntype="any" output="true">
        <cfmodule template="/error/home.cfm">
    </cffunction>

    <cffunction access="public" name="logger" returntype="any" output="true">
        <cfmodule template="/error/errorlog.cfm">
    </cffunction>

    <cffunction access="public" name="details" returntype="any" output="true">
        <cfmodule template="/error/errordetails.cfm"> 
    </cffunction>


</cfcomponent>

