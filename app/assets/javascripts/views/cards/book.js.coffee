Doers.BookView = Ember.ContainerView.extend Doers.CardViewMixin,
  childViews: ['titleView', 'footerView']
  titleView: Doers.CardTitleView
  footerView: Doers.CardFooterView

