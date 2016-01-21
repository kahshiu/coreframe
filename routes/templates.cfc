<cfcomponent displayname="fusebox: templates" output=false>

    <cfset this.path="">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

    <cffunction access="public" name="jsTemplates" returntype="any" output="true">
        <cfmodule template="/templates/jsTemplates.cfm">
    </cffunction>

</cfcomponent>

