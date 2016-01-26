<cfsilent>
    <cfset currentContent = request.html>
</cfsilent>
<cfoutput>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title></title>
        <link rel="stylesheet" href="css/bijou.css">
        <link rel="stylesheet" href="css/appMain.css">
        <!--- <link rel="shortcut icon" href="/favicon.png" type="image/x-icon"> --->    

        <script type="text/javascript" charset="utf-8" src="js/jquery-1.12.0.min.js"></script>
        <script type="text/javascript" charset="utf-8" src="js/underscore-min.js"></script>
        <script type="text/javascript" charset="utf-8" src="js/appMain.js"></script>
        #application.util.CFCs.routing.getHTML("templates","jsTemplates")# 
    </head>
    <body id="container"> 
        #currentContent# 
        <script type="text/javascript" charset="utf-8" src="js/appPost.js"></script>
    </body>
</html>
</cfoutput>

