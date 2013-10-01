#= require jquery
#= require nprogress
#= require nprogress-ajax

#= require_self

((w, $) ->
  Doers =
    Notifications:
      container: $('#notifications')

      setup: ->
        @container.find('.close').one 'click', @close

      close: (e) ->
        e.preventDefault()
        $(@).parents('.alert-box').remove()

    Progress:
      setup: ->
        NProgress.configure
          showSpinner: false
          ease: 'ease'
          speed: 500

    Navigation:
      setup: ->
        $('.nav-toggle').on 'click', @toggle

      toggle: (e) ->
        $('.nav').toggleClass('narrow')
        $('.content').toggleClass('wide')

    Mixpanel:
      setup: ->
        mixpanel.track_links('#signin-btn', 'LOGIN', {TYPE: 'AngelList'})
        mixpanel.track_links('#signout-btn', 'LOGOUT')
        mixpanel.track_links('#export-btn', 'EXPORT')

    setup: ->
      @Notifications.setup()
      @Progress.setup()
      @Navigation.setup()
      @Mixpanel.setup()

  Doers.setup()

) window, jQuery
