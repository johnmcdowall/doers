Doers.TopicController =
Ember.ObjectController.extend Doers.ControllerAlertMixin,

  commentContent: ''
  cardPicker: false

  # TODO: make this smarter, create singletons for each card type and
  # just switch the `content`.
  cardController: ( ->
    if type = @get('content.card.type')
      @container.resolve('controller:' + type + 'Card').create
        content: @get('content.card')
        container: @container
  ).property('content.card.type')

  cardTemplateName: ( ->
    if type = @get('content.card.type')
      'cards/%@'.fmt(type.underscore())
  ).property('content.card.type')

  cardClassNames: ( ->
    if type = @get('content.card.type') and slug = @get('content.card.slug')
      'card %@ type-%@'.fmt(slug, type.dasherize())
  ).property('content.card.type')

  uploaderView: ( ->
    @container.resolve('view:uploader')
  ).property()

  actions:
    save: ->
      @get('content').save()

    addComment: ->
      content = @get('commentContent')

      if content and content.length > 1
        comment = @store.createRecord 'comment',
          content: content
          commentableId: @get('content.id')
          board: @get('board')
          project: @get('board.project')
          topic: @get('content')
          card: @get('content.card')
        comment.save().then =>
          @set('commentContent', '')
          @get('content.activities').pushObject @store.createRecord 'activity',
            comment: comment
            lastUpdate: comment.get('updatedAt')

    resetComment: ->
      @set('commentContent', '')

    showCardPicker: ->
      @set('cardPicker', true)

    addCard: (type) ->
      card = @store.createRecord type.toLowerCase(),
        user: @get('currentUser')
        board: @get('board')
        project: @get('board.project')
        topic: @get('content')
        type: type
      @set('content.card', card)