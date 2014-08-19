Meteor.startup ->
  Session.setDefault "viewing", "bidder"

Template.main.helpers
  viewing: (viewName) ->
    Session.equals "viewing", viewName
  currentView: ->
    Session.get "viewing"

Template.main.events
  'click button[data-viewing]': (evt) ->
    Session.set "viewing", evt.currentTarget.dataset.viewing
  'click .gavel-logo': (evt) ->
    target = $(evt.currentTarget)
    if !target.hasClass('animated')
      target.addClass('animated')

      target.one('webkitAnimationEnd oanimationend msAnimationEnd animationend',
        (e) -> target.removeClass('animated'))
