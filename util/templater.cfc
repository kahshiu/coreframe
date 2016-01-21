<cfcomponent displayname="templater" output=false>

    <cfset this.path="">

    <cffunction access="public" name="init" returntype="any" output="true">
        <cfargument name="path" type="string" required="true">    
        <cfset this.path = arguments.path>
        <cfreturn this>
    </cffunction>

<!--- common components --->
    <cffunction access="public" name="compiler" returntype="any" output="false">
        <cfargument name="data" type="any" required="true">
        <cfset var template = "<{{element}} {{attr}}>{{innerHTML}}</{{element}}>">
        <cfset var total = "">
        <cfset var temp = "">
        <cfif isArray(data)>
            <cfloop array=#arguments.data# index="i" item="value">
                <cfset total = total & compiler(value)>
            </cfloop>
        <cfelseif isStruct(arguments.data)>
            <cfif NOT StructKeyExists(arguments.data,"element")> <cfset data.element = "p"> </cfif>
            <cfif NOT StructKeyExists(arguments.data,"attr")> <cfset data.attr = {}> </cfif>
            <cfif NOT StructKeyExists(arguments.data,"innerHTML")> <cfset data.innerHTML = ""> </cfif>
            <cfif StructKeyExists(data,"innerElements")>
                <cfset data.innerHTML = data.innerHTML & compiler(data.innerElements)>
            </cfif>

            <cfset temp = REReplace(template,"{{element}}",data.element,"all")> 
            <cfset temp = REReplace(temp,"{{attr}}",formAttr(data.attr))> 
            <cfset temp = REReplace(temp,"{{innerHTML}}",data.innerHTML)> 
            <cfset total = total & temp>
        <cfelse>
            <cfthrow message="unsupported params">
        </cfif>
        <cfreturn total>
    </cffunction>

    <cffunction access="public" name="formAttr" returntype="string" output="false">
        <cfargument name="elAttr" type="struct" required="true">
        <cfset var total = "">
        <cfloop collection=#elAttr# item="value">
            <cfset total = total & ' ' & '#value#="#elAttr[value]#"'>
        </cfloop>
        <cfreturn Right(total,Len(total)-1)>
    </cffunction>

</cfcomponent>

