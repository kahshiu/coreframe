<cfoutput>
    <form class="form-horizontal message-below">
      <label>
        <div>Name</div>
        <input type="text" placeholder="Name" tabindex="1">
      </label>
      <label>
        <div>Email address</div>
        <input type="email" placeholder="Email address" tabindex="1">
        <span class="message">Please use a valid email address</span>
      </label>
      <label>
        <div>Favourite beer?</div>
        <select tabindex="1">
          <option>Heineken</option>
          <option>Carlsberg</option>
          <option>Stella Artois</option>
          <option>Cronenberg</option>
          <option>Guiness</option>
          <option>Amstel</option>
          <option>Corona</option>
        </select>
      </label>
      <div class="label-group">
        <div>Which is better?</div>
        <label>
          <input type="radio" name="cartoons" value="simpsons" tabindex="1">The Simpsons
        </label>
        <label>
          <input type="radio" name="cartoons" value="family_guy" tabindex="1">Family Guy
        </label>
        <label>
          <input type="radio" name="cartoons" value="southpark" tabindex="1">Southpark
        </label>
      </div>
<input type="submit" class="button">
    </form>    
    #application.util.CFCs.routing.getHTML("main","page2")#
</cfoutput>
