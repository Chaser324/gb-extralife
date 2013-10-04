
#################
### CONSTANTS ###
#################

PLAYER_URL = 'http://www.twitch.tv/widgets/raw/live_embed_player.swf'

CHAT_WIDTH = 300

WIDTH_LARGE = 0
HEIGHT_LARGE = 0

WIDTH_MED = 0
HEIGHT_MED = 0

WIDTH_SMALL = 0
HEIGHT_SMALL = 0

BANNER_HEIGHT = 252

TOTAL_UPDATE_RATE = 30000

flashvars = 
    enable_javascript: "true"
    fullscreen_click: "true"
    video_width: "427"
    video_height: "240"
    auto_play: "true"

params =
    allowFullScreen: "true"
    allowscriptaccess: "always"
    wmode: "opaque"

attributes = 
    "class": "layoutElement"

users = 
    1:
        username: 'Matt'
        fund: 'http://www.extra-life.org/participant/pascual'
        stream: 'mattpascual'
        profilePic: 'http://static.giantbomb.com/uploads/square_mini/0/50/1713152-avatar.png'
    2:
        username: 'Happenstance'
        fund: 'http://www.extra-life.org/index.cfm?fuseaction=donorDrive.participant&participantID=45198'
        stream: 'happenstanceuk'
        profilePic: 'http://static.giantbomb.com/uploads/square_mini/13/132030/2445765-6184784399-norma.jpg'
    3:
        username: 'Chaser324'
        fund: 'http://www.extra-life.org/index.cfm?fuseaction=donorDrive.participant&participantID=45793'
        stream: 'chasepettit'
        profilePic: 'http://static.giantbomb.com/uploads/square_mini/0/2840/961540-profile.png'
    # 4:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 5:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 6:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 7:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 8:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 9:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 10:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 11:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 12:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 13:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 14:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 15:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 16:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 17:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 18:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 19:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 20:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 21:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 22:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 23:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 24:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'
    # 25:
    #     username: 'Matt'
    #     fund: 'http://www.extra-life.org/participant/pascual'
    #     stream: 'mattpascual'

#################
### VARIABLES ###
#################

playerChannels =
    stream1: "giantbomb"
    stream2: "chasepettit"
    stream3: "fattony12000"

currentLayout = ''
currentChat = ''

layouts = null

#################
### FUNCTIONS ###
#################

initPage = ->
    for key, value of playerChannels
        addPlayer value, key
    setupLayout 'threeUp'

initEvents = ->
    $('.alert').bind 'closed.bs.alert', ->
        setTimeout doResize, 100
    setTimeout updateTotal, 5000

    $("a[href='#info-content']").click ->
        $('#content-nav li a.active').removeClass 'active'
        $("#content-nav li a[href='#info-content']").addClass 'active'
        $('#stream-index').hide 0
        $('#info-content').show 0, ->
            $('html, body').animate
                scrollTop: $("#content-nav").offset().top
                , 600
    $("a[href='#stream-index']").click ->
        $('#content-nav li a.active').removeClass 'active'
        $("#content-nav li a[href='#stream-index']").addClass 'active'
        $('#info-content').hide 0
        $('#stream-index').show 0, ->
            $('html, body').animate
                scrollTop: $("#content-nav").offset().top
                , 600

initIndex = ->
    source = $('#index-template').html()
    template = Handlebars.compile source
    context = {users}
    html = template context
    $('#stream-container').append html


doResize = ->
    setupLayout currentLayout

setCoords = ->
    if $('#chat1').is(":visible")
        CHAT_WIDTH = 300
    else
        CHAT_WIDTH = 0

    WIDTH_LARGE = $('#streams-wrapper').width() - CHAT_WIDTH
    HEIGHT_LARGE = (WIDTH_LARGE * 9/16) + 28

    WIDTH_MED = $('#streams-wrapper').width() / 2
    HEIGHT_MED = (WIDTH_MED * 9/16) + 28

    WIDTH_SMALL = WIDTH_LARGE / 2
    HEIGHT_SMALL = (WIDTH_SMALL * 9/16) + 28

    if currentLayout == "threeUpHorizontal"
        WIDTH_SMALL = 300;
        HEIGHT_SMALL = 200;

        WIDTH_LARGE = $('#streams-wrapper').width() - WIDTH_SMALL;
        HEIGHT_LARGE = (WIDTH_LARGE * 9/16) + 28

    height = 0

    if currentLayout == "threeUp"
        height = HEIGHT_LARGE + HEIGHT_SMALL
    else if currentLayout == "threeUpHorizontal"
        height = HEIGHT_LARGE
    else if currentLayout == "oneUp"
        height = HEIGHT_LARGE
    else
        height = HEIGHT_MED * 2

    top = $('#streams-wrapper').position().top
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

        CHAT_WIDTH = $('#streams-wrapper').width() - WIDTH_LARGE

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
            chat1:
                x: WIDTH_MED
                y: HEIGHT_MED
                width: WIDTH_MED - 4
                height: HEIGHT_MED - 4
            overallHeight: HEIGHT_MED * 2
        oneUp:
            stream1:
                x: 0
                y: 0
                width: WIDTH_LARGE
                height: HEIGHT_LARGE
            chat1:
                x: WIDTH_LARGE
                y: 0
                width: CHAT_WIDTH - 4
                height: HEIGHT_LARGE - 4
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
            chat1:
                x: WIDTH_LARGE
                y: 0
                width: CHAT_WIDTH - 4
                height: HEIGHT_LARGE + HEIGHT_SMALL - 4
            overallHeight: HEIGHT_LARGE + HEIGHT_SMALL
        threeUpHorizontal:
            stream1:
                x: 0
                y: 0
                width: WIDTH_LARGE
                height: HEIGHT_LARGE
            stream2:
                x: WIDTH_LARGE
                y: 0
                width: WIDTH_SMALL
                height: HEIGHT_SMALL
            stream3:
                x: WIDTH_LARGE
                y: HEIGHT_SMALL
                width: WIDTH_SMALL
                height: HEIGHT_SMALL
            chat1:
                x: WIDTH_LARGE
                y: HEIGHT_SMALL * 2
                width: CHAT_WIDTH - 4
                height: HEIGHT_LARGE - (HEIGHT_SMALL * 2) - 4
            overallHeight: HEIGHT_LARGE

setupLayout = (layoutType) ->
    currentLayout = layoutType
    setCoords()
    $('div.layoutElement').each (index) ->
        layoutElement $(this), layouts[layoutType][$(this).attr('id')]

    layoutPlayerSlot 'stream1'
    layoutPlayerSlot 'stream2'
    layoutPlayerSlot 'stream3'

    layoutChat 'chat1'

    $('#streams-wrapper').height layouts[currentLayout].overallHeight


layoutChat = (chat) ->
    layout = layouts[currentLayout][chat]
    chat = $('#' + chat)

    if layout
        chat.css 'left', layout.x
        chat.css 'top', layout.y
        chat.width layout.width
        chat.height layout.height

toggleChat = ->
    $('#chat1').toggle()
    layout(currentLayout)

layoutPlayerSlot = (slot) ->
    layout = layouts[currentLayout][slot]
    player = $('#' + slot)

    if layout
        if player.is('div')
            addPlayer(playerChannels[slot], slot)
            player = $('#' + slot)
        player.css 'left', layout.x
        player.css 'top', layout.y
        player.width layout.width
        player.height layout.height
    else
        removePlayer player

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
    swfobject.embedSWF(PLAYER_URL + "?channel=" + channel,replaceElem,"100","100","9.0.0",
        "expressInstall.swf",flashvars,params,attributes)

addPlayer = (channelName, slotName) ->
    embedPlayer channelName, slotName
    $('#' + slotName).attr('class','layoutElement')

removePlayer = (playerElement) ->
    name = playerElement.attr 'id'
    div = "<div id='" + name + "'></div>"
    playerElement.replaceWith(div)

# $('#donate-widget').load ->
#     $('#donate-widget').contents().find('head').append($("<style type='text/css'> body {background: transparent;} </style>"))

updateTotal = ->    
    $.ajax
        type: 'GET'
        url: 'http://www.extra-life.org/index.cfm?fuseaction=widgets.300x250thermo&teamID=10592'
        success: (data) ->
            value = $(data.responseText).find('#mercury em').text()
            $('#total-value').text(value)
        complete: ->
            setTimeout updateTotal, TOTAL_UPDATE_RATE

swapStream = (slot, channel) ->
    playerChannels[slot] = channel
    setupLayout currentLayout

###################
### MAIN SCRIPT ###
###################

$(document).ready ->
    initPage()
    initEvents()
    initIndex()
    
$(window).resize ->
    doResize()

