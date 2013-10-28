Doers.CardComponent = Ember.Component.extend
  classNames: ['card']

  actions:
    edit: ->
      @set('content.isEditing', true)

    save: ->
      @get('content').save().then =>
        @set('content.isEditing', false)
        @get('content.topic').reload()

    destroy: ->
      card = @get('content')
      topic = card.get('topic')
      if card.get('isNew')
        topic.get('cards').removeObject(card)
      else
        card.deleteRecord()
        card.save().then =>
          topic.reload()

    toggleAlignment: ->
      card = @get('content')
      topic = @get('content.topic')
      if card.get('isAlignedCard')
        topic.set('alignedCard', null)
      else
        topic.set('alignedCard', card)

      topic.save().then ->
        topic.get('board').reload()
        topic.reload()
