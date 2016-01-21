<cfoutput>
<!--- fragment: form control --->
<script type="text/template" id="option">
<option {{$data.attr}}>{{$data.innerHTML}}</option>
</script>

<!--- fragment: tables --->
<script type="text/template" id="tableHeadCell">
<th {{$data.attr}}>{{$data.innerHTML}}</th>
</script>

<script type="text/template" id="tableCell">
<td {{$data.attr}}>{{$data.innerHTML}}</td>
</script>

<script type="text/template" id="tableRow">
<tr {{$data.attr}}> {{Templater.compileTemplate($data.compile.template,$data.compile.data)}} </tr>
</script>

<script type="text/template" id="table">
<table {{$data.attr}}>
    <thead> {{Templater.compileEach($data.compile.headRows)}} </thead>
    <tbody> {{Templater.compileEach($data.compile.bodyRows)}} </tbody>
</table>
</script>

<!--- fragment: datePicker --->
<script type="text/template" id="tDatePicker$payload">
<div {{$data.attr}}>
    <div {{$data.attrDD}}>
        <input type="button" value="Today" class="button" onclick="static$DP.pickToday()">
    </div>
    <div {{$data.attrMM}}>
        <span {{$data.attrMMLA}}> <input type="button" value="&laquo;" class="button"> </span>
        <select onchange=static$DP.pickMonth(this,event)>
            {{Templater.compileEach($data.month)}} 
        </select>
        <span {{$data.attrMMRA}}> <input type="button" value="&raquo;" class="button"> </span>
    </div>
    <div {{$data.attrYY}}>
        <span {{$data.attrYYLA}}> <input type="button" value="&laquo;" class="button"> </span>
        <span {{$data.attrYear}}> {{$data.year}} </span>
        <span {{$data.attrYYRA}}> <input type="button" value="&raquo;" class="button"> </span>
    </div>
    <div {{$data.attrCal}}>
        {{Templater.compileTemplate($data.compile.calendar.template,$data.compile.calendar.data)}} 
    </div>
</div>
</script>

<script type="text/template" id="tDatePicker$host">
<span id="{{$data.hostId}}" {{$data.attrHost}}>
    <input type="button" value="Calendar" class="button" onclick='static$DP.rebind(document.getElementById("{{$data.targetId}}"),document.getElementById("{{$data.placeholderId}}"))'>

    <span id="{{$data.placeholderId}}"></span>
</span>
</script>  

</cfoutput>
