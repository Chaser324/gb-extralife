// Generated by CoffeeScript 1.6.3
(function(){var e,t,n,r,i,s,o,u,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S,x,T,N,C,k,L,A,O,M,_,D,P,H,B,j,F,I,q,R,U,z,W,X,V;u="//www-cdn.jtvnw.net/swflibs/TwitchPlayer.swf";a="https://api.twitch.tv/kraken/streams/";o="http://webchat.quakenet.org/?channels=gbendurancerun&uio=MT1mYWxzZSY4PWZhbHNlJjExPTM2OSYxMz1mYWxzZSYxND1mYWxzZQfc";n=300;t=42;c=0;r=0;h=0;i=0;p=0;s=0;e=252;l=3e5;f=9e4;w={enable_javascript:"true",fullscreen_click:"true",video_width:"427",video_height:"240",embed:1,initCallback:"",channel:""};H={allowFullScreen:"true",allowscriptaccess:"always",wmode:"opaque"};v={"class":"layoutElement"};g="";m="irc";P=0;D=[];_=null;T=/(iPad|iPhone|iPod)/g.test(navigator.userAgent);U={stream1:!1,stream2:!1,stream3:!1};B={stream1:"",stream2:"",stream3:""};k=function(){var e,t,n,r,i,s,o;if(window.playerChannels!=null)for(n in B){o=B[n];if(window.playerChannels.hasOwnProperty(n)){B[n]=window.playerChannels[n].toLowerCase();U[n]=!0}}r=x("1");i=x("2");s=x("3");t=x("layout");if(r!=null){B.stream1=r.toLowerCase();U.stream1=!0}if(i!=null){B.stream2=i.toLowerCase();U.stream2=!0}if(s!=null){B.stream3=s.toLowerCase();U.stream3=!0}t==null&&(t="threeUp");for(n in U){o=U[n];o===!1&&(U[n]=randomUser())}$("#chat-irc").show();e=$.cookie("first_visit");if(!e){$.cookie("first_visit","true",{expires:3,path:"/"});$(".first-alert").show()}else{D.push("<strong>Welcome Back!</strong>");D.push('The Giant Bomb Extra Life marathon rages on! Don\'t forget to <strong><a href="http://www.extra-life.org/team/giantbomb">DONATE</a></strong>.')}setupLayout(t);return setTimeout(j,1e4)};N=function(){$(".alert").bind("closed.bs.alert",function(){return setTimeout(y,100)});setTimeout(V,15e3);$("a[href='#info-content']").click(function(){$("#content-nav li a.active").removeClass("active");$("#content-nav li a[href='#info-content']").addClass("active");$("#stream-index").hide(0);return $("#info-content").show(0,function(){return $("html, body").animate({scrollTop:$("#content-nav").offset().top},600)})});$("a[href='#stream-index']").click(function(){$("#content-nav li a.active").removeClass("active");$("#content-nav li a[href='#stream-index']").addClass("active");$("#info-content").hide(0);return $("#stream-index").show(0,function(){return $("html, body").animate({scrollTop:$("#content-nav").offset().top},600)})});$("a.tweet-link").click(function(e){var t;e.preventDefault();t=$(this).attr("href");return window.open(t,"twitterwindow","height=450, width=550, top="+($(window).height()/2-225)+", left="+$(window).width()/2+", toolbar=0, location=0, menubar=0, directories=0, scrollbars=0")});$("a.fullscreen-link").click(function(){if(screenfull.enabled)return screenfull.toggle()});$("a.alertDismiss").click(function(){D=[];return $("#liveAlerts").fadeOut("fast")});if(!T){$("#main-nav").find(".fullscreen-link").tooltip({title:"Toggle Fullscreen",placement:"bottom"});$("#main-nav").find(".liveStreamCount").tooltip({title:"Click to View Full List",placement:"bottom"});$("#main-nav").find(".info-link").tooltip({title:"Click to Find Out More",placement:"bottom"});$("a[data-chat='irc']").tooltip({title:"View IRC Chat",placement:"bottom"})}return $(".footer-logo").popover()};C=function(){var e,t,n,r;Handlebars.registerHelper("toLowerCase",function(e){return e.toLowerCase()});n=$("#index-template").html();r=Handlebars.compile(n);e={users:window.users};t=r(e);window.users=null;$("#stream-container").append(t);$(".index-entry:nth-child(4n+5)").css("clear","both");return $(".index-entry").each(function(){return I($(this).attr("data-channel"))})};j=function(){var e,t,n;if(D.length===0)return $("#liveAlerts").fadeOut("fast",function(){return setTimeout(j,f)});n=$("#liveAlerts");t=n.find("p").eq(0);e=D.shift();return $("#liveAlerts").fadeIn("fast",function(){return t.hide(function(){var r,i;t.html(e);i=t.width();r=n.width()-90;return i<=r?t.fadeIn("fast").delay(3e3).fadeOut("fast",function(){return j()}):t.fadeIn("fast").delay(1500).animate({left:r-i-10+"px"},(i-r)*10,"linear",function(){return t.delay(1500).fadeOut("fast",function(){t.css("left","0");return j()})})})})};I=function(e){return $.ajax({type:"GET",dataType:"jsonp",crossDomain:!0,jsonp:"callback",url:a+e,success:function(t){var n,r,i,s,o,u,a;a=t.stream;r=$("div[data-channel='"+e+"']");s=r.find(".gb-username").text();o=r.find("p.live").hasClass("on-air")?!0:!1;if(a==null&&o===!0){r.removeClass("on-air");r.find("p.live").removeClass("on-air");r.find(".stream-pic").removeClass("on-air");r.find("h2").text("Off-Air");r.find(".game-title").text("nothing at the moment");$("#stream-container").append(r);$(".index-entry").css("clear","none");$(".index-entry:nth-child(4n+5)").css("clear","both");--P;return F()}if(a!=null&&o===!1){u=a.channel.game;u==null&&(u="something");r.addClass("on-air");r.find("p.live").addClass("on-air");r.find(".stream-pic").addClass("on-air");r.find("h2").text(a.channel.status);r.find(".stream-pic").attr("src",a.preview.medium);r.find(".game-title").text(u);$("#stream-container").prepend(r);$(".index-entry").css("clear","none");$(".index-entry:nth-child(4n+5)").css("clear","both");++P;F();n="<strong>"+s+"</strong> is now LIVE playing "+u+".";return D.push(n)}if(a!=null){i=r.find(".game-title").text();u=a.channel.game;u==null&&(u="something");r.find("h2").text(a.channel.status);r.find(".stream-pic").attr("src",a.preview.medium);r.find(".game-title").text(u);if(i!==u){n="<strong>"+s+"</strong> switched to playing "+u+".";return D.push(n)}}},complete:setTimeout(function(){return I(e)},f)})};F=function(){return P>0?$(".liveStreamCount").html(P+' Streams Are <span class="on-air-count">LIVE!</span> <i class="fa fa-chevron-circle-down"></i>'):$(".liveStreamCount").html("Live Streams")};y=function(){return setupLayout(g)};R=function(){var e,o,u,a,f,l;a=$("#streams-wrapper");n=300;c=a.width()-n;r=c*9/16+28;h=a.width()/2;i=h*9/16+28;p=c/2;s=p*9/16+28;o=0;g==="threeUp"?o=r+s:g==="oneUp"?o=r:o=i*2;f=a.position().top;l=$(window).height();if(f+o>l){e=l-f;u=e/o;r*=u;c=(r-28)*16/9;h=(i-28)*16/9;i*=u;p=c/2;s=p*9/16+28;n=a.width()-c}return _={grid:{stream1:{x:0,y:0,width:h,height:i},stream2:{x:h,y:0,width:h,height:i},stream3:{x:0,y:i,width:h,height:i},chat:{x:h,y:i+t,width:h,height:i-t-8},chatnav:{x:h,y:i,width:h,height:t},overallHeight:i*2},oneUp:{stream1:{x:0,y:0,width:c,height:r},chat:{x:c,y:t,width:n,height:r-t-8},chatnav:{x:c,y:0,width:n,height:t},overallHeight:r},threeUp:{stream1:{x:0,y:0,width:c,height:r},stream2:{x:0,y:r,width:p,height:s},stream3:{x:p,y:r,width:p,height:s},chat:{x:c,y:t,width:n,height:r+s-t-8},chatnav:{x:c,y:0,width:n,height:t},overallHeight:r+s},twoUp:{stream1:{x:0,y:0,width:h,height:i},stream2:{x:0,y:i,width:h,height:i},chat:{x:h,y:t,width:h,height:i*2-t-8},chatnav:{x:h,y:0,width:h,height:t},overallHeight:i*2}}};window.setupLayout=function(e){g=e;R();M("stream1");M("stream2");M("stream3");L("chat-irc");L("chat-stream1");L("chat-stream2");L("chat-stream3");A("chatnav");return $("#streams-wrapper").height(_[g].overallHeight)};L=function(e){var t;t=_[g].chat;e=$("#"+e);if(t){e.css("left",t.x);e.css("top",t.y);e.width(t.width);return e.height(t.height)}};A=function(e){var t,n;t=_[g][e];e=$("#"+e);n=$("#liveAlerts");if(t){e.show();e.css("left",t.x);e.css("top",t.y);e.width(t.width);e.height(t.height);n.css("left",t.x);n.css("top",t.y);n.width(t.width);return n.height(t.height)}};M=function(e){var t,n,r,i,s,o,u;i=_[g][e];u=$("#"+e);o=$("#"+e+"Overlay");s=e.charAt(e.length-1);n=$('a[data-chat="'+e+'"]');t=$("div[data-channel='"+B[e]+"']");r=t.find(".gb-username").text();if(!i){q(u);return o.hide()}if(u.is("div")){d(B[e],e);u=$("#"+e)}u.css("left",i.x);u.css("top",i.y);u.width(i.width);u.height(i.height);if(!T){o.css("left",i.x);o.css("top",i.y);o.width(i.width);o.height(i.height-30);o.attr("data-original-title",s+": "+r);o.tooltip("fixTitle");o.show();n.attr("data-original-title","View "+r+"'s Twitch Chat");return n.tooltip("fixTitle")}};O=function(e,t){if(t){e.css("left",t.x);e.css("top",t.y);e.width(t.width);e.height(t.height);return e.show()}return e.hide()};b=function(e,t){var n;if(T){n="http://www.twitch.tv/"+e+"/hls";return $("#"+t).replaceWith('<iframe id="'+t+'" src="'+n+'" scrolling="no" frameborder="0"></iframe>')}w.channel=e;w.initCallback=t+"Loaded";return swfobject.embedSWF(u,t,"100","100","9.0.0","expressInstall.swf",w,H,v)};d=function(e,t){b(e,t);return document.getElementById("chat-"+t).src=E(e)};q=function(e){var t,n;n=e.attr("id");t="<div id='"+n+"'></div>";return e.replaceWith(t)};z=function(){var e;e=$("#stream1")[0];e.playVideo();return e.unmute()};W=function(){var e;e=$("#stream2")[0];e.playVideo();return e.mute()};X=function(){var e;e=$("#stream3")[0];e.playVideo();return e.mute()};V=function(){return $.ajax({type:"GET",url:"http://www.extra-life.org/index.cfm?fuseaction=widgets.300x250thermo&teamID=10592",success:function(e){var t;t=$(e.responseText).find("#mercury em").text();return $("#total-value").text(t)},complete:function(){return setTimeout(V,l)}})};window.swapStream=function(e,t){var n,r,i,s,o,u;if(B[e]!==t){for(n in B){u=B[n];if(t!==u)continue;r=$("#"+n);s=$("#"+e);r.attr("id",e);s.attr("id",n);i=$("#chat-"+n);o=$("#chat-"+e);i.attr("id","chat-"+e);o.attr("id","chat-"+n);B[n]=B[e];B[e]=u;y();return null}B[e]=t;q($("#"+e));return setupLayout(g)}};window.loadChat=function(e){if(e!==m){$("#chat-"+m).hide();$("#chat-"+e).show();m=e;$("#chatnav ul li a.active").removeClass("active");return $("#chatnav ul li a[data-chat='"+e+"']").addClass("active")}};S=function(){return null};E=function(e){var t;t="";e==="irc"?t=o:t="http://www.twitch.tv/chat/embed?channel="+e+"&popout_chat=true";return t};x=function(e){return decodeURIComponent(((new RegExp("[?|&]"+e+"=([^&;]+?)(&|##|;|$)")).exec(location.search)||[null,""])[1].replace(/\+/g,"%20"))||null};$(window).load(function(){C();N();k();return $("#streamsLoading").fadeOut("fast",function(){$("#footer").css("position","relative");$("body").css("height","auto");$("html").css("height","auto");$("#info-content").show();$("#info-navbar").show();return $("#streams-wrapper").fadeIn("slow",function(){return y()})})});$(window).on("resize orientationchange",function(){return y()})}).call(this);