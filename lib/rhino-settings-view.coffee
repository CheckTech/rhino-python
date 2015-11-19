module.exports =
class RhinoSettingsView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.id = 'RhinoSettingsView'

    title = document.createElement('div')
    title.textContent = "Rhino Python Search Paths:"
    title.classList.add('text-highlight')
    @element.appendChild(title)

    ul = document.createElement('ul')
    li = document.createElement('li')
    li.setAttribute('v-repeat', 'paths')

    p = document.createElement('span')
    p.textContent = '{{path}}'
    p.setAttribute('v-on', 'click: select(this)')
    li.appendChild(p)

    li.setAttribute('class', "{{markdelete ? 'markdelete' : ''}} {{selected ? 'selected' : ''}}")
    ul.appendChild(li)
    @element.appendChild(ul)

    btnGrpDiv = document.createElement('div')
    btnGrpDiv.classList.add('inline-block')
    btnGrpDiv.classList.add('btn-group')

    btn = document.createElement('button')
    btn.classList.add('btn')
    btn.classList.add('icon')
    btn.classList.add('icon-plus')
    btn.setAttribute('v-on', 'click: add')
    btnGrpDiv.appendChild(btn)

    btn = document.createElement('button')
    btn.classList.add('btn')
    btn.classList.add('icon')
    btn.classList.add('icon-dash')
    btn.setAttribute('v-attr', 'disabled: deleteDisabled')
    btn.setAttribute('v-on', 'click: delete')
    btnGrpDiv.appendChild(btn)

    btn = document.createElement('button')
    btn.classList.add('btn')
    btn.classList.add('icon')
    btn.classList.add('icon-arrow-up')
    btn.setAttribute('v-attr', 'disabled: upDisabled')
    #btn.setAttribute('v-on', 'click: move-up')
    btnGrpDiv.appendChild(btn)

    btn = document.createElement('button')
    btn.classList.add('btn')
    btn.classList.add('icon')
    btn.classList.add('icon-arrow-down')
    btn.setAttribute('v-attr', 'disabled: downDisabled')
    btn.setAttribute('v-on', 'click: move-down')
    btnGrpDiv.appendChild(btn)

    btn = document.createElement('button')
    btn.classList.add('btn')
    btn.classList.add('icon')
    btn.classList.add('icon-file-directory')
    btn.setAttribute('v-attr', 'disabled: showDisabled')
    btn.setAttribute('v-on', 'click: show-in-finder')
    btnGrpDiv.appendChild(btn)

    btn = document.createElement('button')
    btn.classList.add('btn')
    btn.classList.add('icon')
    btn.classList.add('icon-sync')
    btn.setAttribute('v-attr', 'disabled: saveDisabled')
    btn.setAttribute('v-on', 'click: save')
    btn.textContent = 'save'
    btnGrpDiv.appendChild(btn)

    btn = document.createElement('button')
    btn.classList.add('btn')
    btn.classList.add('icon')
    btn.classList.add('icon-history')
    btn.setAttribute('v-attr', 'disabled: revertDisabled')
    btn.setAttribute('v-on', 'click: revert')
    btn.textContent = 'revert'
    btnGrpDiv.appendChild(btn)

    @element.appendChild(btnGrpDiv)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
