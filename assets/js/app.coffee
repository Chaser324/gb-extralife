
#############
# CONSTANTS #
#############

PLAYER_URL = '//www-cdn.jtvnw.net/swflibs/TwitchPlayer.swf'
STREAM_API_URL = 'https://api.twitch.tv/kraken/streams/'
IRC_URL = 'http://webchat.quakenet.org/?channels=GBXL&uio=MT1mYWxzZSYyPXRydWUmND10cnVlJjg9ZmFsc2UmOT10cnVlJjEwPXRydWUmMTE9MzY5JjE0PWZhbHNlac'

CHAT_WIDTH = 300
CHAT_TAB_HEIGHT = 42

WIDTH_LARGE = 0
HEIGHT_LARGE = 0

WIDTH_MED = 0
HEIGHT_MED = 0

WIDTH_SMALL = 0
HEIGHT_SMALL = 0

BANNER_HEIGHT = 252

TOTAL_UPDATE_RATE = 300000
STREAM_UPDATE_RATE = 90000

flashvars = 
    enable_javascript: "true"
    fullscreen_click: "true"
    video_width: "427"
    video_height: "240"
    embed: 1
    initCallback: ""
    channel: ""

params =
    allowFullScreen: "true"
    allowscriptaccess: "always"
    wmode: "opaque"

attributes = 
    "class": "layoutElement"

#############
# VARIABLES #
#############

currentLayout = ''
currentChat = 'irc'

onAirStreamCount = 0
newAlerts = []

layouts = null

iOS = /(iPad|iPhone|iPod)/g.test( navigator.userAgent );

specifiedParams =
    stream1: false
    stream2: false
    stream3: false

playerChannels = 
    stream1: ''
    stream2: ''
    stream3: ''

#############
# FUNCTIONS #
#############

initPage = ->
    if window.playerChannels?
        for key, value of playerChannels
            if window.playerChannels.hasOwnProperty(key) and window.playerChannels?
                window.playerChannels[key].trim()
                if window.playerChannels[key] isnt ''
                    playerChannels[key] = window.playerChannels[key].toLowerCase()
                    specifiedParams[key] = true

    param1 = getURLParameter '1'
    param2 = getURLParameter '2'
    param3 = getURLParameter '3'
    initLayout = getURLParameter 'layout'

    if param1?
        playerChannels.stream1 = param1.toLowerCase()
        specifiedParams.stream1 = true
    if param2?
        playerChannels.stream2 = param2.toLowerCase()
        specifiedParams.stream2 = true
    if param3?
        playerChannels.stream3 = param3.toLowerCase()
        specifiedParams.stream3 = true
    if not initLayout?
        initLayout = 'threeUp'


    if playerChannels['stream2'] is playerChannels['stream1']
        playerChannels['stream2'] = ''
        specifiedParams.stream2 = false
    if playerChannels['stream3'] is playerChannels['stream1']
        playerChannels['stream3'] = ''
        specifiedParams.stream3 = false
    if playerChannels['stream3'] is playerChannels['stream2']
        playerChannels['stream3'] = ''
        specifiedParams.stream3 = false

    $('#chat-irc').show()

    first_visit = $.cookie 'first_visit'
    if not first_visit
        $.cookie 'first_visit', 'true',
            expires: 3
            path: '/'
        $('.first-alert').show()
    else
        newAlerts.push '<strong>Welcome Back!</strong>' 
        newAlerts.push 'The Giant Bomb Extra Life marathon rages on! Don\'t forget to <strong><a href="http://www.extra-life.org/team/giantbomb">DONATE</a></strong>.'

    for key, value of specifiedParams when value is false
        playerChannels[key] = getRandomUsers()

    setupLayout initLayout

initComplete = ->
    specifiedCount = 0
    for key, value of specifiedParams when value is true
        ++specifiedCount

    for key, value of specifiedParams when value is false
        channel = playerChannels[key]
        channelEntry = $("div[data-channel='" + channel + "']")
        isLive = if channelEntry.find('p.live').hasClass 'on-air' then true else false
        streamNumber = parseInt key.charAt(key.length-1)
        if not isLive and (onAirStreamCount + specifiedCount) >= streamNumber
            randomUser = getRandomUsers()
            swapStream key, randomUser

initEvents = ->
    $('.alert').bind 'closed.bs.alert', ->
        setTimeout doResize, 100

    $("a[href='#info-content']").click ->
        $('#content-nav li a.active').removeClass 'active'
        $("#content-nav li a[href='#info-content']").addClass 'active'
        $('#stream-index').hide 0
        $('#info-content').show 0, ->
            $('html, body').animate
                scrollTop: $(window).height()
                , 400
    $("a[href='#stream-index']").click ->
        $('#content-nav li a.active').removeClass 'active'
        $("#content-nav li a[href='#stream-index']").addClass 'active'
        $('#info-content').hide 0
        $('#stream-index').show 0, ->
            $('html, body').animate
                scrollTop: $(window).height()
                , 400
    $('li.top-link a').click ->
        $('html, body').animate
            scrollTop: 0
            , 400


    $('a.tweet-link').click (e) ->
        e.preventDefault()
        loc = $(this).attr 'href'
        window.open loc, 'twitterwindow', 'height=450, width=550, top=' + ($(window).height()/2 - 225) + ', left=' + $(window).width()/2 + ', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0'

    $('a.fullscreen-link').click ->
        if screenfull.enabled
            screenfull.toggle()

    $('a.alertDismiss').click ->
        newAlerts = []
        $('#liveAlerts').fadeOut 'fast'

    if !iOS
        $('#main-nav').find('.fullscreen-link').tooltip
            title: 'Toggle Fullscreen'
            placement: 'bottom'
        $('#main-nav').find('.liveStreamCount').tooltip
            title: 'Click to View Full List'
            placement: 'bottom'
        $('#main-nav').find('.info-link').tooltip
            title: 'Click to Find Out More'
            placement: 'bottom'
        $("a[data-chat='irc']").tooltip
            title: 'View IRC Chat'
            placement: 'bottom'

    $('.footer-logo').popover()

    $('#info-navbar').affix
        offset:
            top: -> 
                $(window).height() + 20


    $('.overlay-move').draggable
        revert: "valid"
        revertDuration: 0
        stack: '.streamOverlay'
        iframeFix: true
        cursorAt:
            top: 10
            right: 10
        zIndex: 2000
        start: (event, ui) ->
            $(this).parent().css 'z-index', 2000
        stop: (event, ui) ->
            $(this).parent().css 'z-index', ''
            $(this).css
                'top': ''
                'left': ''
    $('.streamOverlay').droppable
        accept: '.overlay-move'
        activeClass: 'drop-active'
        hoverClass: 'drop-hover'
        drop: (event, ui) ->
            draggedID = ui.draggable.parent().attr 'id'
            draggedStream = draggedID.replace 'Overlay', ''
            
            droppedID = $(this).attr 'id'
            droppedStream = droppedID.replace 'Overlay', ''

            if droppedStream isnt draggedStream
                swapStream droppedStream, playerChannels[draggedStream]


initIndex = ->
    Handlebars.registerHelper 'toLowerCase', (value) ->
        return value.toLowerCase()

    source = $('#index-template').html()
    template = Handlebars.compile source
    context = 
        users: window.users
    html = template context

    window.users = null
    
    $('#stream-container').append html

    $('.index-entry:nth-child(4n+5)').css "clear", "both"

    $('.index-entry').each ->
        refreshStream $(this).attr 'data-channel'

refreshAlerts = ->
    if newAlerts.length is 0
        $('#liveAlerts').fadeOut 'fast', ->
            setTimeout refreshAlerts, STREAM_UPDATE_RATE
    else
        liveAlerts = $('#liveAlerts')
        alertTextBox = liveAlerts.find('p').eq(0)
        alertStr = newAlerts.shift()

        $('#liveAlerts').fadeIn 'fast', ->
            alertTextBox.hide ->
                alertTextBox.html(alertStr)

                textWidth = alertTextBox.width()
                containerWidth = liveAlerts.width() - 90

                if textWidth <= containerWidth
                    alertTextBox.fadeIn('fast').delay(3000).fadeOut 'fast', ->
                        refreshAlerts()
                else
                    alertTextBox.fadeIn('fast').delay(1500).animate
                        left: (containerWidth - textWidth - 10) + 'px'
                        (textWidth - containerWidth) * 10, 'linear', ->
                            alertTextBox.delay(1500).fadeOut 'fast', ->
                                alertTextBox.css 'left', '0'
                                refreshAlerts()

refreshStream = (channel) ->
    $.ajax
        type: 'GET'
        dataType: 'jsonp'
        crossDomain: true
        headers:
            Accept: 'application/vnd.twitchtv.v2+json'
        url: STREAM_API_URL + channel
        success: (data) ->
            stream = data["stream"]
            channelEntry = $("div[data-channel='" + channel + "']")
            gbUserName = channelEntry.find('.gb-username').text()
            isLive = if channelEntry.find('p.live').hasClass 'on-air' then true else false
            if not stream? and isLive is true
                # Channel just went off-line
                channelEntry.removeClass 'on-air'
                channelEntry.find('p.live').removeClass 'on-air'
                channelEntry.find('.stream-pic').removeClass 'on-air'
                channelEntry.find('h2').text 'Off-Air'
                channelEntry.find('.game-title').text 'nothing at the moment'
                $('#stream-container').append channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"
                --onAirStreamCount
                refreshOnAirCount()
            else if stream? and isLive is false
                # Channel just came on-line
                newGame = stream["channel"]["game"]
                if not newGame?
                    newGame = "something"
                channelEntry.addClass 'on-air'
                channelEntry.find('p.live').addClass 'on-air'
                channelEntry.find('.stream-pic').addClass 'on-air'
                channelEntry.find('h2').text stream["channel"]["status"]
                channelEntry.find('.stream-pic').attr 'src', stream["preview"]["medium"]
                channelEntry.find('.game-title').text newGame
                $('#stream-container').prepend channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"
                ++onAirStreamCount
                refreshOnAirCount()
                alertStr = '<strong>' + gbUserName + '</strong> is now LIVE playing ' + newGame + '.'
                newAlerts.push alertStr
            else if stream?
                # Still On-Air. Check for new game, title, thumbnail.
                currentGame = channelEntry.find('.game-title').text()
                newGame = stream["channel"]["game"]
                if not newGame?
                    newGame = "something"
                channelEntry.find('h2').text stream["channel"]["status"]
                channelEntry.find('.stream-pic').attr 'src', stream["preview"]["medium"]
                channelEntry.find('.game-title').text newGame
                if currentGame != newGame
                    alertStr = '<strong>' + gbUserName + '</strong> switched to playing ' + newGame + '.'
                    newAlerts.push alertStr
        complete:
            setTimeout (-> refreshStream channel), STREAM_UPDATE_RATE

refreshOnAirCount = ->
    if onAirStreamCount > 0
        $('.liveStreamCount').html onAirStreamCount + ' Streams Are <span class="on-air-count">LIVE!</span> <i class="fa fa-chevron-circle-down"></i>'
    else
        $('.liveStreamCount').html 'Live Streams <i class="fa fa-chevron-circle-down"></i>'

doResize = ->
    setupLayout currentLayout

setCoords = ->
    streamWrapper = $('#streams-wrapper')

    CHAT_WIDTH = 300

    WIDTH_LARGE = streamWrapper.width() - CHAT_WIDTH
    HEIGHT_LARGE = (WIDTH_LARGE * 9/16) + 28

    WIDTH_MED = streamWrapper.width() / 2
    HEIGHT_MED = (WIDTH_MED * 9/16) + 28

    WIDTH_SMALL = WIDTH_LARGE / 2
    HEIGHT_SMALL = (WIDTH_SMALL * 9/16) + 28

    height = 0

    if currentLayout == "threeUp"
        height = HEIGHT_LARGE + HEIGHT_SMALL
    else if currentLayout == "oneUp"
        height = HEIGHT_LARGE
    else
        height = HEIGHT_MED * 2

    top = streamWrapper.position().top
    winHeight = $(window).height()

    if (top + height) > winHeight
        desiredHeight = winHeight - top
        scale = desiredHeight / height

        HEIGHT_LARGE *= scale;
        WIDTH_LARGE = (HEIGHT_LARGE - 28) * 16/9

        WIDTH_MED = (HEIGHT_MED - 28) * 16/9
        HEIGHT_MED *= scale

        WIDTH_SMALL = (WIDTH_LARGE / 2)
        HEIGHT_SMALL = (WIDTH_SMALL * 9/16) + 28

        CHAT_WIDTH = streamWrapper.width() - WIDTH_LARGE

    layouts =
        grid:
            stream1:
                x: 0
                y: 0
                width: WIDTH_MED
                height: HEIGHT_MED
            stream2:
                x: WIDTH_MED
                y: 0
                width: WIDTH_MED
                height: HEIGHT_MED
            stream3:
                x: 0
                y: HEIGHT_MED
                width: WIDTH_MED
                height: HEIGHT_MED
            chat:
                x: WIDTH_MED
                y: HEIGHT_MED + CHAT_TAB_HEIGHT
                width: WIDTH_MED
                height: HEIGHT_MED - CHAT_TAB_HEIGHT - 8
            chatnav:
                x: WIDTH_MED
                y: HEIGHT_MED
                width: WIDTH_MED
                height: CHAT_TAB_HEIGHT
            overallHeight: HEIGHT_MED * 2
        oneUp:
            stream1:
                x: 0
                y: 0
                width: WIDTH_LARGE
                height: HEIGHT_LARGE
            chat:
                x: WIDTH_LARGE
                y: CHAT_TAB_HEIGHT
                width: CHAT_WIDTH
                height: HEIGHT_LARGE - CHAT_TAB_HEIGHT - 8
            chatnav:
                x: WIDTH_LARGE
                y: 0
                width: CHAT_WIDTH
                height: CHAT_TAB_HEIGHT
            overallHeight: HEIGHT_LARGE
        threeUp:
            stream1:
                x: 0
                y: 0
                width: WIDTH_LARGE
                height: HEIGHT_LARGE
            stream2:
                x: 0
                y: HEIGHT_LARGE
                width: WIDTH_SMALL
                height: HEIGHT_SMALL
            stream3:
                x: WIDTH_SMALL
                y: HEIGHT_LARGE
                width: WIDTH_SMALL
                height: HEIGHT_SMALL
            chat:
                x: WIDTH_LARGE
                y: CHAT_TAB_HEIGHT
                width: CHAT_WIDTH
                height: HEIGHT_LARGE + HEIGHT_SMALL - CHAT_TAB_HEIGHT - 8
            chatnav:
                x: WIDTH_LARGE
                y: 0
                width: CHAT_WIDTH
                height: CHAT_TAB_HEIGHT
            overallHeight: HEIGHT_LARGE + HEIGHT_SMALL
        twoUp:
            stream1:
                x: 0
                y: 0
                width: WIDTH_MED
                height: HEIGHT_MED
            stream2:
                x: 0
                y: HEIGHT_MED
                width: WIDTH_MED
                height: HEIGHT_MED
            chat:
                x: WIDTH_MED
                y: CHAT_TAB_HEIGHT
                width: WIDTH_MED
                height: HEIGHT_MED * 2 - CHAT_TAB_HEIGHT - 8
            chatnav:
                x: WIDTH_MED
                y: 0
                width: WIDTH_MED
                height: CHAT_TAB_HEIGHT
            overallHeight: HEIGHT_MED * 2

window.setupLayout = (layoutType) ->
    currentLayout = layoutType
    setCoords()

    layoutPlayerSlot 'stream1'
    layoutPlayerSlot 'stream2'
    layoutPlayerSlot 'stream3'

    layoutChat 'chat-irc'
    layoutChat 'chat-stream1'
    layoutChat 'chat-stream2'
    layoutChat 'chat-stream3'

    layoutChatNav 'chatnav'

    $('#streams-wrapper').height layouts[currentLayout].overallHeight


layoutChat = (chat) ->
    layout = layouts[currentLayout]['chat']
    chat = $('#' + chat)

    if layout
        chat.css 'left', layout.x
        chat.css 'top', layout.y
        chat.width layout.width
        chat.height layout.height

layoutChatNav = (chatnav) ->
    layout = layouts[currentLayout][chatnav]
    chatnav = $('#' + chatnav)
    liveAlerts = $('#liveAlerts')

    if layout
        chatnav.show()
        chatnav.css 'left', layout.x
        chatnav.css 'top', layout.y
        chatnav.width layout.width
        chatnav.height layout.height

        liveAlerts.css 'left', layout.x
        liveAlerts.css 'top', layout.y
        liveAlerts.width layout.width
        liveAlerts.height layout.height

layoutPlayerSlot = (slot) ->
    layout = layouts[currentLayout][slot]
    player = $('#' + slot)
    overlay = $('#' + slot + 'Overlay')
    number = slot.charAt (slot.length - 1)
    chatLink = $('a[data-chat="' + slot + '"]')
    channelEntry = $("div[data-channel='" + playerChannels[slot] + "']")
    gbUserName = channelEntry.find('.gb-username').text()
    gameName = channelEntry.find('.game-title').text()
    gbUserIcon = channelEntry.find('.profile-pic').attr 'src'
    gbUserIconTiny = gbUserIcon.replace('/square_mini/','/square_tiny/')
    donateLink = channelEntry.find('.btn-donate').attr 'href'
    tweetLink = 'https://twitter.com/intent/tweet?url=http://www.explosiveruns.com/?1=' + playerChannels[slot] + 
        '&hashtags=GBXL,ExtraLife&text=Check out ' + gbUserName + '\'s stream, and help raise money for sick kids.'

    if layout
        if player.is('div')
            addPlayer(playerChannels[slot], slot)
            player = $('#' + slot)
        player.css 'left', layout.x
        player.css 'top', layout.y
        player.width layout.width
        player.height layout.height

        if !iOS
            overlay.css 'left', layout.x
            overlay.css 'top', layout.y
            overlay.width layout.width
            overlay.height layout.height - 30
            overlay.find('.overlay-info h3.name-info').text gbUserName
            overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + gameName
            overlay.find('.overlay-info img').attr 'src', gbUserIconTiny
            overlay.find('.overlay-buttons .btn-donate').attr 'href', donateLink
            overlay.find('.overlay-buttons .tweet-link').attr 'href', tweetLink
            overlay.show()

            chatLink.attr 'data-original-title', 'View ' + gbUserName + '\'s Twitch Chat'
            chatLink.tooltip 'fixTitle'
    else
        removePlayer player
        overlay.hide()

layoutElement = (element, layout) ->
    if layout
        element.css 'left', layout.x
        element.css 'top', layout.y
        element.width layout.width
        element.height layout.height

        element.show()
    else
        element.hide()

embedPlayer = (channel, replaceElem) ->
    if iOS
        url = 'http://www.twitch.tv/' + channel + '/hls'
        $('#' + replaceElem).replaceWith '<iframe id="' + replaceElem + '" src="' + url + '" scrolling="no" frameborder="0"></iframe>'
    else
        flashvars.channel = channel

        if replaceElem is 'stream1'
            flashvars.initCallback = stream1Loaded
        else if replaceElem is 'stream2'
            flashvars.initCallback = stream2Loaded
        else
            flashvars.initCallback = stream3Loaded

        swfobject.embedSWF(PLAYER_URL,replaceElem,"100","100","9.0.0",
            "expressInstall.swf",flashvars,params,attributes)

addPlayer = (channelName, slotName) ->
    embedPlayer channelName, slotName
    document.getElementById('chat-' + slotName).src = getChatUrl(channelName)

removePlayer = (playerElement) ->
    name = playerElement.attr 'id'
    div = "<div id='" + name + "'></div>"
    playerElement.replaceWith(div)

stream1Loaded = ->
    callback = ->
        player = $('#stream1')[0]
        player.playVideo()
        player.unmute()
    setTimeout callback, 3000

stream2Loaded = ->
    callback = ->
        player = $('#stream2')[0]
        player.playVideo()
        player.mute()
    setTimeout callback, 3000

stream3Loaded = ->
    callback = ->
        player = $('#stream3')[0]
        player.playVideo()
        player.mute()
    setTimeout callback, 3000

updateTotal = ->    
    $.ajax
        type: 'GET'
        url: 'http://www.extra-life.org/index.cfm?fuseaction=widgets.300x250thermo&teamID=10592'
        success: (data) ->
            value = $(data.responseText).find('#mercury em').text()
            $('#total-value').text(value)
        complete: ->
            setTimeout updateTotal, TOTAL_UPDATE_RATE

window.swapStream = (slot, channel) ->
    if playerChannels[slot] != channel
        for key, value of playerChannels when channel == value
            p1 = $('#' + key)
            p2 = $('#' + slot)
            p1.attr 'id', slot
            p2.attr 'id', key

            p1chat = $('#chat-' + key)
            p2chat = $('#chat-' + slot)
            p1chat.attr 'id', 'chat-' + slot
            p2chat.attr 'id', 'chat-' + key

            playerChannels[key] = playerChannels[slot]
            playerChannels[slot] = value
            doResize()
            return null
        playerChannels[slot] = channel
        removePlayer $('#'+slot)
        setupLayout currentLayout

window.loadChat = (channel) ->
    if channel isnt currentChat
        $('#chat-' + currentChat).hide()
        $('#chat-' + channel).show()
        currentChat = channel

        $('#chatnav ul li a.active').removeClass 'active'
        $("#chatnav ul li a[data-chat='" + channel + "']").addClass 'active'
        
        $('#chat-' + channel).width '300px'
        $('#chat-' + channel).height '335px'
        doResize()

getRandomUsers = ->
    randomUser = null
    usernames = $('.index-entry').map(-> $(this).attr 'data-channel').get()
    for key, value of playerChannels
        index = usernames.indexOf value 
        if index > -1
            usernames.splice index, 1
    while not randomUser?
        liveUsers = $('.index-entry.on-air').map(-> $(this).attr 'data-channel').get()
        for key, value of playerChannels
            index = liveUsers.indexOf value 
            if index > -1
                liveUsers.splice index, 1
        if liveUsers.length > 0
            randomNum = Math.floor ( Math.random() * (liveUsers.length - 1) )
            randomUser = liveUsers[randomNum]
        else
            randomNum = Math.floor ( Math.random() * (usernames.length - 1) )
            randomUser = usernames[randomNum]
    return randomUser

getChatUrl = (channel) ->
    url = ''
    if channel == 'irc'
        url = IRC_URL;
    else
        url = 'http://www.twitch.tv/chat/embed?channel=' + channel + '&popout_chat=true'
    return url

getURLParameter = (name) -> 
    decodeURIComponent((new RegExp("[?|&]#{name}=([^&;]+?)(&|##|;|$)").exec(location.search) || [null,""] )[1].replace(/\+/g, '%20'))||null;

###############
# MAIN SCRIPT #
###############

$(window).load ->
    initIndex()
    initEvents()
    initPage()
    $('#streamsLoading').fadeOut 'fast', ->
        $('#streamsLoading').remove()
        $('#footer').css 'position', 'relative'
        $('body').css 'height', 'auto'
        $('html').css 'height', 'auto'
        $('#info-content').show();
        $('#info-navbar').show();
        $('#streams-wrapper').fadeIn 'fast', ->
            setTimeout initComplete, 3000
            setTimeout refreshAlerts, 6000
            setTimeout updateTotal, 15000
            
            doResize()

            $(window).on "resize orientationchange", ->
                doResize()



