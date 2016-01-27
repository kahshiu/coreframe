<cfcomponent displayname="fusebox: public" output=false>

    <cfset this.path="">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

    <cffunction access="public" name="fuseboxStyle" returntype="any" output="true">
        <cfmodule template="/auth/style.cfm">
    </cffunction>

    <cffunction access="public" name="fuseboxVars" returntype="any" output="false">
        <cfmodule template="/public/vars.cfm">
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

