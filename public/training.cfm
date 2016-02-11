<cfsilent>
    <cfset span = application.util.CFCs.routing.getHTML("templates","span")>
    <cfset sp = {}>
    <cfset sp.TEMPLATE = span>
    <cfset sp.DATA = {}>
    <cfset sp.DATA.TEXTNODE = "/ <a href='javascript:Navbar.writeURL2({route:""public.starterpack""})'>Starter Pack</a>" >
    <cfset sp.DATA.COMPILE = {}>
    <cfset request.dataF.bread.DATA.COMPILE.SPAN = sp>

    <cfset mesra = {}>
    <cfset mesra.TEMPLATE = span>
    <cfset mesra.DATA = {}>
    <cfset mesra.DATA.TEXTNODE = "/ Training" >
    <cfset mesra.DATA.COMPILE = {}>
    <cfset sp.DATA.COMPILE.SPAN = mesra>
</cfsilent>

<cfoutput>
<div id="navH$breadcrumb"> </div>
<br>
<div id="navH$tabs" class="tabs" onclick="Tab.selectSinglePageByTab(event.target)"> </div>

<script>
    // generate breadcrumb
    var breadc = #serializeJSON(request.dataF.bread)#
    document.getElementById("navH$breadcrumb").innerHTML = Templater.compileTemplate(breadc.TEMPLATE,breadc.DATA);

    // generate tabs
    var tabs = {
        TEMPLATE:document.getElementById("span").innerHTML
        ,DATA:[
            { ATTR:'pageId="day1" id="tabber$day1" class="interactive pointer selected"' ,TEXTNODE:"First Day" }
            ,{ ATTR:'pageId="train" id="tabber$train" class="interactive pointer"' ,TEXTNODE:"Training" }
            ,{ ATTR:'pageId="chktsql" id="tabber$chktsql" class="interactive pointer"' ,TEXTNODE:"Qz: TSQL" }
            ,{ ATTR:'pageId="chkcf" id="tabber$chkcf" class="interactive pointer"' ,TEXTNODE:"Qz: CF" }
            ,{ ATTR:'pageId="chkjs" id="tabber$chkjs" class="interactive pointer"' ,TEXTNODE:"Qz: JS" }
            ,{ ATTR:'pageId="train$motor" id="tabber$train$motor" class="interactive pointer"' ,TEXTNODE:"Motor" }
            ,{ ATTR:'pageId="infra" id="tabber$infra" class="interactive pointer"' ,TEXTNODE:"Infra" }
            //,{ ATTR:'pageId="page4" class="interactive pointer"' ,TEXTNODE:"Tab 4" }
        ]
    }
    document.getElementById("navH$tabs").innerHTML = Templater.compileTemplate(tabs.TEMPLATE,tabs.DATA);

</script>  

<div class="tabpages">
    <div id="day1" class="selected"> 
        <h4> Welcome to Merimen!  </h4>
        <br>
        <p class="bold"> 1. Check your machine setup </p>
        <p> Lim (super admin) had done the following installs onto your machine:
            <ul>
                <li>Install SQL Management Tool 2012</li>
                <li>Install CF 11</li>
                <li>Install Eclipse</li>
                <li>Install Notepad++</li>
                <li>Install SVN Tortoise</li>
                <li>Install GrepWin</li>
                <li>Install Skype (for internal communication) </li>
            </ul>            
        </p> <br>

        <p class="bold"> 2. <a href="https://www.merimen.com.my/claims/index.cfm?fusebox=MTRroot&fuseaction=dsp_login&train=1&skip_browsertest=1">Merimen System Training Mode</a> </p>
        <p> While waiting for your tutor to arrive, 
            try Merimen System on <b><a href="https://www.merimen.com.my/claims/index.cfm?fusebox=MTRroot&fuseaction=dsp_login&train=1&skip_browsertest=1">Training Mode</a></b>.<br>
            Merimen provides online service for Motor Claims, 
            that generally involves   
            <ul>
                <li>Repairer</li>
                <li>Insurer</li>
                <li>Adjuster</li>
                <li>Solicitor (if third-party (bodily injury, property damage) is involved)</li>
            </ul>
        </p> <br>
        <p>
        <table class="table table-striped">
        <thead>
            <tr>
                <th class="interactive pointer" onclick=renderLogins("coname")>&##10597; Company </th>
                <th class="interactive pointer" onclick=renderLogins("role")>&##10597; Role </th>
                <th class="interactive pointer" onclick=renderLogins("username")>&##10597; Username </th>
                <th class="interactive pointer" onclick=renderLogins("password")>&##10597; Password</th>
            </tr>
        </thead>
        <tbody id="logins"> </tbody>
        </table>
<script>
var logins = {};
logins.TEMPLATE = "<tr> <td>{{$data.coname}}</td> <td>{{$data.role}}</td> <td>{{$data.username}}</td> <td>{{$data.password}}</td> </tr>"
logins.DATA = 
     [{username :"isaac123" ,password: "$donney2$" ,role:"repairer"  ,coname:"RO Workshop"}
     ,{username :"david123" ,password: "$donney2$" ,role:"insurer"   ,coname:"Beta Insurance"}
     ,{username :"alvin123" ,password: "$donney2$" ,role:"adjuster"  ,coname:"Alpha Test Adjusters"}
     ,{username :"tpsol"    ,password: "$donney2$" ,role:"solicitor" ,coname:"Rahim & Baba"}
    ]
function renderLogins(sortKey){
    logins.DATA = _.sortBy(logins.DATA,sortKey||"name")
    document.getElementById("logins").innerHTML = Templater.compileTemplate(logins.TEMPLATE,logins.DATA)
}
renderLogins()
</script>
        </p> <br>
        <p> Note:
            Please make sure your claims workflow happens within these companies mentioned above <b>ONLY</b>.<br>
            Even though this is Training Mode, emails will be triggered.<br>
        </p><br>

        <p class="bold"> 3. Claims Workflow </p>
        <p> The most common claim issued is Own-Damage claimtype (OD). <br>
            Below is the usual sequence of workflow: 
            <ol>
                <li>Starts off by repairer creating claims to insurer.</li>
                <li>Repairer fills in Claims Details.</li>
                <li>Repairer fills in initial Estimate</li>
                <li>Repairer submits to Insurer.</li>
                <li>Insurer received claim.</li>
                <li>Insurer assign PIC (and sometimes adjuster), then waits for Adjuster report.</li>
                <li>Adjuster fills in his/ her opinion on Estimate.</li>
                <li>Adjuster prepares written report if necessary.</li>
                <li>Adjuster creates an Invoice to bill Insurer for their adjusting service.</li>
                <li>Adjuster submits to Insurer.</li>
                <li>Insurer compares the estimate from both parties (Repairer, Adjuster)</li>
                <li>Insurer decides the right price to offer to Repairer.</li>
                <li>Repairer decides to accept</li>
                <li>Repairer issues invoice for repair service/ parts.</li>
                <li>Insurer initiates subrogation (if claimant is not fault/ shared fault with another party)</li>
            </ol>
        </p>
        <p> Now, try to mock a case in <a href="https://www.merimen.com.my/claims/index.cfm?fusebox=MTRroot&fuseaction=dsp_login&train=1&skip_browsertest=1">Merimen System Training Mode</a> </p>
    </div>

    <div id="infra" class="">
        <table class="table table-striped">
        <thead>
            <tr>
                <th class="interactive pointer" onclick=renderServers("name")>&##10597; Name </th>
                <th class="interactive pointer" onclick=renderServers("role")>&##10597; Role </th>
                <th class="interactive pointer" onclick=renderServers("ip")>&##10597; IP</th>
            </tr>
        </thead>
        <tbody id="servers"> </tbody>
        </table> 

        <script>
            var servers = {}
            servers.TEMPLATE = "<tr> <td>{{$data.name}}</td> <td>{{$data.role}}</td> <td>{{$data.ip}}</td> </tr>"
            servers.DATA = 
            [ {name:"DEVKL"       , role:"internal testing server"                        , ip:"192.168.1.204"}
            , {name:"SQL2008KL"   , role:"database server; hosts MSSQL"                   , ip:"192.168.1.203"}
            , {name:"MERIMENWIKI" , role:"rojak server; hosts SVN for CF and Merimenwiki" , ip:"192.168.1.4"}
            , {name:"2012stage"   , role:"staging server; hosts MY/SG/ID stage"           , ip:"192.168.1.231"}
            ]

            function renderServers(sortKey){
                servers.DATA = _.sortBy(servers.DATA,sortKey||"name")
                document.getElementById("servers").innerHTML = Templater.compileTemplate(servers.TEMPLATE,servers.DATA)
            }
            renderServers()  
        </script>
        <div class="alert primary">
            <ol> Note:
                <li> Check IP given device name --> cmd ping [device name] </li>
                <li> Check device name given IP --> cmd tracert [IP]  </li>
            </ol>
        </div>

    </div>

    <div id="train$motor" class="">  
        <p class="bold uline"> Introduction to MOTOR base tables </p>
        <br>- BIZ0015, Custom Reports  
        <br>- TRX0001, Repairer/ Base  (Search for PK, FK)
        <br>- TRX0002, Adjuster        (Search for PK, FK)
        <br>- TRX0008, Insurer         (Search for PK, FK)
        <br>
        <div class="alert success">
            Note:
            On the job training (templates, reports)
        </div>
    </div>

    <div id="chktsql" class="">  
        <span class="bold uline"> Basic Questions </span>
        <br>What are:-
        <br>1. Datatypes in a table
        <br>2. Tables
        <br>3. Joins
        <br>
        <br><span class="bold uline"> Database Design Questions </span>
        <br>1. What are table constraints?          
        <br>2. Explain the meaning of Foreign Key.  
        <br>3. Explain the meaning of Primary Key.  
        <br>4. What is an Identity Column?          
        <br>5. What is the purpose of separating data into tables?
        <br>6. What is are normal forms for?
        <br>
        <br><span class="bold uline"> Database Search/ Performance related Questions </span>
        <br>1. What are some of the algorithms used in DB search?
        <br>2. What is Binary Tree Search? Explain in brief its workings
        <br>3. What is Non-clustered Index?
        <br>4. What is Clustered Index?
        <br>5. What is sargability in Queries? Give two examples
        <br>
        <br><span class="bold uline"> Bitwise operations in TSQL </span>
        <br>1. What is the expected result of 4|(8&amp;(~32))?
        <br>2. AND operation is used for?
        <br>3. OR  operation is used for?
        <br>4. <b>Tutor</b> to explain the use of bitwise filter in <b>Merimen</b> <pre class="alert success monospaced">
-- use of bits in documents
select top 100 * from CLMD0010 -- table for claimtypes
select top 100 * from FOBJ3003 -- table for corole
select top 100 * from FDOC3001 -- table for documents
select top 100 * from FDOC3008 -- table to define companys document ownership (**bitwise claimtypemask)
select top 100 * from FDOC3010 -- table for document permission (**bitwise corole)

-- use of bits in labels
select top 100 * from fobjb3020 -- label definition (**bitwise corole) 
select top 100 * from fobjb3022 -- co ownership of label (**bitwise claimtype) </pre>
        <br>5. Work out the query for selecting document names that fulfill the following criteria:
        <br>- Editable documents that is applicable for all (icoid=0)                                                                                              
        <br>- Editable documents that is applicable for all (icoid=0) and claimtype that starts with 'TP' (iselector linked to CLM0010.iclmtypemask) and domain = 1
        <br>- Photos that is applicable for all (icoid=0) and claimtype that starts with 'TP' (iselector linked to CLM0010.iclmtypemask)                           
    </div>

    <div id="chkcf" class="">  
        Answer questions by assuming the following: 
        <br>
        <br>1. Write control statement (eg: &lt;cfif...&gt;...&lt;cfelse&gt;...&lt;/cfif&gt;)     
        <br>Variable "clmtype" of a case can hold any claimtype as above.
        <br>Variable "clmflow" is the first 2 characters from clmtype.
        <br>
        <br>1.1  Write expression to obtain "clmflow"
        <br>1.2  For claimtypes of TP and TP KFK, print out "Non of the selected claims is initiated by insured"                             
        <br>1.3  Print out HTML "Claim type must have GST%" if claim type starts with "OD..."                                                
        <br>1.4  Using bitwise filter, print out HTML "Non-motor hasnt got vehicle registeration number" if claim type starts with "NM..."   
        <br>1.5  Using a list function, print out "Pending for TP insurer's response" when claimtype is "TP" OR "TP KFK"                     
        <br>
        <br>2. Use a date function to perform the following:
        <br>Variable "dtAuth" is the date case has been authorised by insurer.
        <br>2.1 HTML "Its is ##days## from Insurer authorisation." days being the number of days since "dtauth"
        <br>2.2 Write control statement to print out "You have exceeded days to give a response." when its over 14 days from dtauth
        <br>2.3 Using the function DateCompare in CF, write ""
        <br>
        <br>3. Mathematical operations
        <br>Variables "mnclmtot1","mnclmtot2" represent total claims for case 1 and case 2
        <br>3.1 Select the highest number from these two values 
        <br>3.2 Select the lowest number from these two values 
        <br>3.3 Get the remainder of 10 divided by 2 
        <br>3.4 Get the quotient of 10 divided by 2 
        <br>
        <br>4. Use the Regular Expression (Ex) 
        <br>Variable "HTMLcontent1" is "&lt;p&gt;Tax Invoice issued on 22/05/2015&lt;/p&gt;"
        <br>Variable "HTMLcontent2" is "&lt;p&gt;Tax Invoice issued on 12/06/2015&lt;/p&gt;"
        <br>Variable "HTMLcontent3" is "&lt;p&gt;Tax Invoice issued on 24/03/2015&lt;/p&gt;"
        <br>4.1 Using regular expression in CF, replace all months in HTMLcontent1,HTMLcontent2,HTMLcontent3 to August(08) eg.&nbsp;HTMLcontent1, 22/08/2015
        <br>4.2 Using regular expression in CF, replace all "Tax Invoice" in HTMLcontent1,HTMLcontent2,HTMLcontent3 to "Invoice"
        <br>4.3 Using regular expression in CF, replace all "Tax Invoice" in HTMLcontent1,HTMLcontent2,HTMLcontent3 to "<b>Tax&nbsp;Invoice</b>" 
        <br>
        <br>5. Structure
        <br>Variable "claimtype" is the claimtypemask value of current case.
        <br>5.1 Build a structure of all claimtypes (with reference to table1) with claim_type is key and claimtype_mask is the value
        <br>5.2 Using bitwise filter, print out claim type name of current case
        <br>
        <br>6. Array Functions
        <br>6.1 Loop through structure in 7.1, append into an array all claimtypes bitwise-filtered by 4460544   
        <br>6.2 Print the content of array into a HTML paragraph each.
        <br>
        <br>7. Scopes
        <br>Explain the difference between
        <br>7.1 application scopes/ session scope
        <br>7.2 session scope/ request scope 
        <br>7.3 request scope/ form scope
        <br>
        <br>8. Directory
        <br>8.1 Create a dummy directory in your web folder and create a few dummy files 
        <br>8.2 use cfdirectory to list files
        <br>8.3 use cffile to upload and write files into that directory
        <br>
        <br>9. Dynamic inclusions
        <br>9.1 cfmodule/ cfinclude what are the differences?
        <br>
        <br>10. CF application framework
        <br>Write down the sequence of execution when a script filename is called.
        <br>Example: 
        <br>1. index.cfm
        <br>2. anothertext.cfm
    </div>

    <div id="chkjs" class="">  
        Spend 1 hour
        <br>1. Similarities/ difference between radio and checkbox
        <br>2. Difference between text box and text field
        <br>3. Similarties/ diff between radio and drop down box
        <br>4. What are the different attributes to HTML form?
    </div>
<!--- 
    <div id="page3" class="">  
</div>
--->

    <div id="train" class="">  
        <h4> Merimen Quick Train </h4> <br>
        <p> This is a generic training flow to expose Trainees without any firm foundation 
            to common technologies that Merimen manipulates to deliver its online system to clients.
        </p><br>
        <p> Its a 14~Day training for  
            <ol>
                <li>Structured Query Language, <b>SQL</b> </li>
                <li>ColdFusion, <b>CF</b> </li>
                <li>Hypertext Markup Language, <b>HTML</b></li>
                <li>Javascript, <b>JS</b></li>
                <li>Cascading Style Sheet, <b>CSS</b></li>
            </ol>
        </p> <br>
        <p>
            <b><em>This is NOT...</em></b> 
            a comprehensive treatment towards mastering the said technologies, 
            merely a means of introduction so <b>Trainees</b> are equipped to conduct self-paced, 
            independent and further learning.
        </p> <br>
        <hr> <br>
        <h4> Merimen Quick Train Structure </h4> <br>
        <table class="table table-striped table-bordered">
            <thead>
                <tr>
                    <th style="width:10%">Day</td>
                    <th style="width:90%">&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Day 1</td>
                    <td><p class="bold uline">Activities</p>
                        <p>1 Basecamp <em class="bold">(approx. 5 hours)</em></p>
                        <p>1.1 Introduction to Merimen Colleagues</p>
                        <p>1.2 Establish <a href="javascript:Navbar.writeURL2({route:'public.mesra',tabState$navH$tabs:'tabber$staffcontacts'})">skype contact</a> with office colleagues</p>
                        <p>1.3 Ensure the following is done. Consult Lim (super admin) if otherwise. 
                            <br>--- tools in local machine are <a href="javascript:Tab.selectSinglePageByTab(document.getElementById('tabber$day1'))">setup properly</a>
                            <br>--- possess rights to manipulate IIS (elevated priviledge in Windows)
                            <br>--- possess rights to manipulate CF (elevated priviledge in Windows, CF username, CF password)
                            <br>--- possess rights to manipulate SVN (username, password)
                        </p><br>
                        <p>2 Introduction to Merimen System: Claims Workflow <em class="bold">(approx. 2 hours)</em></p>
                        <p>2.1 <b>Trainee</b> to go one round through the workflow</p> <br>
                        <p class="bold uline"> Learning Outcome </p>
                        <p>
                            <b>Trainee</b> is able to identify a few important steps/ processes 
                            in claims corresponding to 
                            <br>-- Repairer
                            <br>-- Insurer
                            <br>-- Adjuster
                        </p>

                    </td>
                </tr>
                <tr>
                    <td>Day 2</td>
                    <td>
                        <p class="bold uline"> Activity </p>
                        <p>1. Revision on basic SQL construction <em class="bold">(approx. 1~2 days)</em></p>
                        <p>2. Revision on bitwise operation</p>
                        <p>3. Tutor to explain use of bitwise column in Merimen databse</p>
                        <p>4. Attempt <a href="javascript:Tab.selectSinglePageByTab(document.getElementById('tabber$chktsql'))">Checkpoint Quiz: TSQL</a> </p>
                        <br>
                        <p class="bold uline">Resources</p>
                        <p>1 Revision on SQL</p>
                        <p>1.1 <a href="http://sol.gfxile.net/g3/">SQL Galaxy</a></p>
                        <p>1.2 <a href="http://www.w3schools.com/sql/">W3Schools</a></p>
                        <br>
                        <p>2.Readups on SQL Joins </p>
                        <p>2.1 <a href="http://www.sql-join.com/">What is a SQL Join?</a></p>
                        <p>2.2 <a href="http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/">A Visual Explanation of SQL Joins</a></p>
                        <br>
                        <p>3 Online SQL Editor </p>
                        <p>3.1 <a href="http://sqlfiddle.com/"> sqlfiddle:</a></p>
                        <br>
                        <p class="bold uline">Learning Outcome</p>
                        <p>
                            1. <b>Trainee</b> should be comfortable with basic CRUD operation syntax
                            <br> -- Create table
                            <br> -- Select statements (single and multiple)
                            <br> -- Update statements
                            <br> -- Delete statements
                        </p> <br>

                        <p>
                            2. <b>Trainee</b> should be able to manipulate common aggregation functions 
                            (sum, average, min, max, group by clause) in SQL statement 
                        </p> <br>

                        <p>
                            3. <b>Trainee</b> should be able to construct/ differentiate use of various joins
                            <br> -- left join
                            <br> -- inner join
                            <br> -- right join
                        </p> <br>

                        <p>
                            4. Extra: <b>Trainee</b> can manipulate set based operations  
                            <br> -- Union
                            <br> -- Union All
                            <br> -- Intersect
                            <br> -- Except
                        </p> <br>
                        <p class="bold">Note: </p>
                        <p>1. Search database catalogue</p>
                        <p>2. Remember that Merimen database prefix fielnames with datatype</p>
                        <pre class="alert success monospaced">
select * 
from information_schema.tables 
where table_name like "%search term%

select * 
from information_schema.columns 
where 
column_name like "%search term%
and table_name like "%search term%
                        </pre>
                    </td>
                </tr>
                <tr>
                    <td>Day 4</td>
                    <td>
                        <p>Activities </p>
                        <p>1. Intro to SQL Server Management Studio, SSMS <em class="bold">(approx. 2 hours)</em></p>
                        <p>2. Configure SSMS for Remote Debugger (open firewall ports) <em class="bold">(approx. 1 hours)</em> 
                        <div class="alert success monospaced">
                            Program Path : C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Binn\ManagementStudio\Ssms.exe
                            Outbound Port: TCP 135
                            Inbound Port : TCP any/ UDP 500, 4500 </pre>
                        </div>
                        <p>3. Install <a href="https://www.red-gate.com/products/sql-development/sql-search/">RedGate Search</a> <em class="bold">(approx. 1 hours)</em></p>
                        <p>4. Optional install of custom plugins: TSqlFlex, BridgeSQL <em class="bold">(approx. 1 hours)</em>
                            <div class="alert success monospaced"> \\FILESERVER\software\SSMS_plugins </div>
                        </p>
                        <p>5. Learn important DB servers on <a href="javascript:Tab.selectSinglePageByTab(document.getElementById('tabber$infra'))">office networked servers</a> <em class="bold">(approx. 1 hours)</em></p>
                    </td>
                </tr>
                <tr>
                    <td>Day 5</td>
                    <td>
                    <p class="bold uline">Activities</p>
                    <p>1. Using SSMS to analyse Functions and Stored procedures, analyse the following <em class="bold">(approx. 6 hours)</em></p> 
                    <p>a. <em>Functions</em></p>
                    <p>a.1 fWKDay           </p>
                    <p>a.2 fSVCdt           </p>
                    <p>a.3 StringToTable    </p>
                    <p>a.4 StringToTableInt </p> 
                    <br>
                    <p>b. <em>Stored Procedures</em></p>
                    <p>b.1 sspTRXSolPayment (Note the use of transaction)</p>
                    <p>b.2 sspBILGenRevenue (Note the use of cursor)</p>
                    <br>
                    <p>2 Reading up on Transactions and Cursors <em class="bold">(approx. 6 hours)</em></p>
                    <br>
                    <p class="bold uline">Resources</p>
                    <p>1. Transactions</p>
                    <p>1.1 <a href="http://www.blackwasp.co.uk/SQLTransactions.aspx">Using Transactions in SQL Server</a> </p>
                    <p>1.2 <a href="http://www.sqlteam.com/article/introduction-to-transactions">Introduction to Transactions</a> </p>
                    <p>2. Cursors</p>
                    <p>2.1 <a href="http://stevestedman.com/2013/04/t-sql-a-simple-example-using-a-cursor/">T-SQL: A Simple Example Using a Cursor</a></p>
                    <p>2.2 <a href="https://www.mssqltips.com/sqlservertip/1599/sql-server-cursor-example/">SQL Server Cursor Example</a></p>
                    <br>
                    <p class="bold uline">Learning Outcome</p>
                    <p>1. Able to create/ call functions in TSQL</p>
                    <p>2. Able to create/ call stored procedure in TSQL</p>
                    <p>3. Able to identify/ diff various transaction types</p>
                    <p>4. Able to manipulate cursors in TSQL</p>
                    <p>5. Differentiate cursor and set manipulation </p>
                    <br>
                    </td>
                </tr>
                <tr>
                    <td>Day 7</td>
                    <td>
                        <p class="bold uline"> Activities </p>
                        <p> 1. Focus on Coldfusion syntax and tags  <em class="bold">(approx. 2 days)</em></p>
                        <br>
                        <div class="alert success">
                        (Refer to Adobe Coldfusion 9 Web Application Construction Kit, Volumes 1, 2 and 3 PDF file)
                        <br>(Refer to \\gateway\docs\Development\Training)
                        </div>
                        <span class="bold uline">Chapter 1 : Introducing Coldfusion</span>
                        <br>
                        <br><span class="bold uline">Chapter 8: The Basics of CFML</span>
                        <br><b>Tags : </b>
                        <br>1. CFOUTPUT
                        <br>2. CFSET
                        <br>3. WHEN TO HASH AND WHEN NOT TO HASH (##)
                        <br>4. CFDUMP
                        <br>
                        <br><b>Functions : </b>
                        <br>1. DateFormat
                        <br>2. Reverse
                        <br>3. Len
                        <br>4. RepeatString
                        <br>5. UCase ... And other common string functions
                        <br>
                        <br><b>Data Structures : </b>					
                        <br>1. Lists
                        <br>2. Arrays
                        <br>3. Structures
                        <br>4. CGI Variables
                        <br>
                        <br><span class="bold uline">Chapter 9: Programming with CFML</span>
                        <br>1. If-Else
                        <br>2. Switch/Case
                        <br>3. Cfloop
                        <br>4. CFINCLUDE Tag
                        <br>
                        <br><span class="bold uline">Chapter 10: Creating Data-Driven Pages</span>   
                        <br><b>Tags : </b>
                        <br>1. CFQUERY
                        <br>2. CFOUTPUT GROUP
                        <br>3. CFLOCATION
                        <br>4. CFQUERYPARAM (Explain why this is important)
                        <br>5. CFPARAM (Explain why this is important)
                        <br>
                        <br><b>Functions : </b>
                        <br>1. ExpandImage()
                        <br>2. FileExists()
                        <br>3. URLEncodedFormat()
                        <br>4. IsDefined()
                        <br>
                        <br><span class="bold uline">Chapter 11: The Basics of Structured Development</span>   
                        <br><b>Tags : </b>
                        <br>1. CFCOMPONENT
                        <br>2. CFFUNCTION
                        <br>3. CFRETURN
                        <br>4. CFARGUMENT
                        <br>5. CFINVOKE
                        <br>
                        <br><span class="bold uline">Chapter 12: Coldfusion Forms</span>
                        <br>Learn about form submission, form variables, url variables, and checking for undefined variables.</ul>
                        <br>
                        <br><span class="bold uline">Chapter 16: Graphing Printing and Reporting [Page 344-353]</span>
                        <br>Creating Printable Pages (CFDOCUMENT)
                        <br>
                        <br><span class="bold uline">Chapter 17: Debugging and Troubleshooting</span>
                        <br>Please go through this entire chapter to learn how to debug effectively with Coldfusion
                        <br>
                        <br><span class="bold uline">Chapter 19: Working with Sessions [Pages 457-471]</span> 
                        <br>1. Using Session Variables 
                        <br>2. Installation of CFMLReference on localhost for fast function/tag reference. 
                            <div class="alert success monospaced">
                                [\\gateway\docs\Development\Training\Reference ]
                            </div>
                        <br>
                        <p class="bold uline"> Resources </p>
                        <p>1. Online CF Editor</p>
                        <p>1.1 <a href="http://trycf.com/scratch-pad">TryCF</a></p>
                        <br>
                        <p>2. RegEx</p>
                        <p>2.1 <a href="http://www.regexr.com/">REGEXR: Online Interactive RegEx Editor</a></p>
                        <p>2.2 <a href="http://cflove.org/2012/10/simple-regular-expression-tutorial-for-coldfusion-developers.cfm">The Most Simplified Regular Expression Tutorial In The World</a></p>
                        <p>2.3 <a href="http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WSc3ff6d0ea77859461172e0811cbec0a38f-7ffb.html">Regular expression syntax</a></p>
                        <br>
                    </td>
                </tr>
                <tr>
                    <td>Day 10</td>
                    <td>
                        <p class="bold uline">Activities</p>
                        <p>1. Demonstrate pages called on CF application <em class="bold">(approx. 5 hours)</em></p>
                        <p>1.1 <b>Tutor</b> to explain/ demonstrate Merimen fusebox routing mechanism</p>
                        <p>1.1 <b>Tutor</b> to give example of Merimen fusebox routing</p>
                        <p>2. Readup on CF application framework routing <em class="bold">(approx. 4 hours)</em></p>
                        <br>
                        <p class="bold uline">Resources</p>
                        <p>1. CF Application Framework</p>
                        <p>1.1 <a href="http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WSc3ff6d0ea77859461172e0811cbec0c35c-7ffb.html">About persistent scope variables</a> </p>
                        <p>1.2 <a href="http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WSc3ff6d0ea77859461172e0811cbec22c24-7d6f.html">Structuring an application</a> </p>
                        <br>
                        <p class="bold uline">Learning Outcome</p>
                        <p>1. <b>Trainee</b> will be able to identify pages called when CF framework page is called.</p>
                        <p>2. <b>Trainee</b> will be able to identify pages called when Merimen custom fusebox routing is called.</p>
                    </td>
                </tr>
                <tr>
                    <td>Day 11</td>
                    <td>
                        <p class="bold uline">Activity</p>
                        1. HTML: Quick revision on HTML form control elements  <em class="bold">(approx. 3 hours)</em>
                        <br>-- drop down box
                        <br>-- radio buttons
                        <br>-- checkboxes
                        <br>-- text box
                        <br>-- text field
                        <br>-- attach documents
                        <br>
                        <br>2. CSS: Quick review of styling  <em class="bold">(approx. 5 hours)</em>
                        <br>-- CSS selectors (id, classes, elements, pseudo-states)
                        <br>-- CSS selector specificity and sequence of priority
                        Note:
                        <div class="alert success">
                            1. Jquery uses similar selector to select elements
                        </div>
                        <br><p class="bold uline">Resources</p>
                        1. <a href="http://www.w3schools.com/html/">W3Schools</a>
                        <br>
                        <br> <p class="bold uline">Learning Outcome</p>
                        1. Able to write a document in HTML format
                        <br>2. Able to write a form with various form controls 
                        <br>3. Determine the style applied to element (base on CSS specificity)
                        <br>4. Identify common CSS style declarations
                    </td>
                </tr>
                <tr>
                    <td>Day 12</td>
                    <td>
                        <p class="bold uline"> Activity </p>
                        1. JS  <em class="bold">(approx. 16 hours)</em>
                        <br>1.1 Learn to manipulate DOM using JS
                        <br>1.2 learning how to use the 
                        <br>1.2.1 chrome tool
                        <br>1.2.2 firefox: firebug plugin
                        <br>
                        <br> <p class="bold uline"> Learning Outcome </p>
                        1. Javascript to manipulate HTML form element 
                        <br>2. String manipulation
                        <br>3. Regular expression
                        <br>4. Write Javascript functions
                        <br>5. Attach HTML event listeners
                        <br>6. Use JQuery library
                        <br>
                        <br> <p class="bold uline">Resources</p>
                        Articles
                        <br>1. <a href="http://code.tutsplus.com/tutorials/javascript-and-the-dom-series-lesson-1--net-3134">javascript-and-the-dom-series-lesson-1</a>
                        <br>2. <a href="http://code.tutsplus.com/tutorials/javascript-and-the-dom-lesson-2--net-3669">javascript-and-the-dom-lesson-2</a>
                        <br>
                        <br>Video Tutorials
                        <br>1. <a href="http://code.tutsplus.com/tutorials/javascript-from-null-video-series--net-8066">javascript-from-null-video-series</a>
                        <br>2. <a href="https://www.codeschool.com/courses/discover-devtools/videos">Debugging using Chrome Tools</a>
                        <br>                        
                        <br>Online JS editor/ compiler
                        <br>1. <a href="https://jsbin.com/">JSBIN</a>
                    </td>
                </tr>
                <tr>
                    <td>Day 14</td>
                    <td>
                        <p class="bold uline">Activity</p>
                        1. SVN training
                        <br>1.1 SVN add (file and directory considered separate entity)
                        <br>1.2 SVN commit
                        <br>1.3 SVN revert
                        <br>1.4 SVN lock
                        <br>1.5 SVN merge 
                        <br>1.6 SVN log (diagnose origin of bug)
                        <br>1.7 SVN blame (diagnose origin of bug)
                        <br>2. Introduction to Staging servers and different environments
                        <div class="alert success">
                            Note: <br>Ensure <b>Trainee</b> has access using their username + password
                        </div>
                        <br><p class="bold uline">Learning Outcome</p>
                        1. Able to maneuver freely in source tree
                        <br>2. Able to diagnose problem source of bug
                        <br>
                        <br><p class="bold uline">Resources</p>
                        1. <a href="http://svnbook.red-bean.com/">SVN Online Book</a>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
<!--- 
    <div id="page4" class="">  </div>
--->
</div>
</cfoutput>
