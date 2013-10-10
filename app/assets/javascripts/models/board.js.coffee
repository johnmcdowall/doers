Doers.Board = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  progress: DS.attr('number', readOnly: true)

  parentBoard: DS.belongsTo('Doers.Board', inverse: 'branches')
  project: DS.belongsTo('Doers.Project', inverse: 'boards')
  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'branchedBoards')
  author: DS.belongsTo('Doers.User', readOnly: true, inverse: 'authoredBoards')
  team: DS.belongsTo('Doers.Team', readOnly: true, inverse: 'boards')
  cover: DS.belongsTo('Doers.Asset', inverse: 'board')

  collections: DS.attr('array', readOnly: true, defaultValue: [])
  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)

  activities: DS.hasMany('Doers.Activity', readOnly: true, inverse: 'board')
  branches: DS.hasMany('Doers.Board', inverse: 'parentBoard')
  branchesCount: DS.attr('number', readOnly: true)
  cards: DS.hasMany('Doers.Card', inverse: 'board')
  memberships: DS.hasMany('Doers.Membership', readOnly: true, inverse: 'board')
  cardsCount: DS.attr('number', readOnly: true)
  topics: DS.hasMany('Doers.Topic', readOnly: true, inverse: 'board')

  slug: (->
    'board-' + @get('id')
  ).property('id')

  completedCardsCount: ( ->
    # TODO: Make this smarter
    count = 0
    @get('cards').map (c)->
      if !!c.get('title')
        count++
    count
  ).property('cards.@each.title')

  completedCardsProgress: ( ->
    (@get('completedCardsCount') / @get('cardsCount')) * 100
  ).property('completedCardsCount')

  topicsOrderChanged: ->
    topics = @get('topics')
    source = topics.filterProperty('moveSource', true).get('firstObject')
    target = topics.filterProperty('moveTarget', true).get('firstObject')

    if target and source and (target.get('id') != source.get('id'))
      targetAt = target.get('position')
      sourceAt = source.get('position')
      diff = targetAt - sourceAt

      # If we need to shift some cards in between
      if Math.abs(diff) != 1
        # Shift/Unshift any topics which position is affected
        topics.forEach (topic) ->
          topicAt = topic.get('position')
          # If source is before target
          if diff > 0 and topicAt < targetAt and topicAt > sourceAt
            topic.decrementProperty('position')
          # If source is after target (all goes desc order)
          if diff < 0 and topicAt >= targetAt and topicAt < sourceAt
            topic.incrementProperty('position')
          if diff == 0
            topic.set('position', topics.indexOf(topic))

        # Set source after target
        if diff > 0
          source.set('position', targetAt - 1)
        else
          source.set('position', targetAt)

      else
        source.set('position', targetAt)
        target.set('position', sourceAt)

      # Set source after target
      topics.setEach('moveSource', false)
      topics.setEach('moveTarget', false)

      source.save() if source.get('id')
      target.save() if source.get('id')
