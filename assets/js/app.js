// Generated by CoffeeScript 1.6.3
(function(){var e,t,n,r,i,s,o,u,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S,x,T,N,C,k,L,A,O,M,_,D,P,H,B,j,F,I,q,R,U,z,W,X,V,J;u="//www-cdn.jtvnw.net/swflibs/TwitchPlayer.swf";a="https://api.twitch.tv/kraken/streams/";o="http://webchat.quakenet.org/?channels=GBXL&uio=MT1mYWxzZSYyPXRydWUmND10cnVlJjg9ZmFsc2UmOT10cnVlJjEwPXRydWUmMTE9MzY5JjE0PWZhbHNlac";n=300;t=42;c=0;r=0;h=0;i=0;p=0;s=0;e=252;l=3e5;f=9e4;w={enable_javascript:"true",fullscreen_click:"true",video_width:"427",video_height:"240",embed:1,initCallback:"",channel:""};B={allowFullScreen:"true",allowscriptaccess:"always",wmode:"opaque"};v={"class":"layoutElement"};g="";m="irc";H=0;P=[];D=null;T=/(iPad|iPhone|iPod)/g.test(navigator.userAgent);z={stream1:!1,stream2:!1,stream3:!1};j={stream1:"",stream2:"",stream3:""};L=function(){var e,t,n,r,i,s,o;if(window.playerChannels!=null)for(n in j){o=j[n];if(window.playerChannels.hasOwnProperty(n)&&window.playerChannels!=null){window.playerChannels[n].trim();if(window.playerChannels[n]!==""){j[n]=window.playerChannels[n].toLowerCase();z[n]=!0}}}r=x("1");i=x("2");s=x("3");t=x("layout");if(r!=null){j.stream1=r.toLowerCase();z.stream1=!0}if(i!=null){j.stream2=i.toLowerCase();z.stream2=!0}if(s!=null){j.stream3=s.toLowerCase();z.stream3=!0}t==null&&(t="threeUp");if(j.stream2===j.stream1){j.stream2="";z.stream2=!1}if(j.stream3===j.stream1){j.stream3="";z.stream3=!1}if(j.stream3===j.stream2){j.stream3="";z.stream3=!1}$("#chat-irc").show();e=$.cookie("first_visit");if(!e){$.cookie("first_visit","true",{expires:3,path:"/"});$(".first-alert").show()}else{P.push("<strong>Welcome Back!</strong>");P.push('The Giant Bomb Extra Life marathon rages on! Don\'t forget to <strong><a href="http://www.extra-life.org/team/giantbomb">DONATE</a></strong>.')}for(n in z){o=z[n];o===!1&&(j[n]=S())}return setupLayout(t)};N=function(){var e,t,n,r,i,s,o,u,a;s=0;for(r in z){u=z[r];u===!0&&++s}a=[];for(r in z){u=z[r];if(u!==!1)continue;e=j[r];t=$("div[data-channel='"+e+"']");n=t.find("p.live").hasClass("on-air")?!0:!1;o=parseInt(r.charAt(r.length-1));if(!n&&H+s>=o){i=S();a.push(swapStream(r,i))}else a.push(void 0)}return a};C=function(){$(".alert").bind("closed.bs.alert",function(){return setTimeout(y,100)});$("a[href='#info-content']").click(function(){$("#content-nav li a.active").removeClass("active");$("#content-nav li a[href='#info-content']").addClass("active");$("#stream-index").hide(0);return $("#info-content").show(0,function(){return $("html, body").animate({scrollTop:$(window).height()},400)})});$("a[href='#stream-index']").click(function(){$("#content-nav li a.active").removeClass("active");$("#content-nav li a[href='#stream-index']").addClass("active");$("#info-content").hide(0);return $("#stream-index").show(0,function(){return $("html, body").animate({scrollTop:$(window).height()},400)})});$("li.top-link a").click(function(){return $("html, body").animate({scrollTop:0},400)});$("a.tweet-link").click(function(e){var t;e.preventDefault();t=$(this).attr("href");return window.open(t,"twitterwindow","height=450, width=550, top="+($(window).height()/2-225)+", left="+$(window).width()/2+", toolbar=0, location=0, menubar=0, directories=0, scrollbars=0")});$("a.fullscreen-link").click(function(){if(screenfull.enabled)return screenfull.toggle()});$("a.alertDismiss").click(function(){P=[];return $("#liveAlerts").fadeOut("fast")});if(!T){$("#main-nav").find(".fullscreen-link").tooltip({title:"Toggle Fullscreen",placement:"bottom"});$("#main-nav").find(".liveStreamCount").tooltip({title:"Click to View Full List",placement:"bottom"});$("#main-nav").find(".info-link").tooltip({title:"Click to Find Out More",placement:"bottom"});$("a[data-chat='irc']").tooltip({title:"View IRC Chat",placement:"bottom"})}$(".footer-logo").popover();$("#info-navbar").affix({offset:{top:function(){return $(window).height()+20}}});$(".overlay-move").draggable({revert:"valid",revertDuration:0,stack:".streamOverlay",iframeFix:!0,cursorAt:{top:10,right:10},zIndex:2e3,start:function(e,t){return $(this).parent().css("z-index",2e3)},stop:function(e,t){$(this).parent().css("z-index","");return $(this).css({top:"",left:""})}});return $(".streamOverlay").droppable({accept:".overlay-move",activeClass:"drop-active",hoverClass:"drop-hover",drop:function(e,t){var n,r,i,s;n=t.draggable.parent().attr("id");r=n.replace("Overlay","");i=$(this).attr("id");s=i.replace("Overlay","");if(s!==r)return swapStream(s,j[r])}})};k=function(){var e,t,n,r;Handlebars.registerHelper("toLowerCase",function(e){return e.toLowerCase()});n=$("#index-template").html();r=Handlebars.compile(n);e={users:window.users};t=r(e);window.users=null;$("#stream-container").append(t);$(".index-entry:nth-child(4n+5)").css("clear","both");return $(".index-entry").each(function(){return q($(this).attr("data-channel"))})};F=function(){var e,t,n;if(P.length===0)return $("#liveAlerts").fadeOut("fast",function(){return setTimeout(F,f)});n=$("#liveAlerts");t=n.find("p").eq(0);e=P.shift();return $("#liveAlerts").fadeIn("fast",function(){return t.hide(function(){var r,i;t.html(e);i=t.width();r=n.width()-90;return i<=r?t.fadeIn("fast").delay(3e3).fadeOut("fast",function(){return F()}):t.fadeIn("fast").delay(1500).animate({left:r-i-10+"px"},(i-r)*10,"linear",function(){return t.delay(1500).fadeOut("fast",function(){t.css("left","0");return F()})})})})};q=function(e){return $.ajax({type:"GET",dataType:"jsonp",crossDomain:!0,headers:{Accept:"application/vnd.twitchtv.v2+json"},url:a+e,success:function(t){var n,r,i,s,o,u,a;a=t.stream;r=$("div[data-channel='"+e+"']");s=r.find(".gb-username").text();o=r.find("p.live").hasClass("on-air")?!0:!1;if(a==null&&o===!0){r.removeClass("on-air");r.find("p.live").removeClass("on-air");r.find(".stream-pic").removeClass("on-air");r.find("h2").text("Off-Air");r.find(".game-title").text("nothing at the moment");$("#stream-container").append(r);$(".index-entry").css("clear","none");$(".index-entry:nth-child(4n+5)").css("clear","both");--H;return I()}if(a!=null&&o===!1){u=a.channel.game;u==null&&(u="something");r.addClass("on-air");r.find("p.live").addClass("on-air");r.find(".stream-pic").addClass("on-air");r.find("h2").text(a.channel.status);r.find(".stream-pic").attr("src",a.preview.medium);r.find(".game-title").text(u);$("#stream-container").prepend(r);$(".index-entry").css("clear","none");$(".index-entry:nth-child(4n+5)").css("clear","both");++H;I();n="<strong>"+s+"</strong> is now LIVE playing "+u+".";return P.push(n)}if(a!=null){i=r.find(".game-title").text();u=a.channel.game;u==null&&(u="something");r.find("h2").text(a.channel.status);r.find(".stream-pic").attr("src",a.preview.medium);r.find(".game-title").text(u);if(i!==u){n="<strong>"+s+"</strong> switched to playing "+u+".";return P.push(n)}}},complete:setTimeout(function(){return q(e)},f)})};I=function(){return H>0?$(".liveStreamCount").html(H+' Streams Are <span class="on-air-count">LIVE!</span> <i class="fa fa-chevron-circle-down"></i>'):$(".liveStreamCount").html('Live Streams <i class="fa fa-chevron-circle-down"></i>')};y=function(){return setupLayout(g)};U=function(){var e,o,u,a,f,l;a=$("#streams-wrapper");n=300;c=a.width()-n;r=c*9/16+28;h=a.width()/2;i=h*9/16+28;p=c/2;s=p*9/16+28;o=0;g==="threeUp"?o=r+s:g==="oneUp"?o=r:o=i*2;f=a.position().top;l=$(window).height();if(f+o>l){e=l-f;u=e/o;r*=u;c=(r-28)*16/9;h=(i-28)*16/9;i*=u;p=c/2;s=p*9/16+28;n=a.width()-c}return D={grid:{stream1:{x:0,y:0,width:h,height:i},stream2:{x:h,y:0,width:h,height:i},stream3:{x:0,y:i,width:h,height:i},chat:{x:h,y:i+t,width:h,height:i-t-8},chatnav:{x:h,y:i,width:h,height:t},overallHeight:i*2},oneUp:{stream1:{x:0,y:0,width:c,height:r},chat:{x:c,y:t,width:n,height:r-t-8},chatnav:{x:c,y:0,width:n,height:t},overallHeight:r},threeUp:{stream1:{x:0,y:0,width:c,height:r},stream2:{x:0,y:r,width:p,height:s},stream3:{x:p,y:r,width:p,height:s},chat:{x:c,y:t,width:n,height:r+s-t-8},chatnav:{x:c,y:0,width:n,height:t},overallHeight:r+s},twoUp:{stream1:{x:0,y:0,width:h,height:i},stream2:{x:0,y:i,width:h,height:i},chat:{x:h,y:t,width:h,height:i*2-t-8},chatnav:{x:h,y:0,width:h,height:t},overallHeight:i*2}}};window.setupLayout=function(e){g=e;U();_("stream1");_("stream2");_("stream3");A("chat-irc");A("chat-stream1");A("chat-stream2");A("chat-stream3");O("chatnav");return $("#streams-wrapper").height(D[g].overallHeight)};A=function(e){var t;t=D[g].chat;e=$("#"+e);if(t){e.css("left",t.x);e.css("top",t.y);e.width(t.width);return e.height(t.height)}};O=function(e){var t,n;t=D[g][e];e=$("#"+e);n=$("#liveAlerts");if(t){e.show();e.css("left",t.x);e.css("top",t.y);e.width(t.width);e.height(t.height);n.css("left",t.x);n.css("top",t.y);n.width(t.width);return n.height(t.height)}};_=function(e){var t,n,r,i,s,o,u,a,f,l,c,h;a=D[g][e];c=$("#"+e);l=$("#"+e+"Overlay");f=e.charAt(e.length-1);n=$('a[data-chat="'+e+'"]');t=$("div[data-channel='"+j[e]+"']");u=t.find(".gb-username").text();i=t.find(".game-title").text();s=t.find(".profile-pic").attr("src");o=s.replace("/square_mini/","/square_tiny/");r=t.find(".btn-donate").attr("href");h="https://twitter.com/intent/tweet?url=http://www.explosiveruns.com/?1="+j[e]+"&hashtags=GBXL,ExtraLife&text=Check out "+u+"'s stream, and help raise money for sick kids.";if(!a){R(c);return l.hide()}if(c.is("div")){d(j[e],e);c=$("#"+e)}c.css("left",a.x);c.css("top",a.y);c.width(a.width);c.height(a.height);if(!T){l.css("left",a.x);l.css("top",a.y);l.width(a.width);l.height(a.height-30);l.find(".overlay-info h3.name-info").text(u);l.find(".overlay-info h3.playing-info").html("<em>playing</em> "+i);l.find(".overlay-info img").attr("src",o);l.find(".overlay-buttons .btn-donate").attr("href",r);l.find(".overlay-buttons .tweet-link").attr("href",h);l.show();n.attr("data-original-title","View "+u+"'s Twitch Chat");return n.tooltip("fixTitle")}};M=function(e,t){if(t){e.css("left",t.x);e.css("top",t.y);e.width(t.width);e.height(t.height);return e.show()}return e.hide()};b=function(e,t){var n;if(T){n="http://www.twitch.tv/"+e+"/hls";return $("#"+t).replaceWith('<iframe id="'+t+'" src="'+n+'" scrolling="no" frameborder="0"></iframe>')}w.channel=e;t==="stream1"?w.initCallback=W:t==="stream2"?w.initCallback=X:w.initCallback=V;return swfobject.embedSWF(u,t,"100","100","9.0.0","expressInstall.swf",w,B,v)};d=function(e,t){b(e,t);return document.getElementById("chat-"+t).src=E(e)};R=function(e){var t,n;n=e.attr("id");t="<div id='"+n+"'></div>";return e.replaceWith(t)};W=function(){var e;e=function(){var e;e=$("#stream1")[0];e.playVideo();return e.unmute()};return setTimeout(e,3e3)};X=function(){var e;e=function(){var e;e=$("#stream2")[0];e.playVideo();return e.mute()};return setTimeout(e,3e3)};V=function(){var e;e=function(){var e;e=$("#stream3")[0];e.playVideo();return e.mute()};return setTimeout(e,3e3)};J=function(){return $.ajax({type:"GET",url:"http://www.extra-life.org/index.cfm?fuseaction=widgets.300x250thermo&teamID=10592",success:function(e){var t;t=$(e.responseText).find("#mercury em").text();return $("#total-value").text(t)},complete:function(){return setTimeout(J,l)}})};window.swapStream=function(e,t){var n,r,i,s,o,u;if(j[e]!==t){for(n in j){u=j[n];if(t!==u)continue;r=$("#"+n);s=$("#"+e);r.attr("id",e);s.attr("id",n);i=$("#chat-"+n);o=$("#chat-"+e);i.attr("id","chat-"+e);o.attr("id","chat-"+n);j[n]=j[e];j[e]=u;y();return null}j[e]=t;R($("#"+e));return setupLayout(g)}};window.loadChat=function(e){if(e!==m){$("#chat-"+m).hide();$("#chat-"+e).show();m=e;$("#chatnav ul li a.active").removeClass("active");$("#chatnav ul li a[data-chat='"+e+"']").addClass("active");$("#chat-"+e).width("300px");$("#chat-"+e).height("335px");return y()}};S=function(){var e,t,n,r,i,s,o;i=null;s=$(".index-entry").map(function(){return $(this).attr("data-channel")}).get();for(t in j){o=j[t];e=s.indexOf(o);e>-1&&s.splice(e,1)}while(i==null){n=$(".index-entry.on-air").map(function(){return $(this).attr("data-channel")}).get();for(t in j){o=j[t];e=n.indexOf(o);e>-1&&n.splice(e,1)}if(n.length>0){r=Math.floor(Math.random()*(n.length-1));i=n[r]}else{r=Math.floor(Math.random()*(s.length-1));i=s[r]}}return i};E=function(e){var t;t="";e==="irc"?t=o:t="http://www.twitch.tv/chat/embed?channel="+e+"&popout_chat=true";return t};x=function(e){return decodeURIComponent(((new RegExp("[?|&]"+e+"=([^&;]+?)(&|##|;|$)")).exec(location.search)||[null,""])[1].replace(/\+/g,"%20"))||null};$(window).load(function(){k();C();L();return $("#streamsLoading").fadeOut("fast",function(){$("#streamsLoading").remove();$("#footer").css("position","relative");$("body").css("height","auto");$("html").css("height","auto");$("#info-content").show();$("#info-navbar").show();return $("#streams-wrapper").fadeIn("fast",function(){setTimeout(N,3e3);setTimeout(F,6e3);setTimeout(J,15e3);y();return $(window).on("resize orientationchange",function(){return y()})})})})}).call(this);