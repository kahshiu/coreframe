<!---
<cfoutput>
    #application.util.CFCs.templater.compiler(request.dataF.links)#
</cfoutput>     
--->
<cfoutput>
<div id="test">
</div>



<!--- navH --->
<!---
<navbar :model="navH$model"> </navbar>

<script type="text/x-template" id="t-navbar">
<ul>
    <li v-for="item in model">
        <div> {{item.node}} <span v-show="test($index)"> [ {{item.expanded?"-":"+"}} ] </span> </div>
        <navbar v-if="item.children && item.children.length" :model="item.children"></navbar>
    </li>
</ul>
</script>

<script>
Vue.config.debug = true
Vue.component("navbar",{
    template: "##t-navbar"
    ,props:{
        model: Array
    }
    ,computed:{
        showAnchor: function (a,b,c) {
        }
    }
    ,methods: {
        toggle: function () {
            this.open = !this.open;
        }
        ,test: function (index) {
console.log(this.model)
            //return _.has(this.model.children(index),"expanded")
        }
    }
})
vueGlobal._data.navH$model=[
    {
        node:"node1"
        ,expanded:true
        ,children:[
            {node:"c1"}
            ,{node:"c2"}
            ,{node:"c3"}
            ,{node:"c4"}
        ]
    }
    ,{
        node:"node2"
        ,expanded:true
        ,children:[
            {node:"c1"}
            ,{node:"c2"}
            ,{node:"c3"}
            ,{node:"c4"}
        ]
    }
]
vueGlobal._methods.navH$alert=function(){
}
</script>
--->
</cfoutput>
