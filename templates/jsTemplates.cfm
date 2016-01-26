<!--- fragment: form control --->
<script type="text/template" id="option">
<option {{$data.ATTR}}>{{$data.INNERHTML}}</option>
</script>

<!--- fragment: tables --->
<script type="text/template" id="tableHeadCell">
<th {{$data.ATTR}}>{{$data.INNERHTML}}</th>
</script>

<script type="text/template" id="tableCell">
<td {{$data.ATTR}}>{{$data.INNERHTML}}</td>
</script>

<script type="text/template" id="tableRow">
<tr {{$data.ATTR}}> {{Templater.compileTemplate($data.COMPILE.TEMPLATE,$data.COMPILE.DATA)}} </tr>
</script>

<script type="text/template" id="table">
<table {{$data.ATTR}}>
    <thead> {{Templater.compileEach($data.COMPILE.HEADROWS)}} </thead>
    <tbody> {{Templater.compileEach($data.COMPILE.BODYROWS)}} </tbody>
</table>
</script>

<script type="text/template" id="listUnordered">
<ul {{$data.ATTR}}> 
    {{$data.TEXTNODE}} 
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("LIST")?Templater.compileEach($data.COMPILE.LIST):""}} </ul>
</script>

<script type="text/template" id="listItem">
<li {{$data.ATTR}}> 
    {{$data.TEXTNODE}} 
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("SPAN")?Templater.compileTemplate($data.COMPILE.SPAN.TEMPLATE,$data.COMPILE.SPAN.DATA):""}}
    {{$data.hasOwnProperty("COMPILE") && $data.COMPILE.hasOwnProperty("LIST")?Templater.compileTemplate($data.COMPILE.LIST.TEMPLATE,$data.COMPILE.LIST.DATA):""}}
</li>
</script>

<script type="text/template" id="span">
<span {{$data.ATTR}}> {{$data.TEXTNODE}} {{$data.INNERHTML}} </span>
</script>

<!--- fragment: datePicker --->
<script type="text/template" id="tDatePicker$payload">
<div {{$data.ATTR}}>
    <div {{$data.ATTRDD}}>
        <input type="button" value="Today" class="button" onclick="static$DP.pickToday()">
    </div>
    <div {{$data.ATTRMM}}>
        <span {{$data.ATTRMMLA}}> <input type="button" value="&laquo;" class="button"> </span>
        <select onchange=static$DP.pickMonth(this,event)>
            {{Templater.compileEach($data.MONTH)}} 
        </select>
        <span {{$data.ATTRMMRA}}> <input type="button" value="&raquo;" class="button"> </span>
    </div>
    <div {{$data.ATTRYY}}>
        <span {{$data.ATTRYYLA}}> <input type="button" value="&laquo;" class="button"> </span>
        <span {{$data.ATTRYEAR}}> {{$data.YEAR}} </span>
        <span {{$data.ATTRYYRA}}> <input type="button" value="&raquo;" class="button"> </span>
    </div>
    <div {{$data.ATTRCAL}}>
        {{Templater.compileTemplate($data.COMPILE.CALENDAR.TEMPLATE,$data.COMPILE.CALENDAR.DATA)}} 
    </div>
</div>
</script>

<script type="text/template" id="tDatePicker$host">
<span id="{{$data.HOSTID}}" {{$data.ATTRHOST}}>
    <input type="button" value="Calendar" class="button" onclick='static$DP.rebind(document.getElementById("{{$data.TARGETID}}"),document.getElementById("{{$data.PLACEHOLDERID}}"))'>

    <span id="{{$data.PLACEHOLDERID}}"></span>
</span>
</script>  
