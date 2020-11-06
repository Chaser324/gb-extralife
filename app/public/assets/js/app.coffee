
#############
# CONSTANTS #
#############

TWITCH_PLAYER_URL = 'https://player.twitch.tv/?parent=www.explosiveruns.com&channel='
TWITCH_API_URL = 'https://api.twitch.tv/kraken/streams/'
TWITCH_USERS_URL = 'https://api.twitch.tv/kraken/users?login='
TWITCH_CHAT_URL = 'https://www.twitch.tv/embed/'

MIXER_PLAYER_URL = 'https://mixer.com/embed/player/'
MIXER_CHAT_URL = 'https://mixer.com/embed/chat/'
MIXER_API_URL = 'https://mixer.com/api/v1/channels/'


# <iframe width="640" height="360" src="https://hitbox.tv/#!/embed/m00sician" frameborder="0" allowfullscreen></iframe>
HITBOX_CHAT_URL = 'https://www.hitbox.tv/embedchat/'
HITBOX_PLAYER_URL = 'https://hitbox.tv/#!/embed/'
HITBOX_API_URL = 'https://api.hitbox.tv/media/live/'

# <iframe width="560" height="315" src="https://www.youtube.com/embed/HaPW6hkZLEU" frameborder="0" allowfullscreen></iframe>
# https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCmeds0MLhjfkjD_5acPnFlQ&eventType=live&type=video&key=AIzaSyDRvZ7eQ8dAjQ9GxDveWEbiuWMvjVeY_Lc
YOUTUBE_PLAYER_URL = 'https://www.youtube.com/embed/'
YOUTUBE_API_URL = 'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId={CHANNEL_ID}&eventType={EVENT_TYPE}&type=video&key=AIzaSyDRvZ7eQ8dAjQ9GxDveWEbiuWMvjVeY_Lc'

IRC_URL = 'https://webchat.quakenet.org/?channels=GBXL&uio=MT1mYWxzZSYyPXRydWUmND10cnVlJjg9ZmFsc2UmOT10cnVlJjEwPXRydWUmMTE9MzY5JjE0PWZhbHNlac'

DONATIONS_ACTIVE = true
BASE_DONATE_URL = 'https://www.extra-life.org/index.cfm?fuseaction=donorDrive.team&teamID=50394'
NAVBAR_BRAND = '<span><img src="assets/img/gb-logo.png" /> Explosive Runs - </span>GBXL'
DONATE_ALERT = '<strong>Welcome!</strong> Enjoy the gaming and please <strong><a href="' + BASE_DONATE_URL + '">DONATE</a></strong>!'
TWITTER_LINK = '<a class="tweet-link" href="https://twitter.com/intent/tweet?url=https://www.explosiveruns.com/&hashtags=GBXL&text=Join the Giant Bomb community supporting Extra Life!" target="_blank"><i class="fa fa-twitter-square"></i> #GBXL</a>'
FB_LINK = '<a class="tweet-link" href="https://www.facebook.com/sharer.php?u=https://www.explosiveruns.com/&t=Join the Giant Bomb community supporting Extra Life!" target="_blank"><i class="fa fa-facebook-square"></i> LIKE</a>'

STREAM_LINK = ', supporting Extra Life.'
STREAM_HASHTAG = 'GBXL'

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
STREAM_UPDATE_RATE = 120000

flashvars =
    hostname: "www.twitch.tv"
    enable_javascript: "true"
    fullscreen_click: "true"
    video_width: "427"
    video_height: "240"
    # embed: 1
    eventsCallback: ""
    channel: ""
    client_id: "256yrtw9swpn6irj0xyn8xzjy5lmgpo"

params =
    allowNetworking: "all"
    allowFullScreen: "true"
    allowscriptaccess: "always"
    wmode: "opaque"
    client_id: "256yrtw9swpn6irj0xyn8xzjy5lmgpo"

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
                    playerChannels[key] = window.playerChannels[key]
                    specifiedParams[key] = true

    param1 = getURLParameter '1'
    param2 = getURLParameter '2'
    param3 = getURLParameter '3'
    initLayout = getURLParameter 'layout'

    if param1?
        playerChannels.stream1 = param1
        specifiedParams.stream1 = true
    if param2?
        playerChannels.stream2 = param2
        specifiedParams.stream2 = true
    if param3?
        playerChannels.stream3 = param3
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
        if DONATIONS_ACTIVE
            newAlerts.push 'Don\'t forget to <strong><a href="' + BASE_DONATE_URL + '">DONATE</a></strong>.'

    for key, value of specifiedParams when value is false
        playerChannels[key] = getRandomUsers()

    initLinks()

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

initLinks = ->
    # if not DONATIONS_ACTIVE
    #     $('#current-total').hide()
    #     $('#nav-donate').hide()
    # $('.btn-donate').hide()
    # $('#donate-alert').hide()
    #     $('.social-header').hide()
    #     $('#twitter-link').hide()
    #     $('#fb-link').hide()
    #     $('#current-total').hide()
    # else
    #     # $('.btn-donate').hide()
    
    $('#nav-donate').attr 'href', BASE_DONATE_URL
    $('.navbar-brand').attr 'href', BASE_DONATE_URL
    $('.navbar-brand').html NAVBAR_BRAND
    $('#donate-alert span').html DONATE_ALERT
    $('#twitter-link').html TWITTER_LINK
    $('#fb-link').html FB_LINK

    # $('#current-total').hide()
    # $('.btn-donate').hide()

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
        if value?
            return value.toLowerCase()
        else
            return ''

    source = $('#index-template').html()
    template = Handlebars.compile source
    context =
        usergroups: window.usergroups
    html = template context

    window.usergroups = null

    $('#stream-container').append html

    $('.index-entry:nth-child(4n+5)').css "clear", "both"

    $('.index-entry').each ->
        channel = $(this).attr 'data-channel'
        site = $(this).attr 'data-site'
        refreshStream channel, site

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

refreshStream = (channel, type) ->
    if type == 'twitch'
        initTwitchStream channel
    else if type == 'hitbox'
        refreshHitboxStream channel
    else if type == 'youtube'
        refreshYoutubeStream channel
    else if type == 'mixer'
        refreshMixerStream channel

refreshMixerStream = (channel) ->
    $.ajax
        type: 'GET'
        dataType: 'json'
        crossDomain: true
        url: MIXER_API_URL + channel
        success: (data) ->
            streamIsLive = data["online"]
            channelEntry = $("div[data-channel='" + channel + "']")
            gbUserName = channelEntry.find('.gb-username').text()
            isLive = if channelEntry.find('p.live').hasClass 'on-air' then true else false
            if streamIsLive is false and isLive is true
                # Channel just went off-line
                channelEntry.removeClass 'on-air'
                channelEntry.find('p.live').removeClass 'on-air'
                channelEntry.find('.stream-pic').removeClass 'on-air'
                channelEntry.find('h2').text 'Off-Air'
                channelEntry.find('.game-title').text 'nothing at the moment'
                channelEntry.parent().append channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"

                --onAirStreamCount
                refreshOnAirCount()

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + 'nothing at the moment'

            else if streamIsLive is true and isLive is false
                # Channel just came on-line
                newGame = data["type"]["name"]
                if not newGame?
                    newGame = "something"
                channelEntry.addClass 'on-air'
                channelEntry.find('p.live').addClass 'on-air'
                channelEntry.find('.stream-pic').addClass 'on-air'
                channelEntry.find('h2').text data["name"]
                channelEntry.find('.stream-pic').attr 'src', data["thumbnail"]["url"]
                channelEntry.find('.game-title').text newGame
                channelEntry.parent().prepend channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"
                ++onAirStreamCount
                refreshOnAirCount()
                alertStr = '<strong>' + gbUserName + '</strong> is now LIVE playing ' + newGame + '.'
                newAlerts.push alertStr

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + newGame

            else if streamIsLive
                # Still On-Air. Check for new game, title, thumbnail.
                currentGame = channelEntry.find('.game-title').text()
                newGame = data["type"]["name"]
                if not newGame?
                    newGame = "something"
                channelEntry.find('h2').text data["name"]
                channelEntry.find('.stream-pic').attr 'src', data["thumbnail"]["url"]
                channelEntry.find('.game-title').text newGame
                if currentGame != newGame
                    alertStr = '<strong>' + gbUserName + '</strong> switched to playing ' + newGame + '.'
                    newAlerts.push alertStr

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + newGame
        complete:
            setTimeout (-> refreshMixerStream channel), STREAM_UPDATE_RATE

refreshHitboxStream = (channel) ->
    $.ajax
        type: 'GET'
        dataType: 'json'
        crossDomain: true
        url: HITBOX_API_URL + channel
        success: (data) ->
            stream = data["livestream"][0]
            streamIsLive = stream["media_is_live"] is '1'
            channelEntry = $("div[data-channel='" + channel + "']")
            gbUserName = channelEntry.find('.gb-username').text()
            isLive = if channelEntry.find('p.live').hasClass 'on-air' then true else false
            if streamIsLive is false and isLive is true
                # Channel just went off-line
                channelEntry.removeClass 'on-air'
                channelEntry.find('p.live').removeClass 'on-air'
                channelEntry.find('.stream-pic').removeClass 'on-air'
                channelEntry.find('h2').text 'Off-Air'
                channelEntry.find('.game-title').text 'nothing at the moment'
                channelEntry.parent().append channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"

                --onAirStreamCount
                refreshOnAirCount()

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + 'nothing at the moment'

            else if streamIsLive is true and isLive is false
                # Channel just came on-line
                newGame = stream["category_name"]
                if not newGame?
                    newGame = "something"
                channelEntry.addClass 'on-air'
                channelEntry.find('p.live').addClass 'on-air'
                channelEntry.find('.stream-pic').addClass 'on-air'
                channelEntry.find('h2').text stream["media_status"]
                channelEntry.find('.stream-pic').attr 'src', 'https://edge.sf.hitbox.tv' + stream["media_thumbnail"]
                channelEntry.find('.game-title').text newGame
                channelEntry.parent().prepend channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"
                ++onAirStreamCount
                refreshOnAirCount()
                alertStr = '<strong>' + gbUserName + '</strong> is now LIVE playing ' + newGame + '.'
                newAlerts.push alertStr

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + newGame

            else if streamIsLive
                # Still On-Air. Check for new game, title, thumbnail.
                currentGame = channelEntry.find('.game-title').text()
                newGame = stream["category_name"]
                if not newGame?
                    newGame = "something"
                channelEntry.find('h2').text stream["media_status"]
                channelEntry.find('.stream-pic').attr 'src', 'https://edge.sf.hitbox.tv' + stream["media_thumbnail"]
                channelEntry.find('.game-title').text newGame
                if currentGame != newGame
                    alertStr = '<strong>' + gbUserName + '</strong> switched to playing ' + newGame + '.'
                    newAlerts.push alertStr

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + newGame
        complete:
            setTimeout (-> refreshHitboxStream channel), STREAM_UPDATE_RATE

initTwitchStream = (channel) ->
    $.ajax
        type: 'GET'
        dataType: 'json'
        crossDomain: true
        headers:
            'Accept': 'application/vnd.twitchtv.v5+json'
            'Client-ID': '256yrtw9swpn6irj0xyn8xzjy5lmgpo'
        url: TWITCH_USERS_URL + channel
        success: (data) ->
            twitchUser = data["users"][0]["_id"]
            refreshTwitchStream channel, twitchUser

refreshTwitchStream = (channel, twitchUser) ->
    $.ajax
        type: 'GET'
        dataType: 'json'
        crossDomain: true
        headers:
            'Accept': 'application/vnd.twitchtv.v5+json'
            'Client-ID': '256yrtw9swpn6irj0xyn8xzjy5lmgpo'
        url: TWITCH_API_URL + twitchUser
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
                channelEntry.parent().append channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"

                --onAirStreamCount
                refreshOnAirCount()

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + 'nothing at the moment'

            else if stream? and isLive is false
                # Channel just came on-line
                newGame = stream["channel"]["game"]
                if not newGame? || newGame is ""
                    newGame = "something"
                channelEntry.addClass 'on-air'
                channelEntry.find('p.live').addClass 'on-air'
                channelEntry.find('.stream-pic').addClass 'on-air'
                channelEntry.find('h2').text stream["channel"]["status"]
                channelEntry.find('.stream-pic').attr 'src', stream["preview"]["medium"]
                channelEntry.find('.game-title').text newGame
                channelEntry.parent().prepend channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"
                ++onAirStreamCount
                refreshOnAirCount()
                alertStr = '<strong>' + gbUserName + '</strong> is now LIVE playing ' + newGame + '.'
                newAlerts.push alertStr

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + newGame

            else if stream?
                # Still On-Air. Check for new game, title, thumbnail.
                currentGame = channelEntry.find('.game-title').text()
                newGame = stream["channel"]["game"]
                if not newGame? || newGame is ""
                    newGame = "something"
                channelEntry.find('h2').text stream["channel"]["status"]
                channelEntry.find('.stream-pic').attr 'src', stream["preview"]["medium"]
                channelEntry.find('.game-title').text newGame
                if currentGame != newGame
                    alertStr = '<strong>' + gbUserName + '</strong> switched to playing ' + newGame + '.'
                    newAlerts.push alertStr

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + newGame
        complete:
            setTimeout (-> refreshTwitchStream channel, twitchUser), STREAM_UPDATE_RATE

refreshYoutubeStream = (channel) ->
    url = YOUTUBE_API_URL.replace "{CHANNEL_ID}", channel
    url = url.replace "{EVENT_TYPE}", "live"
    $.ajax
        type: 'GET'
        dataType: 'jsonp'
        crossDomain: true
        url: url
        success: (data) ->
            stream = null

            if data["items"].length > 0 and data["items"][0]["snippet"]["liveBroadcastContent"] == "live"
                stream =
                    id: data["items"][0]["id"]["videoId"]
                    title: data["items"][0]["snippet"]["title"]

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
                channelEntry.parent().append channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"

                --onAirStreamCount
                refreshOnAirCount()

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + 'nothing at the moment'

            else if stream? and isLive is false
                # Channel just came on-line
                # newGame = stream["channel"]["game"]
                # if not newGame?
                #     newGame = "something"
                newGame = "something"
                channelEntry.addClass 'on-air'
                channelEntry.find('p.live').addClass 'on-air'
                channelEntry.find('.stream-pic').addClass 'on-air'
                channelEntry.find('h2').text stream["title"]
                channelEntry.find('.stream-pic').attr 'src', 'https://img.youtube.com/vi/' + stream["id"] + '/mqdefault.jpg'
                channelEntry.find('.game-title').text newGame
                channelEntry.parent().prepend channelEntry
                $('.index-entry').css "clear", "none"
                $('.index-entry:nth-child(4n+5)').css "clear", "both"
                ++onAirStreamCount
                refreshOnAirCount()
                alertStr = '<strong>' + gbUserName + '</strong> is now LIVE playing ' + newGame + '.'
                newAlerts.push alertStr

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + newGame

            else if stream?
                # Still On-Air. Check for new game, title, thumbnail.
                currentGame = channelEntry.find('.game-title').text()
                # newGame = stream["channel"]["game"]
                # if not newGame?
                #     newGame = "something"
                newGame = "something"
                channelEntry.find('h2').text stream["title"]
                channelEntry.find('.stream-pic').attr 'src', 'https://img.youtube.com/vi/' + stream["id"] + '/mqdefault.jpg'
                channelEntry.find('.game-title').text newGame
                if currentGame != newGame
                    alertStr = '<strong>' + gbUserName + '</strong> switched to playing ' + newGame + '.'
                    newAlerts.push alertStr

                for key, value of playerChannels when channel == value
                    overlay = $('#' + key + 'Overlay')
                    overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + newGame
        complete:
            setTimeout (-> refreshYoutubeStream channel), STREAM_UPDATE_RATE

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
    gbUserName = playerChannels[slot]
    channelEntry = $("div[data-gbusername='" + gbUserName + "']")
    channelName = channelEntry.attr('data-channel')
    channelSite = channelEntry.attr('data-site')
    gameName = channelEntry.find('.game-title').text()
    gbUserIcon = channelEntry.find('.profile-pic').attr 'src'
    gbUserIconTiny = ""
    if gbUserIcon != "" and gbUserIcon != null
        gbUserIconTiny = gbUserIcon.replace('/square_mini/','/square_tiny/')
    donateLink = channelEntry.find('.btn-donate').attr 'href'
    tweetLink = 'https://twitter.com/intent/tweet?url=https://www.explosiveruns.com/?1=' + encodeURIComponent(encodeURIComponent(playerChannels[slot])) +
        '&hashtags=' + STREAM_HASHTAG + '&text=Check out ' + gbUserName + '\'s stream' + STREAM_LINK

    if layout
        if player.is('div')
            addPlayer(channelName, channelSite, slot)
            player = $('#' + slot)
        player.css 'left', layout.x
        player.css 'top', layout.y
        player.width layout.width
        player.height layout.height

        if !iOS
            overlay.css 'left', layout.x
            overlay.css 'top', layout.y
            overlay.width layout.width
            overlay.height 120
            overlay.find('.overlay-info h3.name-info').text gbUserName
            overlay.find('.overlay-info h3.playing-info').html '<em>playing</em> ' + gameName
            overlay.find('.overlay-info img').attr 'src', gbUserIconTiny
            overlay.find('.overlay-buttons .btn-donate').attr 'href', donateLink
            overlay.find('.overlay-buttons .tweet-link').attr 'href', tweetLink
            overlay.show()

            chatLink.attr 'data-original-title', 'View ' + gbUserName + '\'s Channel Chat'
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

embedTwitchPlayer = (channel, replaceElem) ->
    url = TWITCH_PLAYER_URL + channel
    $('#' + replaceElem).replaceWith '<iframe class="layoutElement" id="' + replaceElem + '" src="' + url + '" frameborder="0" scrolling="no" allowfullscreen="true"> </iframe>'

embedMixerPlayer = (channel, replaceElem) ->
    url = MIXER_PLAYER_URL + channel
    $('#' + replaceElem).replaceWith '<iframe class="layoutElement" id="' + replaceElem + '" src="' + url + '" frameborder="0" scrolling="no" allowfullscreen="true"> </iframe>'

embedHitboxPlayer = (channel, replaceElem) ->
    url = HITBOX_PLAYER_URL + channel
    $('#' + replaceElem).replaceWith '<iframe class="layoutElement" id="' + replaceElem + '" src="' + url + '?autoplay=true" scrolling="no" frameborder="0" allowfullscreen></iframe>'

embedYoutubePlayer = (channel, replaceElem, eventType) ->
    url = YOUTUBE_API_URL.replace "{CHANNEL_ID}", channel
    url = url.replace "{EVENT_TYPE}", eventType
    $.ajax
        type: 'GET'
        dataType: 'jsonp'
        crossDomain: true
        url: url
        success: (data) ->
            stream = null

            if data["items"].length > 0
                stream =
                    id: data["items"][0]["id"]["videoId"]
                    title: data["items"][0]["snippet"]["title"]

            if stream?
                $('#' + replaceElem).replaceWith '<iframe class="layoutElement" id="' + replaceElem + '" src="' + YOUTUBE_PLAYER_URL + stream["id"] + '?autoplay=true" scrolling="no" frameborder="0" allowfullscreen></iframe>'
                doResize()
            else if eventType == "live"
                embedYoutubePlayer channel, replaceElem, "upcoming"

addPlayer = (channelName, channelSite, slotName) ->
    if channelSite == "twitch"
        embedTwitchPlayer channelName, slotName
    else if channelSite == "hitbox"
        embedHitboxPlayer channelName, slotName
    else if channelSite == "youtube"
        embedYoutubePlayer channelName, slotName, "live"
    else if channelSite == "mixer"
        embedMixerPlayer channelName, slotName
    document.getElementById('chat-' + slotName).src = getChatUrl(channelName, channelSite)


removePlayer = (playerElement) ->
    name = playerElement.attr 'id'
    div = "<div id='" + name + "'></div>"
    playerElement.replaceWith(div)

stream1Loaded = ->
    for event of data
        if data.event is "playerInit"
            callback = ->
                player = $('#stream1')[0]
                player.playVideo()
                player.mute()
            setTimeout callback, 3000

stream2Loaded = (data) ->
    for event of data
        if data.event is "playerInit"
            callback = ->
                player = $('#stream2')[0]
                player.playVideo()
                player.mute()
            setTimeout callback, 3000

stream3Loaded = ->
    for event of data
        if data.event is "playerInit"
            callback = ->
                player = $('#stream3')[0]
                player.playVideo()
                player.mute()
            setTimeout callback, 3000

updateTotal = ->
    $.ajax
        type: 'GET'
        dataType: 'json'
        url: 'https://www.extra-life.org/api/teams/50394'
        success: (data) ->
            value = data['sumDonations']
            value = '$' + value.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,')
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

            if currentChat is key
                currentChat = slot
            else if currentChat is slot
                currentChat = key

            $('#chatnav ul li a.active').removeClass 'active'
            $("#chatnav ul li a[data-chat='" + currentChat + "']").addClass 'active'

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

        # IE9 Hack
        $('#chat-' + channel).width '300px'
        $('#chat-' + channel).height '335px'
        doResize()

getRandomUsers = ->
    randomUser = null
    usernames = $('.index-entry').map(-> $(this).attr 'data-gbusername').get()
    for key, value of playerChannels
        index = usernames.indexOf value
        if index > -1
            usernames.splice index, 1
    while not randomUser?
        liveUsers = $('.index-entry.on-air').map(-> $(this).attr 'data-gbusername').get()
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

getChatUrl = (channel, site) ->
    url = ''
    if channel == 'irc'
        url = IRC_URL;
    else if site == "twitch"
        url = TWITCH_CHAT_URL + channel + '/chat'
    else if site == "hitbox"
        url = HITBOX_CHAT_URL + channel
    else if site == "mixer"
        url = MIXER_CHAT_URL + channel
    else if site == "youtube"
        url = ""
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
