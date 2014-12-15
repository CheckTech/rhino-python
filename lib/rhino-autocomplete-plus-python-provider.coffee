{BufferedProcess}  = require "atom"
{Provider, Suggestion} = require "autocomplete-plus"
fuzz = require "fuzzaldrin"
jQuery = require "jquery"

exports.fetchedCompletionData = []

module.exports =
class RhinoAutocompletePlusPythonProvider extends Provider
  exclusive: true
  wordRegex: /[\s\.]\b[a-zA-Z0-9_-]*\b$/ # word following a dot or space

  getInstance: ->
    return this

  fileIsPython: ->
    return /.py$/.test @editor.getPath()

  prefixOfSelection: (selection) ->
    selectionRange = selection.getBufferRange()
    lineRange = [[selectionRange.start.row, 0], [selectionRange.end.row, @editor.lineLengthForBufferRow(selectionRange.end.row)]]
    prefix = ""
    @editor.getBuffer().scanInRange @wordRegex, lineRange, ({match, range, stop}) ->
      stop() if range.start.isGreaterThan(selectionRange.end)

      if range.intersectsWith(selectionRange)
        prefixOffset = selectionRange.start.column - range.start.column
        prefix = match[0][0...prefixOffset] if range.start.isLessThan(selectionRange.start)

    return prefix

  buildSuggestions: ->
    return unless @fileIsPython()
    bp = @editor.getCursorBufferPosition()
    lines = @editor.getTextInBufferRange([[0,0], [bp.row, bp.column]]).split "\n"
    prefix = ""
    if lines.length
      match = @wordRegex.exec lines[lines.length-1]
      prefix = match[0] if match and match.length == 1

    if prefix.length
      prefix = prefix.replace /^[\s\.]/, ''
      suggestionNames = exports.fetchedCompletionData.map (cd) -> cd.Name
      words = fuzz.filter suggestionNames, prefix
      suggestions = words.map (w) => new Suggestion(this, prefix: prefix, word: w)
      return suggestions

    # if line left of cursor starts with a character (not space or dot) and ends with a space or dot
    # then fetch a new list of possible words from Rhino
    return unless lines.length and /.+[\s\.]$/.test lines[lines.length-1]

    last_dot_or_space_column = bp.column - prefix.length
    ccreq = JSON.stringify {Lines: lines, CaretColumn: bp.column - prefix.length, FileName: @editor.getPath()}

    jQuery.ajax
      type: "POST"
      url: "http://localhost:8080/getcompletiondata"
      data: ccreq
      retryLimit: 0
      success: (data) ->
        if not /^no completion data/.test data
          exports.fetchedCompletionData = data
        else
          exports.fetchedCompletionData = []
      error: (data) ->
        if /^NetworkError/.test data.statusText
          alert("Rhino isn't listening for requests.  Run the \"StartAtomEditorListener\" command from within Rhino.")
        else
          console.log "error:", data
      contentType: "application/json"
      dataType: "json"
      async: false
      timeout: 3000

    suggestions = (exports.fetchedCompletionData).map (cd) => new Suggestion(this, prefix:"", word: cd.Name)
    return suggestions
