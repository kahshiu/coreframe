this is the billboard
<form class="form-horizontal">
  <strong>Horizontal form</strong>
    <div class="row">
        <div class="span four">Name</div>
        <div class="span eight">
            <input type="text" placeholder="Name" tabindex="1" id="asdf" class="DP">
            <div class="message hint">Must be a valid email address</div>
        </div>
    </div>
    <div class="row">
        <div class="span four">Name</div>
        <div class="span eight">
            <div class="row">
                <input type="text" placeholder="Name" tabindex="1" id="asdsf" class="DP"></div>
        </div>
    </div>
<div id="testappend">
</div>
<script>
$(document.getElementById("testappend")).append("<span>testin</span>")
</script>
  <label>
    <div>Email address</div>
    <input type="email" placeholder="Email address" tabindex="1"></label></form>

<form class="form-horizontal" id=f1>
    <input type="button" id="tttt" validate="alert($value)" onclick="validate(this)" value="Submit form">
<input type="text" id="xxx" class="DP" validate='alert("asdf");static$CHECK.using($options).enforce("isRequired","{{$data.$el.id}} is not required").enforce("isEarlier","{{$data.el.id}} is earlier than ").render()' onblur="Validate.element(this)">

</form>

<!---
<select id="" name="t" MULTIPLE validate='console.log($el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)">    
    <option selected>item1</option>
    <option >item2</option>
</select>

<input type="radio" name="test" value=1 validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)">    
<input type="radio" name="test" value=2 validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)" checked>
<input type="radio" name="test" value=3 validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)" >
<input type="radio" name="test" value=4 validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)" >

<input type="checkbox" name="test2" value=1 validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)">
<input type="checkbox" name="test2" value=2 validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)">
<input type="checkbox" name="test2" value=3 validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)">
<input type="checkbox" name="test2" value=4 validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onclick="Validator.validate(this)">

<input type="text" name="text1" validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' onblur="Validator.validate(this)">
<input type="button" name="text1" validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' value="ssss" onclick="Validator.validate(this)">
<input type="hidden" name="text1" validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' value="ssss" onchange="Validator.validate(this)">
<div cat=11 CAT=12 c id="x" validate='console.log("el",$el,"els",$els,"elselect",$selected,$val)' value="ssss" onclick="Validator.validate(this)">div here </div>

<script>
//console.log(
//     document.getElementById("x").getAttribute("cat")
//    ,document.getElementById("x").getAttribute("cAT")
//    ,document.getElementById("x").getAttribute("b")
//        )

</script>
--->

