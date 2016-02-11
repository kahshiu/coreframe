<cfoutput>
<div id="navV$secondary" class="navPlaceHolder" onclick="Navbar.expandSubmenu(this,event)"> </div>
<script>
    var navPlaceholder=document.getElementById("navV$secondary"), navV=#serializeJSON(request.dataF.navV)#
    request.navbars.push(navPlaceholder);
    navPlaceholder.innerHTML = Templater.compileTemplate(navV.TEMPLATE,navV.DATA)
</script>
</cfoutput>
