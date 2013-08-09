Doers.Router.reopen
  rootURL: '/'

Doers.Router.map (match)->
  @resource 'projects', ->
    @route('new')
    @route('show', {path: ':project_id'})
    @route('import')
    @route('import-running')
  @resource 'boards', ->
    @route 'show', {path: ':board_id'}
    @route 'new'
    @route 'templates'
