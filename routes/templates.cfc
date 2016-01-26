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

<!--- cached templates --->
    <cffunction access="public" name="listUnordered" returntype="string" output="true">
        <cfoutput>
<ul {{$data.ATTR}}> 
    {{$data.TEXTNODE}} 
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("LIST")?Templater.compileEach($data.COMPILE.LIST):""}} </ul>
        </cfoutput>
    </cffunction>

    <cffunction access="public" name="listItem" returntype="string" output="true">
        <cfoutput>
<li {{$data.ATTR}}> 
    {{$data.TEXTNODE}} 
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("SPAN")?Templater.compileTemplate($data.COMPILE.SPAN.TEMPLATE,$data.COMPILE.SPAN.DATA):""}}
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("LIST")?Templater.compileTemplate($data.COMPILE.LIST.TEMPLATE,$data.COMPILE.LIST.DATA):""}}
</li>
        </cfoutput>
    </cffunction>

    <cffunction access="public" name="span" returntype="string" output="true">
        <cfoutput>
<span {{$data.ATTR}}> {{$data.TEXTNODE}} {{$data.INNERHTML}} </span>
        </cfoutput>
    </cffunction>

</cfcomponent>

