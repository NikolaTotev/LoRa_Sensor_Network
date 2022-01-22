(this["webpackJsonpclient-app"]=this["webpackJsonpclient-app"]||[]).push([[0],{182:function(e,t,n){"use strict";n.r(t);var a=n(0),r=n.n(a),c=n(29),i=n.n(c),o=n(7),s=n(288),u=n(292),l=n(291),j=n(107),d=n(290),b=n(138),p=n(293),x=n(134),O=n.n(x),f=n(281),h=n(285),m=n(22),g=n(2),v=[{name:"Home",link:"/home"},{name:"Stations",link:"/stations"},{name:"History",link:"/history"}];function w(){var e=r.a.useState(null),t=Object(o.a)(e,2),n=t[0],a=t[1],c=Object(m.g)(),i=function(e){a(null),c(e)};return Object(g.jsx)(s.a,{position:"static",children:Object(g.jsx)(d.a,{maxWidth:"xl",children:Object(g.jsxs)(l.a,{disableGutters:!0,children:[Object(g.jsx)(j.a,{variant:"h6",noWrap:!0,component:"div",sx:{mr:5,display:{xs:"none",md:"flex"}},children:"LoRa Sensor Network"}),Object(g.jsxs)(u.a,{sx:{flexGrow:1,display:{xs:"flex",md:"none"}},children:[Object(g.jsx)(p.a,{size:"large","aria-label":"account of current user","aria-controls":"menu-appbar","aria-haspopup":"true",onClick:function(e){a(e.currentTarget)},color:"inherit",children:Object(g.jsx)(O.a,{})}),Object(g.jsx)(b.a,{id:"menu-appbar",anchorEl:n,anchorOrigin:{vertical:"bottom",horizontal:"left"},keepMounted:!0,transformOrigin:{vertical:"top",horizontal:"left"},open:Boolean(n),onClose:function(){a(null)},sx:{display:{xs:"block",md:"none"}},children:v.map((function(e){return Object(g.jsx)(f.a,{onClick:function(){return i(e.link)},children:Object(g.jsx)(j.a,{textAlign:"center",children:e.name})},e.name)}))})]}),Object(g.jsx)(j.a,{variant:"h6",noWrap:!0,component:"div",sx:{flexGrow:1,display:{xs:"flex",md:"none"}},children:"LoRa Sensor Network"}),Object(g.jsx)(u.a,{sx:{flexGrow:1,display:{xs:"none",md:"flex"}},children:v.map((function(e){return Object(g.jsx)(h.a,{onClick:function(){return i(e.link)},sx:{my:2,color:"white",display:"block"},children:e.name},e.name)}))})]})})})}var S=n(116),y=n(271),k=n(274),D=n(25),C=n(98),E=Object(a.createContext)(null);function I(e){var t=e.children,n="".concat(C.a.API_URL,"/socket"),r=Object(a.useState)(!0),c=Object(o.a)(r,2),i=c[0],s=c[1],u=(new k.a).withUrl(n,{skipNegotiation:!0,transport:D.a.WebSockets}).withAutomaticReconnect().build();return Object(a.useEffect)((function(){"Connected"!==u.state&&u.start().then((function(e){s(!1)}))})),Object(g.jsx)(E.Provider,{value:{socket:u,loading:i},children:t})}function R(){return Object(a.useContext)(E)}var W=n(295);function T(e){var t=e.loading,n=e.error,a=e.children;return t?Object(g.jsx)(u.a,{m:4,textAlign:"center",children:Object(g.jsx)(W.a,{})}):n?Object(g.jsx)(u.a,{m:4,textAlign:"center",children:n.message}):Object(g.jsx)(g.Fragment,{children:a()})}function L(){var e=R().socket,t=Object(a.useState)({averageTemperature:"",averageHumidity:"",lastUpdate:""}),n=Object(o.a)(t,2),r=n[0],c=n[1];return Object(a.useEffect)((function(){e.on("SetAverageData",(function(e){c(e)}))})),Object(a.useEffect)((function(){"Connected"===e.state&&e.invoke("SendAverageData")})),Object(g.jsx)(g.Fragment,{children:Object(g.jsx)(T,{loading:""===r.lastUpdate,error:null,children:function(){return Object(g.jsxs)(d.a,{maxWidth:"md",sx:{display:"flex",alignItems:"center",flexFlow:"column",marginTop:3},children:[Object(g.jsx)(j.a,{variant:"h2",gutterBottom:!0,component:"div",sx:{color:"#0d47a1"},children:"Sofia"}),Object(g.jsx)(j.a,{variant:"h5",gutterBottom:!0,component:"div",align:"center",sx:{color:"#0d47a1"},children:"Last update:"}),Object(g.jsx)(j.a,{variant:"h5",gutterBottom:!0,component:"div",align:"center",sx:{color:"#0d47a1"},children:r.lastUpdate}),Object(g.jsx)(j.a,{variant:"h5",gutterBottom:!0,component:"div",align:"center",sx:{color:"#0d47a1"},children:"Avg. Temperature"}),Object(g.jsxs)(j.a,{variant:"h3",gutterBottom:!0,component:"div",align:"center",sx:{fontWeight:"bold",color:"#0d47a1"},children:[r.averageTemperature," \xb0C"]}),Object(g.jsx)(j.a,{variant:"h5",gutterBottom:!0,component:"div",align:"center",sx:{color:"#0d47a1"},children:"Avg. Humidity"}),Object(g.jsxs)(j.a,{variant:"h3",gutterBottom:!0,component:"div",align:"center",sx:{fontWeight:"bold",color:"#0d47a1"},children:[r.averageHumidity," %"]})]})}})})}var N=n(23),A=n(268),B=n(294),G=n(296),M=n(269),F=n(282),P=n(21),U=n(16),H=n.n(U);function J(e,t){var n=Object(a.useState)({data:null,loading:!0,error:null}),r=Object(o.a)(n,2),c=r[0],i=r[1],s=function(){var t=!1;return Object(P.a)(H.a.mark((function n(){var a;return H.a.wrap((function(n){for(;;)switch(n.prev=n.next){case 0:return n.prev=0,i({data:null,loading:!0,error:null}),n.next=4,e();case 4:a=n.sent,t||i({data:a,loading:!1,error:null}),n.next=11;break;case 8:n.prev=8,n.t0=n.catch(0),n.t0 instanceof Error&&!t&&i({data:null,loading:!1,error:n.t0});case 11:case"end":return n.stop()}}),n,null,[[0,8]])})))(),function(){t=!0}};return Object(a.useEffect)(s,t),Object(N.a)(Object(N.a)({},c),{},{reload:s})}var q=n(18),z=n(17),_=n(33),V=n(34),K=function(e){Object(_.a)(n,e);var t=Object(V.a)(n);function n(e,a){var r;Object(q.a)(this,n);var c=(null===a||void 0===a?void 0:a.message)||"Received status code ".concat(e.status);return(r=t.call(this,c)).name=void 0,r.name=(null===a||void 0===a?void 0:a.error.name)||"HttpError",r}return Object(z.a)(n)}(Object(z.a)((function e(t){Object(q.a)(this,e),this.message=t,this.name=void 0,this.stack=void 0,this.stack=(new Error).stack}))),Q=function(){function e(t){Object(q.a)(this,e),this.baseUrl=void 0,this.baseUrl=t}return Object(z.a)(e,[{key:"get",value:function(e){return this.request(e,{method:"GET"})}},{key:"post",value:function(e,t){return this.request(e,{method:"POST",headers:{"content-type":"application/json"},body:JSON.stringify(t)})}},{key:"request",value:function(){var e=Object(P.a)(H.a.mark((function e(t,n){var a,r;return H.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.next=2,fetch("".concat(this.baseUrl,"/").concat(t),n);case 2:if((a=e.sent).ok){e.next=10;break}return e.t0=K,e.t1=a,e.next=8,a.json();case 8:throw e.t2=e.sent,new e.t0(e.t1,e.t2);case 10:return r=a.json(),e.abrupt("return",r);case 12:case"end":return e.stop()}}),e,this)})));return function(t,n){return e.apply(this,arguments)}}()}]),e}(),X=new Q(C.a.API_URL),Y=function(){function e(){Object(q.a)(this,e)}return Object(z.a)(e,[{key:"getStationReadings",value:function(){var e=Object(P.a)(H.a.mark((function e(){return H.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.abrupt("return",X.get("api/SensorReadings"));case 1:case"end":return e.stop()}}),e)})));return function(){return e.apply(this,arguments)}}()},{key:"getStationList",value:function(){var e=Object(P.a)(H.a.mark((function e(){return H.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.abrupt("return",X.get("api/GetStationList"));case 1:case"end":return e.stop()}}),e)})));return function(){return e.apply(this,arguments)}}()},{key:"getSensorReadingsWindowed",value:function(){var e=Object(P.a)(H.a.mark((function e(t,n,a){return H.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.abrupt("return",X.get("api/StationSensorReadingsWindowed?startDate=".concat(t,"&endDate=").concat(n,"&stationId=").concat(a)));case 1:case"end":return e.stop()}}),e)})));return function(t,n,a){return e.apply(this,arguments)}}()}]),e}(),Z=new Y,$=n(273),ee=n(270),te=n(272),ne=n(289),ae=n(74),re=n(26),ce=n(300),ie=n(275);function oe(e){var t=e.stations,n=e.typesOfMeasurement,r=e.startDate,c=e.endDate,i=J(Object(P.a)(H.a.mark((function e(){var a;return H.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.next=2,Promise.all(t.map(function(){var e=Object(P.a)(H.a.mark((function e(t){var a,i;return H.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return a=j(t.supportedMeasurements).filter((function(e){return n.includes(e)})),e.next=3,Z.getSensorReadingsWindowed(r.toISOString(),c.toISOString(),t.stationID);case 3:return i=e.sent,e.abrupt("return",{station:t,readings:i,neededMeasurements:a});case 5:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}()));case 2:return a=e.sent,e.abrupt("return",a);case 4:case"end":return e.stop()}}),e)}))),[t,n,r,c]),s=i.data,u=i.loading,l=i.error;function j(e){return JSON.parse(e)}var d=Object(a.useState)([]),b=Object(o.a)(d,2),p=b[0],x=b[1];return Object(a.useEffect)((function(){if(s){var e=[];s.forEach((function(t){t.readings.forEach((function(n){var a=j(n.payload),r={};t.neededMeasurements.forEach((function(e){r["".concat(t.station.stationID,"-").concat(e)]=a[e]})),r.timeOfCapture=new Date(n.timeOfCapture),e.push(r)}))})),x(e)}}),[s]),Object(g.jsx)(T,{loading:u,error:l,children:function(){return p.length>0&&Object(g.jsx)(g.Fragment,{children:Object(g.jsx)(ne.a,{children:Object(g.jsxs)(ae.b,{data:p,children:[n.map((function(e){return Object(g.jsx)(re.l,{factory:ce.a,name:e},"scale-".concat(e))})),Object(g.jsx)(re.b,{factory:ie.a}),Object(g.jsx)(ae.a,{}),n.map((function(e){return Object(g.jsx)(ae.e,{scaleName:e,showGrid:!1,showLine:!0},"axis-".concat(e))})),s&&s.map((function(e){return e.neededMeasurements.map((function(t){return Object(g.jsx)(ae.d,{name:"".concat(e.station.stationName,"  ").concat(t),valueField:"".concat(e.station.stationID,"-").concat(t),scaleName:t,argumentField:"timeOfCapture"},"".concat(e.station.stationName,"  ").concat(t))}))})).flat(1),Object(g.jsx)(ae.c,{position:"bottom"})]})})})}})}function se(){var e=J((function(){return Z.getStationList()}),[]),t=e.data,n=e.loading,r=e.error,c=Object(a.useState)(-1),i=Object(o.a)(c,2),s=i[0],l=i[1],b=Object(a.useState)(""),p=Object(o.a)(b,2),x=p[0],O=p[1],m=R().socket,v=Object(a.useState)(""),w=Object(o.a)(v,2),S=w[0],y=w[1],k=Object(a.useState)(new Date),D=Object(o.a)(k,2),C=D[0],E=D[1],I=Object(a.useState)(new Date),W=Object(o.a)(I,2),L=W[0],P=W[1],U=Object(a.useState)(!1),H=Object(o.a)(U,2),q=H[0],z=H[1],_=Object(a.useState)([]),V=Object(o.a)(_,2),K=V[0],Q=V[1],X=Object(a.useState)([]),Y=Object(o.a)(X,2),ne=Y[0],ae=Y[1];Object(a.useEffect)((function(){m.on("SetLatestReading",(function(e){if("Connected"===m.state&&-1!==s&&t&&t[s]&&""!==x){var n=JSON.parse(e.payload);y(n[x])}}))})),Object(a.useEffect)((function(){"Connected"===m.state&&-1!==s&&t&&t[s]&&""!==x&&m.invoke("SendLatestReading",t[s].stationID)}));var re=function(e){O(e.target.value),z(!1),y("")},ce=function(){L&&C&&t&&t[s]&&""!==x&&(z(!0),Q([x]),ae([t[s]]))};return Object(g.jsxs)(d.a,{maxWidth:"lg",children:[Object(g.jsx)(j.a,{variant:"h3",gutterBottom:!0,component:"div",align:"center",sx:{color:"#0d47a1",marginTop:2},children:"Stations"}),Object(g.jsx)(T,{loading:n,error:r,children:function(){return t&&Object(g.jsxs)(A.a,{direction:"row",spacing:2,sx:{marginTop:3,border:"1 solid gray.500",borderRadius:"15px",boxShadow:"rgba(0, 0, 0, 0.24) 0px 3px 8px",padding:3},children:[Object(g.jsxs)(A.a,{direction:"column",spacing:3,sx:{marginTop:2},children:[Object(g.jsx)(B.a,{component:"nav",children:null===t||void 0===t?void 0:t.map((function(e,t){return Object(g.jsx)(G.a,{selected:s===t,onClick:function(e){return function(e,t){O(""),z(!1),y(""),l(t)}(0,t)},children:Object(g.jsx)(M.a,{primary:e.stationName})},e.stationID)}))}),t&&-1!==s&&Object(g.jsxs)(g.Fragment,{children:[Object(g.jsxs)(ee.b,{dateAdapter:$.a,children:[Object(g.jsx)(te.a,{label:"Start Date",value:C,onChange:function(e){z(!1),E(e)},maxDate:L,renderInput:function(e){return Object(g.jsx)(F.a,Object(N.a)({},e))}}),Object(g.jsx)(te.a,{label:"End Date",value:L,onChange:function(e){z(!1),P(e)},maxDate:new Date,minDate:C,renderInput:function(e){return Object(g.jsx)(F.a,Object(N.a)({},e))}})]}),Object(g.jsx)(F.a,{id:"measurement",select:!0,label:"Select",value:x,onChange:re,helperText:"Please select type of measurement",children:(e=t[s].supportedMeasurements,JSON.parse(e)).map((function(e){return Object(g.jsx)(f.a,{value:e,children:e},e)}))}),Object(g.jsx)(h.a,{variant:"outlined",onClick:ce,disabled:q,children:"Generate Chart"})]})]}),Object(g.jsxs)(u.a,{sx:{flexGrow:1,display:"flex",flexDirection:"column"},children:[-1!==s&&t&&t[s]&&""!==x&&Object(g.jsx)(g.Fragment,{children:Object(g.jsx)(T,{loading:""===S,error:null,children:function(){return Object(g.jsx)(g.Fragment,{children:Object(g.jsxs)(j.a,{variant:"h4",gutterBottom:!0,component:"div",align:"center",sx:{color:"#0d47a1"},children:["Live data: ",S]})})}})}),q&&Object(g.jsx)(u.a,{sx:{flexGrow:1},children:Object(g.jsx)(oe,{startDate:C,endDate:L,typesOfMeasurement:K,stations:ne})})]})]});var e}})]})}var ue=n(299),le=n(283),je=n(278),de=n(286),be=n(287),pe=n(63),xe={PaperProps:{style:{maxHeight:224,width:250}}};function Oe(e,t,n){return n.indexOf(e)===t}function fe(e,t,n){return{fontWeight:-1===t.indexOf(e)?n.typography.fontWeightRegular:n.typography.fontWeightMedium}}function he(){var e=Object(a.useState)(new Date),t=Object(o.a)(e,2),n=t[0],r=t[1],c=Object(a.useState)(new Date),i=Object(o.a)(c,2),s=i[0],l=i[1],b=J((function(){return Z.getStationList()}),[]),p=b.data,x=b.loading,O=b.error,m=Object(a.useState)([]),v=Object(o.a)(m,2),w=v[0],S=v[1],y=Object(a.useState)([]),k=Object(o.a)(y,2),D=k[0],C=k[1],E=Object(a.useState)(!1),I=Object(o.a)(E,2),R=I[0],W=I[1],L=Object(pe.a)();var B=function(e){var t=e.target.value;W(!1),C("string"===typeof t?t.split(","):t)},G=function(){s&&n&&p&&p.length>0&&D.length>0&&W(!0)};return Object(a.useEffect)((function(){if(p&&p.length){var e=p.map((function(e){return function(e){return JSON.parse(e)}(e.supportedMeasurements)})).flat(1).filter(Oe);S(e)}}),[p]),Object(g.jsxs)(d.a,{maxWidth:"lg",children:[Object(g.jsx)(j.a,{variant:"h3",gutterBottom:!0,component:"div",align:"center",sx:{color:"#0d47a1",marginTop:2},children:"History"}),Object(g.jsx)(T,{loading:x,error:O,children:function(){return Object(g.jsxs)(A.a,{direction:"row",spacing:2,sx:{marginTop:3,border:"1 solid gray.500",borderRadius:"15px",boxShadow:"rgba(0, 0, 0, 0.24) 0px 3px 8px",padding:3},children:[Object(g.jsxs)(A.a,{direction:"column",spacing:3,sx:{marginTop:2},children:[Object(g.jsxs)(ee.b,{dateAdapter:$.a,children:[Object(g.jsx)(te.a,{label:"Start Date",value:n,onChange:function(e){W(!1),r(e)},maxDate:s,renderInput:function(e){return Object(g.jsx)(F.a,Object(N.a)({},e))}}),Object(g.jsx)(te.a,{label:"End Date",value:s,onChange:function(e){W(!1),l(e)},maxDate:new Date,minDate:n,renderInput:function(e){return Object(g.jsx)(F.a,Object(N.a)({},e))}})]}),Object(g.jsxs)(ue.a,{sx:{width:300},children:[Object(g.jsx)(le.a,{id:"multiple-chip-label",children:"Type"}),Object(g.jsx)(je.a,{labelId:"multiple-chip-label",id:"multiple-chip",multiple:!0,value:D,onChange:B,input:Object(g.jsx)(de.a,{id:"select-multiple-chip",label:"Chip"}),renderValue:function(e){return Object(g.jsx)(u.a,{sx:{display:"flex",flexWrap:"wrap",gap:.5},children:e.map((function(e){return Object(g.jsx)(be.a,{label:e},e)}))})},MenuProps:xe,children:w.map((function(e){return Object(g.jsx)(f.a,{value:e,style:fe(e,D,L),children:e},e)}))})]}),Object(g.jsx)(h.a,{variant:"outlined",onClick:G,disabled:R,children:"Generate Chart"})]}),R&&Object(g.jsx)(u.a,{sx:{flexGrow:1},children:Object(g.jsx)(oe,{startDate:n,endDate:s,typesOfMeasurement:D,stations:p})})]})}})]})}function me(){return Object(g.jsx)(S.a,{children:Object(g.jsxs)(I,{children:[Object(g.jsx)(y.a,{}),Object(g.jsx)(w,{}),Object(g.jsxs)(m.d,{children:[Object(g.jsx)(m.b,{path:"/home",element:Object(g.jsx)(L,{})}),Object(g.jsx)(m.b,{path:"/history",element:Object(g.jsx)(he,{})}),Object(g.jsx)(m.b,{path:"/stations",element:Object(g.jsx)(se,{})}),Object(g.jsx)(m.b,{path:"*",element:Object(g.jsx)(m.a,{replace:!0,to:"/home"})})]})]})})}i.a.render(Object(g.jsx)(me,{}),document.getElementById("root"))}},[[182,1,2]]]);
//# sourceMappingURL=main.32a238ff.chunk.js.map