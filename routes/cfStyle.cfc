<cfcomponent displayname="fusebox: cfStyle" output=false>

    <cfset this.path = "">

    <cffunction access="public" name="init" returntype="any" output="false">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

    <cffunction access="public" name="global" returntype="any" output="true">
        <cfmodule template="/cfStyle/global.cfm">
    </cffunction>

    <cffunction access="public" name="globalFusebox" returntype="any" output="true">
        <cfmodule template="/cfStyle/fusebox.cfm"> 
    </cffunction>

    <cffunction access="public" name="header" returntype="any" output="true">
        <cfmodule template="/cfStyle/pheader.cfm"> 
    </cffunction>

    <cffunction access="public" name="footer" returntype="any" output="true">
        <cfmodule template="/cfStyle/pfooter.cfm"> 
    </cffunction>

    <cffunction access="public" name="navH" returntype="any" output="true">
        <cfmodule template="/cfStyle/navH.cfm"> 
    </cffunction>

    <cffunction access="public" name="navV" returntype="any" output="true">
        <cfmodule template="/cfStyle/navV.cfm"> 
    </cffunction>

    <cffunction access="public" name="nameBox" returntype="any" output="true">
        <cfmodule template="/cfStyle/nameBox.cfm"> 
    </cffunction>

</cfcomponent>

