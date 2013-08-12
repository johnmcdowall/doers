Doers.Card = DS.Model.extend
  ticker: Date.now()
  assetableType: 'Card'

  title: DS.attr('string')
  titleHint: DS.attr('string')
  question: DS.attr('string')
  help: DS.attr('string')
  content: DS.attr('string')
  position: DS.attr('number')
  type: DS.attr('string')
  style: DS.attr('string')

  project: DS.belongsTo('Doers.Project')
  board: DS.belongsTo('Doers.Board')
  user: DS.belongsTo('Doers.User', readOnly: true)

  updatedAt: DS.attr('date', readOnly: true)
  userNicename: DS.attr('string', readOnly: true)

  isEditing: false
  isBuilding: false

  init: ->
    setInterval ( =>
      @set('ticker', Date.now())
    ), 60000
    @_super()

  slug: (->
    'card-' + @get('id')
  ).property('id', 'type')

  dropdownSlug: ( ->
    'dropdown-' + @get('slug')
  ).property('slug')

  editSlug: ( ->
    'edit-' + @get('slug')
  ).property('slug')

  didUpdate: ->
    @set('updatedAt', new Date())

  lastUpdate: ( ->
    moment(@get('updatedAt')).fromNow()
  ).property('updatedAt', 'ticker')
