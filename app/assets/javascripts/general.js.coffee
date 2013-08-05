$ ->
  class CurrencyTracker

    constructor: ->
      $(".search_query").on "keyup", ->
        $.ajax
          url: $(@).data("url")
          type: "POST"
          data:
            "q": $(@).val()

    initTable: ->
      $(".currency_tracker_table .selecter").on "click", ->
        currencyTracker.toggleActionsAvailability()

      $(".currency_tracker_table tbody tr").on "click", (e) ->
        return if $(e.target).prop("type") == "checkbox"
        checkbox = $(@).find(".selecter")
        if checkbox.prop("checked")
          checkbox.prop "checked", false
        else
          checkbox.prop "checked", true
        currencyTracker.toggleActionsAvailability()

      $(".currency_tracker_table .all_selecter").on "click", ->
        checkboxes = $(".currency_tracker_table .selecter")
        if $(@).prop("checked")
          checkboxes.prop "checked", true
        else
          checkboxes.prop "checked", false
        currencyTracker.toggleActionsAvailability()

     toggleActionsAvailability: ->
       if $(".currency_tracker_table .selecter:checked").length > 0
         $(".table_actions").children().removeClass("disabled")
       else
         $(".table_actions").children().addClass("disabled")

  window.currencyTracker = new CurrencyTracker
  currencyTracker.initTable()