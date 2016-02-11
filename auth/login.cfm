<cfoutput>
<cfif NOT request.auth.flag>
<cfset a = "asdf:ccyycc">
    <form name="form_login" id="form_login" method="post" action="#application.util.CFCs.routing.writeURL(route="auth.login_act")#">
        <div class="row">
            <div class="span twelve">
            <label>
                <span>Username:</span> <br>
                <input type="text" tabindex="1" validate='static$Police.using($options).enforce({name:"isRequired"})'>
            </label>
            </div>
        </div>
        <div class="row">
            <div class="span twelve">
            <label>
                <span>Password:</span> <br>
                <input type="password" tabindex="2" validate='static$Police.using($options).enforce({name:"isRequired"})'>
            </label>
            </div>
        </div>
        <input type="button" class="button primary small" value="Login" onclick='static$Police.form(this.parentNode).submit(this.parentNode)'>
    </form>
</cfif>
</cfoutput>
