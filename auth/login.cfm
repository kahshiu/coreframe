<cfoutput>
<cfif NOT request.auth.flag>
    <form>
        <label>
            <span>Email address</span>
            <input type="email" tabindex="1">
        </label>
        <label>
            <span>Password</span>
            <input type="password" tabindex="1">
        </label>
        <input type="submit" class="button" value="Login">
    </form>
</cfif>
</cfoutput>
