<cfcomponent displayname="routing facilities">

<!--- static variables --->
    <cfset this.path = "">
    <cfset this.routesDir = {}>
    <cfset this.routesPaths = {}>
    <cfset this.routesCFCs = {}>

<!--- style names (fuseboxes) --->
    <cfset this.globalStyle = "">
    <cfset this.globalStylePath = "/cfStyle/global.cfm">
    <cfset this.globalFuseboxStyle = "">
    <cfset this.globalFuseboxStylePath = "/cfStyle/fusebox.cfm">
    <cfset this.customFuseboxStyleFn = "fuseboxStyle">

    <cffunction access="public" name="init" returntype="any" output="false" 
        description="function to initialise component">

        <cfargument name="path" type="string" required="true">
        <cfset this.path = arguments.path> 
        <cfif FileExists(this.globalStylePath)> <cfset this.globalStyle = "global"> </cfif>
        <cfif FileExists(this.globalFuseboxStylePath)> <cfset this.globalFuseboxStyle = "globalFusebox"> </cfif>
        <cfreturn this>    
    </cffunction>

    <cffunction name="validateRoute" returntype="boolean" output="false"
        description="validate a given route. Must initialise/ store CFCs and paths first">

        <cfargument name="fusebox" type="string" required="true">
        <cfargument name="fuseaction" type="string" required="true">

        <cfset var validbox = StructKeyExists(this.routesCFCs,arguments.fusebox)>
        <cfset var validaction = false>
        <cfif validbox>
            <cfset var meta = GetComponentMetaData(this.routesPaths[arguments.fusebox])>
            <cfloop array=#meta.functions# index="i" item="value">
                <cfif value.name eq arguments.fuseaction>
                    <cfset validaction = true>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>
        <cfreturn validbox AND validaction>
    </cffunction>

    <cffunction name="styleGlobally" returntype="string" output="false">
        <cfset getHTML("cfStyle",this.globalStyle)>
    </cffunction>

    <cffunction name="styleFusebox" returntype="string" output="true">
        <cfargument name="fusebox" type="any" required="false">

        <cfset var style = "">
        <cfif this.validateRoute(arguments.fusebox,this.customFuseboxStyleFn)>
            <cfset style = this.customFuseboxStyleFn>
        <cfelse>
            <cfset arguments.fusebox = "cfStyle">
            <cfset style = this.globalFuseboxStyle>
        </cfif>

        <cfif style neq ""> 
            <cfset getHTML(arguments.fusebox,style)>
        </cfif>
    </cffunction>

    <cffunction access="public" name="runCF" returntype="void" output="false"
        description="run CF action code in template">

        <cfargument name="fusebox" type="string" required="true">
        <cfargument name="fuseaction" type="string" required="true">

        <cfif NOT validateRoute(arguments.fusebox,arguments.fuseaction)>
<cfthrow type="missing template" message ="cant find it ">
            <cfreturn>
        </cfif>

        <cfset this.routesCFCs[arguments.fusebox][arguments.fuseaction]()>
    </cffunction>

    <cffunction access="public" name="getFuseboxLinks" returntype="void" output="false">
        <cfargument name="fusebox" type="string" required="true">

        <cfif validateRoute(arguments.fusebox,"fuseboxLinks")>
            <cfset request.dataF.links = this.routesCFCs[arguments.fusebox].fuseboxLinks()>
        </cfif>
        
    </cffunction>

    <cffunction access="public" name="getHTML" returntype="string" output="false"
        description="get HTML string of page and assign to request.html">

        <cfargument name="fusebox" type="string" required="true">
        <cfargument name="fuseaction" type="string" required="true">

        <cfif NOT validateRoute(arguments.fusebox,arguments.fuseaction)>
<cfthrow type="missing template" message ="cant find it ">
            <cfreturn>
        </cfif>

        <cfif NOT StructKeyExists(request,"HTML")>
            <cfset request.HTML = "">
        </cfif>

        <cfsavecontent variable="request.HTML"> <cfset this.routesCFCs[arguments.fusebox][arguments.fuseaction]()> </cfsavecontent>

        <cfreturn request.HTML>
    </cffunction>

    <cffunction access="public" name="writeURL" returntype="any" output="false">
        <cfargument name="route" type="any" required="false">
        <cfset var theURL = "#request.dataF.hostname#index.cfm?route=#arguments.route#&#session.urltoken#">
        <cfreturn theURL>
    </cffunction>

</cfcomponent>
