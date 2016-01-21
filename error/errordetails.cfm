<cfoutput>
#request.html#

<style>
    table td {vertical-align:top}
    table th {vertical-align:bottom}
</style>

name
Error Number
Error Code
Extended Info

<table>
    <tbody>
        <tr>
            <td></td>
        </tr>
    </tbody>
    <tbody>
        <tr> <td>Type      </td> <td></td> </tr>
        <tr> <td>Message   </td> <td></td> </tr>
        <tr> <td>Detail    </td> <td></td> </tr>
        <tr> <td>Additional</td> <td></td> </tr>
    </tbody>
</table>





 loopstruct

<div class="divider"> </div>
<table class="table table-striped">
    <thead>
        <tr>
            <th>
                <em>source: request.data.exception.TagContext</em>
                <br>Code Trace (Lucee) 
            </th>
            <th>Code Source</th>
        </tr>
    </thead>
    <tbody>
        <cfloop array=#request.data.exception.TagContext# index="i" item="value">
        <tr>
            <td>#value.codePrintHTML#</td>
            <td>
                #value.type#, line:#value.line# column:#value.column#
                <br>#value.template# 
            </td>
        </tr>
        </cfloop>
        </tr>
    </tbody>
</table>
</cfoutput>
<cfdump var=#request.data.exception#>
