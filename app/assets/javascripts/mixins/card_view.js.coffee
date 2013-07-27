Doers.CardViewMixin = Ember.Mixin.create
  classNames: ['card']
  classNameBindings: ['typeClassName', 'isEditing:edit']
  childViews: ['contentView', 'editView']
  isEditing: false

  typeClassName: ( ->
    if type = @get('content.type')
      @get('content.type').dasherize()
  ).property('content.type')
