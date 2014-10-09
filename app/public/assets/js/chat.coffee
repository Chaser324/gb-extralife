
window.onload = -> 
    messages = []
    socket = io.connect('http://localhost:3700')
    field = document.getElementById("field")
    sendButton = document.getElementById("send")
    content = document.getElementById("chat-content")
 
    socket.on 'message', (data) ->
        if data.message
            messages.push data.message
            html = ''
            for i in [0..messages.length-1]
                html += messages[i] + '<br />'
            content.innerHTML = html
        else
            console.log "There is a problem:", data
 
    sendButton.onclick = ->
        text = field.value
        socket.emit 'send', { message: text }

