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
  <label>
    <div>Email address</div>
    <input type="email" placeholder="Email address" tabindex="1"></label></form>

<form class="form-horizontal" id=f1>
    <input type="button" id="tttt" validate="alert($value)" onclick="validate(this)" value="Submit form">
    <script>

function validate (el){
    val = (new Function(
                "$value"
                ,el.getAttribute("validate")
            ))( el.value ); 


    console.log( el.getAttribute("isValid") )
    console.log( el.getAttribute("makevalid"))
}
function FValidator (el) {
    this.el = el
    this.errTemplate = "<span {{$data.attr}}>{{$data.innerHTML}}</span>";
    this.errMessage = null;
    this.errMessages = [];
    this.flag = true;
}
FValidator.prototype.updateFlag = function (obj) {
    // invalid flag is final (not updated), valid flag is not final (update accordingly)
    if (!this.flag) {
        this.errMessage = !this.eMessage? obj.message: this.eMessage;
        this.errMessages.push(obj.message);
        return;
    }
    this.flag = obj.flag
}
FValidator.prototype.isRequired = function () {
    var obj = {
        flag:true 
        ,dMessage:"" 
    }
    this.updateFlag (obj)
    return this 
}
FValidator.prototype.limitMax = function () {
    var obj = {
        flag:false 
        ,dMessage:"something is wrong" 
    }
    this.updateFlag (obj)
    return this 
}
FValidator.prototype.display = function () {
    $(this.el).after("<span>wrong</span>")
}
val = new FValidator (document.getElementById("tttt"))
console.log(val.isRequired().limitMax().display())




    //document.getElementById('tttt').onclick = function(){
    //    console.log("this is from outside")
    //}
    //document.getElementById('tttt').onclick = function(){
    //    console.log("this is from outside333")
    //}
    </script>
</form>

