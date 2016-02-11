<cfsilent>
    <cfset content = request.HTML>
</cfsilent>
<cfoutput>
    <div class="row">
        <div class="span two"> #application.util.CFCs.routing.getHTML("cfstyle","nameBox")#  </div>
        <div class="span ten"> #application.util.CFCs.routing.getHTML("cfstyle","navH")# </div>
    </div>
    <div class="row">
        <div class="span two"> #application.util.CFCs.routing.getHTML("cfstyle","navV")# </div>
        <div class="span ten">
            <div class="row">
                <div class="span eight"> #content# </div>
                <div class="span four"> #application.util.CFCs.routing.getHTML("auth","login")# </div>
            </div>
        </div>
        </div>   
</cfoutput>
