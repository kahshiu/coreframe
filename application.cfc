<cfcomponent displayname="application" output="false">
<!--- variables --->
    <cfset this.Name               = "Core Sys">
    <cfset this.ApplicationTimeout = CreateTimeSpan(0,3,0,0)>
    <cfset this.SessionManagement  = true>
    <cfset this.SessionTimeout     = CreateTimeSpan(0,0,30,0)>
    <cfset this.SetDomainCookies   = false>
    <cfset this.SetClientCookies   = false>
    <cfset this.ClientManagement   = false>
    <cfset this.ClientStorage      = false>
    <cfset this.ScriptProtect      = true>

<!--- application functions --->
    <cffunction access="public" name="onApplicationStart" returntype="any" output="false">
        <cfset refreshAppVars()>
        
    </cffunction>

    <cffunction access="public" name="onApplicationEnd" returntype="any" output="false">
        
    </cffunction>

<!--- session functions --->
    <cffunction access="public" name="onSessionStart" returntype="any" output="false">
        <cfset session.auth = {}>
        <cfset session.auth.flag = false>
        <cfset session.auth.username = "">
        <cfset session.auth.permissions = {}>
    </cffunction>

    <cffunction access="public" name="onSessionEnd" returntype="any" output="false">
        
    </cffunction>

<!--- Request functions --->
    <cffunction access="public" name="onRequestStart" returntype="any" output="false">
<!--- add password later for refresh vars --->
        <cfset forceRefreshAppVars = StructKeyExists(URL,"refreshVars") and URL.refreshVars eq "application">
        <cfset forceRefreshAppVars = true>
        <cfset forceRefreshReqVars = true>
        <cfif forceRefreshAppVars> <cfset refreshAppVars()> </cfif>
        <cfif forceRefreshReqVars> <cfset refreshReqVars()> </cfif>
        <!--- authentication --->

    </cffunction>

    <cffunction access="public" name="onRequest" returntype="any" output="true">
        <cfargument name="page" type="string" required="true">
        <cfsilent>
            <!--- route resolution: default --->
            <cfset var fusebox = "public">
            <cfset var fuseaction = "home">
            <cfset var fuse = []>

            <!--- route resolution: route defined --->
            <cfif StructKeyExists(URL,"route") AND URL.route neq ""> 
                <cfset fuse = ListToArray(URL.route,".")>
                <cfif ArrayLen(fuse) gt 0> <cfset fusebox = fuse[1]> </cfif>
                <cfif ArrayLen(fuse) gt 1> <cfset fuseaction = fuse[2]> </cfif>
            </cfif>

            <!--- route resolution: privacy control --->
            <cfif NOT request.auth.flag>
                <cfset publicFuseboxes = "public,auth">
                <cfif ListFind(publicFuseboxes, fusebox) eq 0>
                    <cfset fusebox = "auth">
                    <cfset fuseaction = "warning">
                </cfif>
            </cfif>

            <cfset application.util.CFCs.routing.setfuseboxVars(fusebox)>
            <cfset application.util.CFCs.routing.getHTML(fusebox,fuseaction)>
            <cfset application.util.CFCs.routing.styleFusebox(fusebox)>
            <cfset application.util.CFCs.routing.styleGlobally()>
        </cfsilent>
        <cfoutput>#request.HTML#</cfoutput>
    </cffunction>

    <cffunction access="public" name="onRequestEnd" returntype="any" output="false">
        
    </cffunction>

    <cffunction access="public" name="onError" returntype="any" output="true">
        <cfargument name="exception" type="any" required="true">
        <cfargument name="event" type="string" required="true">
** use the direct approach without use of functions
<cfdump var=#exception#>
<cfabort>
<!---
        <cfsilent>
            <cfset request.data.exception = arguments.exception>
            <cfset request.data.event = arguments.event>

            <cfset var fusebox = "error">
            <cfset application.util.CFCs.routing.getHTML(fusebox,"home")>
            <cfset application.util.CFCs.routing.getHTML(fusebox,"details")>
            <cfset application.util.CFCs.routing.runCF(fusebox,"logger")>
            <cfset application.util.CFCs.routing.styleFusebox(fusebox)>
            <cfset application.util.CFCs.routing.styleGlobally()>
        </cfsilent>
        <cfoutput>#request.HTML#</cfoutput>
--->
    </cffunction>

<!--- start: helper functions --->
    <cffunction access="public" name="refreshAppVars" returntype="void" output="false">
        <cfif StructKeyExists(application,"dataF")>
            <cfset StructClear(application.dataF)>
        </cfif>
        <cfset application.dataF.hostname = "http://127.0.0.1:8888/">
        <cfset application.dataF.subdir = "coreframe/">

        <!--- utils --->
        <cfif StructKeyExists(application,"util")>
            <cfset StructClear(application.util)>
        </cfif>
        <cfset application.util.dir = "util">
        <cfset application.util.paths = formPaths(application.util.dir)>
        <cfset application.util.CFCs = formCFCs(application.util.paths)>
        <!--- routing --->
        <cfset application.util.CFCs.routing.routesDir = "routes">
        <cfset application.util.CFCs.routing.routesPaths = formPaths(application.util.CFCs.routing.routesDir)>
        <cfset application.util.CFCs.routing.routesCFCs = formCFCs(application.util.CFCs.routing.routesPaths)>
    </cffunction>

    <cffunction access="public" name="refreshReqVars" returntype="void" output="false">
        <cfif StructKeyExists(session,"auth")>
            <cfset request.auth = Duplicate(session.auth)>
        <cfelse>
            <cfset request.auth.flag = false>
            <cfset request.auth.username = "Guest">
            <cfset request.auth.permission = {}>
        </cfif>
        <!--- separate structs for framework data and application data --->
        <cfset request.dataF = Duplicate(application.dataF)>
        <cfset request.dataF.navV = {}>
        <cfset request.dataF.navV.TEMPLATE = "">
        <cfset request.dataF.navV.DATA = {}>

        <cfset request.dataF.bread = {}>
        <cfset request.dataF.bread.TEMPLATE = "">
        <cfset request.dataF.bread.DATA = {}>

        <cfset request.data = {}>
    </cffunction>

<!--- Util: local CFC generator --->
    <cffunction access="public" name="formPaths" returntype="struct" output="false"
        description="construct dot-delimited paths to generate CFCs">

        <cfargument name="dir" type="string" required="true">
        <cfset var fname = "">
        <cfset var fpaths = {}>
        <cfset var fpath = []>

        <cfset files = DirectoryList(
            path = arguments.dir
            , recurse = false
            , listInfo = "name"
            , filter = "*.cfc"
            , sort = "asc"
            )>

        <cfloop array=#files# index="i" item="value">
            <cfset fname = ListFirst(value,".")>
            <cfset fpath = []>
            <cfset ArrayAppend(fpath,arguments.dir)>
            <cfset ArrayAppend(fpath,fname)>
            <cfset fpaths[fname] = ArrayToList(fpath,".")> 
        </cfloop>

        <cfreturn fpaths>
    </cffunction>   

    <cffunction access="public" name="formCFCs" returntype="struct" output="false"
        description="generate all CFCs for routing">

        <cfargument name="fpaths" type="struct" required="true">
        <cfset var currPath = "">
        <cfset var CFCs = {}>

        <cfloop collection=#arguments.fpaths# item="value">
            <cfset currPath = arguments.fpaths[value]>
            <cfset CFCs[value] = createObject("component",currPath).init(currPath)>
        </cfloop>
        <cfreturn CFCs>
    </cffunction>

</cfcomponent>
