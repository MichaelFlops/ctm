dirty = false

converter = new Markdown.Converter()
markdown = (s) -> converter.makeHtml(s)

code = ''
textarea = undefined
outputarea = undefined
showHideCodeButton = undefined
filePicker = undefined

hideCodeText = 'Hide code'
showCodeText = 'Show code'

window.addEventListener('beforeunload', (e) ->
  if dirty
    e.returnValue = 'Are you sure you want to leave this page?'
)

window.App =
  init: ->
    textarea = CodeMirror $('#source .panel-body').get(0),
      value: '# Headline\n\nThis is some plain
      text.\n\n    print("Hello World");'
      mode: 'markdown'
      indentUnit: 4

    outputarea = $('#output')

    showHideCodeButton = $('#showHideCodeButton')
    showHideCodeButton.text(hideCodeText)
    showHideCodeButton.click(showOrHideCode)

    $('#loadButton').click(load)
    filePicker = $('#filePicker')
    filePicker.on('change', load2)

    $('#saveButton').click(save)

    setInterval(possiblyUpdate, 2000)

    $("#vimmode").on "change", ->
      console.log $("#vimmode").is(":checked")
      textarea.setOption 'vimMode', $("#vimmode").is(":checked")

possiblyUpdate = ->
  return if code == textarea.getValue()

  dirty = true

  code = textarea.getValue()
  md = markdown(code)
  outputarea.find('.output').html(md)
  jsa = []
  n = 0
  $('#output .output code').parent('pre').replaceWith(-> (
    jsa.push($(this).children().text())
    replacement = $('<div class="widget">')
    replacement.attr('id', 'js' + (n++))
    replacement
  ))

  all_js = ''
  for js,n in jsa
    all_js += js
    all_js += ';App.ctx.setSection($("#js' + (n + 1) + '"));'
  f = eval('(function() {' + all_js + '})')
  run(f, $('#js0'))  if jsa.length > 0

showOrHideCode = (-> (
  showing = true
  (_) -> (
    button = showHideCodeButton
    if showing
      $('#source').fadeOut ->
        outputarea.removeClass 'col-xs-6'
        outputarea.addClass 'col-xs-12'
      button.text(showCodeText)
    else
      outputarea.removeClass 'col-xs-12'
      outputarea.addClass 'col-xs-6'
      $('#source').fadeIn()
      button.text hideCodeText
    showing = !showing
  )
))()

load = ->
  if dirty
    if !window.confirm('Are you sure you want to load a new file without' +
                       'saving this one first?')
      return
  filePicker[0].click()

load2 = ->
  file = filePicker[0].files[0]
  if file == undefined
    console.log('file is undefined')
    return
  reader = new FileReader()
  reader.onload = (_) ->
    if reader.result == undefined
      console.log('file contents are undefined')
      return
    textarea.setValue(reader.result)
  reader.readAsText(file)

save = ->
  0
