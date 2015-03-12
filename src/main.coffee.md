# Documentation for main.coffee
## Marcelo Siero and Michael Betts
### March 9, 2015

This is an attempt at creating a super well-annotated program,
with so much detail that it helps us learn and relearn how to
program with Coffeescript, Javascript, and various usefule
libraries.  Much like this project itself, annotating the program
this way with markdown, is illustrative of some potential ideas in
good pedagogy for the teaching Computer Science.

The annotated programs are from a program written by [Christopher Schuster](https://users.soe.ucsc.edu/~cschuster/), 
[Thomas Schmitz](https://users.soe.ucsc.edu/~tschmitz/), and Marcelo Siero, that are found in the CTM repository, 

Some variable to control what the program does,
**EYE** document meaning later.

>     diskOutdated = false
>     renderOutdated = true
>     

Create a new object called "converter" of the Markdown.Converter class
which is documented [here](http://code.google.com/p/pagedown/)

>     converter = new Markdown.Converter()

Declare a function called markdown with argument (s) that returns
a call to method convert.makeHtml(s)

>     markdown = (s) -> converter.makeHtml(s)
>     

Create some sample "CTM" code to start this off with
using a heredoc (uses """) and interpolates if needed.

*code* is a huge formatted string that displays as an example once the page renders.

>     code = """
>     ## Bouncing ball
>     
>     The **gravitational force** will accelerate an object starting at a certain
>     height.
>      
>     Gravity (0-10, Earth surface would be about 9.81):
>     
>         var gravity = slider(0, 10, 0.1, 1.5);
>     
>     Starting Height (0-100m):
>     
>         var start = slider(0, 100, 1, 100);
>     
>     Upon hitting the ground, a portion of the *kinetic energy* will be lost, so a
>     *bouncing ball* will be jump back up with less velocity than before.
>     
>     Bounce factor (0.0 - 1.0):
>     
>         var bounce = slider(0, 1, 0.1, 0.8);
>     
>     Additionally, drag in term of *air resistance/friction* will also slow down the
>     obj.  The amount of drag affecting an object is usually linear with its
>     velocity which caps the acceleration due to graviation at a certain **terminal
>     velocity**.
>     
>     Drag (0-10%):
>     
>         var drag = 1 - slider(0, 0.1, 0.0001, 0);
>     
>     ### Simulation
>     
>         var height = [], velocity = [], v = 0, h = start;
>         for (var i = 0; i < 100; i++) {
>           v -= gravity;
>             v *= drag;
>             h += v;
>             if (h < 0) { v = -v * bounce; h = 0; }
>             velocity.push(Math.abs(v));
>             height.push(h);
>         }
>     
>     Plotting the height of the bouncing ball over time looks like a series of
>     inverted parables:
>     
>         plotseries(height);
>     
>     By plotting the velocity, it is possible to understand the effects of
>     gravitation and drag on the momentum:
>     
>         plotseries(velocity);"""

-----------------

>     
>        textarea = undefined
>        outputarea = undefined
>        showCodeButton = undefined
>        hideCodeButton = undefined
>        filePicker = undefined

Pre-existing object window, has a method addEventListener
we invoke that method, with string 'beforerunload' and 
a callback to an anomymous function with parameter (e)
and body of code is what follows the arrow.

EventListener Methods are documented [here](http://www.w3schools.com/js/js_htmldom_eventlistener.asp),  

You can add event listeners to any DOM object not only HTML elements. i.e the window object.
Here is an example of adding an event handler to an element. 

element.addEventListener("click", function(){ alert("Hello World!"); });

How can I display "Are you sure you want to leave the page?" when the user 
actually tries to close the page (click the X button on the browser window 
or tab) not when he tries to navigate away from the page (click on another link).

Javascript’s window.onbeforeunload event is useful for catching users that try to browse away from your page without having completed a certain action. Modern web applications such as Gmail and WordPress have made good use of this event.

Being a non-standard event originally invented by Microsoft back in the IE4 days, window.onbeforeunload has some real quirks, although thankfully every major modern browser does support it.

'beforeunload' gets used with EventListener methods like the one below. 
The event 'beforeunload' makes reference to the HTML window.onbeforeunload event
in Javascript.  This works on all browsers according to 
[this](http://help.dottoro.com/larrqqck.php Explains all about the event names.)
reference.

**EYE** what is the purpose of diskOutdated variable?

>     
>        window.addEventListener('beforeunload', (e) ->
>          if diskOutdated
>            e.returnValue = 'Are you sure you want to leave this page?'
>        )
>     

**EYE** What is window.App??

>        window.App =

Defining method init within window.App 
It looks like here we are defining a method without
a parameter ????

>          init: ->

I think this is **EYE** calling a function
or instantiating an object called CodeMirror with four parametrs.
By taking out the parenthesis that usually go with function calls
- it feels harder for me to get used to reading this code.

Note, in coffescript there are many ways to pass parameters to 
a function. Among these is a call by name, which is probably what the
value:, mode: params are about. 

**EYE** Continue documenting the rest, and windows.coffee until it is done.

>            textarea = CodeMirror $('#source .panel-body').get(0),
>              value: code
>              mode: 'markdown'
>              indentUnit: 4
>     
>            outputarea = $('#output')
>     
>            showCodeButton = $('#showCodeButton')
>            hideCodeButton = $('#hideCodeButton')
>            showCodeButton.click(showCode)
>            hideCodeButton.click(hideCode)
>     
>            $('#loadButton').click(load)
>            filePicker = $('#filePicker')
>            filePicker.on('change', load2)
>     
>            $('#saveButton').click(save)
>     
>            setInterval(possiblyUpdate, 2000)
>     
>            $("#vimmode").on "change", ->
>              console.log $("#vimmode").is(":checked")
>              textarea.setOption 'vimMode', $("#vimmode").is(":checked")
>     
>        possiblyUpdate = ->
>          if code != textarea.getValue()
>            diskOutdated = true
>            renderOutdated = true
>          code = textarea.getValue()
>     
>          return if !renderOutdated
>     
>          renderOutdated = false
>     
>          md = markdown(code)
>          outputarea.find('.output').html(md)
>          jsa = []
>          n = 0
>          $('#output .output code').parent('pre').replaceWith(-> (
>            jsa.push($(this).children().text())
>            replacement = $('<div class="widget">')
>            replacement.attr('id', 'js' + (n++))
>            replacement
>          ))
>     
>          if jsa.length == 0
>            return
>     
>          all_js = ''
>          for js,n in jsa
>            all_js += js
>            all_js += ';App.ctx.setSection($("#js' + (n + 1) + '"));'
>        
>          try
>            f = eval('(function() {' + all_js + '})')
>          catch e
>            error = $('<p style="color:red;">')
>            error.text(e.toString())
>            $('#js0').append error
>            return
>        
>          run(f, $('#js0'))  if jsa.length > 0
>        
>        hideCode = ->
>          $('#source').fadeOut ->
>            outputarea.removeClass 'col-xs-6'
>            outputarea.addClass 'col-xs-12'
>          showCodeButton.fadeIn()
>        
>        showCode = ->
>          outputarea.removeClass 'col-xs-12'
>          outputarea.addClass 'col-xs-6'
>          $('#source').fadeIn()
>          showCodeButton.fadeOut()
>        
>        load = ->
>          if diskOutdated
>            if !window.confirm('Are you sure you want to load a new file without' +
>                               'saving this one first?')
>              return
>          filePicker[0].click()
>        
>        load2 = ->
>          file = filePicker[0].files[0]
>          if file == undefined
>            console.log('file is undefined')
>            return
>          reader = new FileReader()
>          reader.onload = (_) ->
>            if reader.result == undefined
>              console.log('file contents are undefined')
>              return
>        
>            # Populate the text field with the new source code
>            code = reader.result
>            textarea.setValue(reader.result)
>            diskOutdated = false
>            renderOutdated = true
>        
>          reader.readAsText(file)
>        
>        save = ->
>          console.log('attempting to save')
>          download('file.ctm', textarea.getValue())
>        
>        download = (filename, text) ->
>          a = $('<a>')
>          a.attr
>            href: 'data:text/plain;charset=utf-8,' + encodeURIComponent(text)
>            download: filename
>          a.appendTo($('body'))
>          a[0].click()
>          a.remove()
>          diskOutdated = false
