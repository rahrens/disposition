class Job extends Backbone.Model
    # Expect attributes to be 
    #   title: str
    #   target: FactionPlaceholder
    #   patron: FactionPlaceholder
    #   type: str
    #   location: LocationPlaceholder
    #   description: str
    #   status: (open|engaged|closed)
    #   history: []
    defaults: ->
        title: 'New job'
        description: ''
        status: 'open'
        history: []
    

JobsList: class JobsList extends Backbone.Collection

    model: Job

    push: (args...) ->
        console.log "JobsList.push called with #{JSON.stringify args}"
        super args...


JobView: class JobView extends Backbone.View

    template: _.template """<ul>
        <li><span class="attr-title">Type:</span><span class="attr-val"><%= type %></span></li>
        <li><span class="attr-title">Target:</span><span class="attr-val"><%= target %></span></li>
        <li><span class="attr-title">Patron:</span><span class="attr-val"><%= patron %></span></li>
        <li><span class="attr-title">Location:</span><span class="attr-val"><%= location %></span></li>
    </ul>"""

    tagName: 'li'

    className: 'job-card'

    render: ->
        @$el.html @template @model.toJSON()


JobsListView: class JobsListView extends Backbone.View

    template: _.template """
    <%= num_jobs %> jobs:
    """
    
    render: ->
        console.log "JobsListView.render() called ..."
        @$el.html @template num_jobs: @collection.length


JobFactory: class JobFactory

    constructor: (@tables, @availableJobs, list_selector) ->
        @$list = $(list_selector)

    create: =>
        jobdata =
            target: @tables.target()
            patron: @tables.target()
            type: @tables.type()
            location: @tables.location()
        console.log "About to create job with data #{JSON.stringify jobdata}"
        job = new Job jobdata
        console.log "Created job: #{job}"
        jobView = new JobView model: job
        jobView.listenTo job, "change", jobView.render
        console.log "Created view: #{jobView}"
        jobView.render()
        @$list.append(jobView.el)
        @availableJobs.push job
        console.log "About to render jobView ..."

#     jobFactory: (tables) ->
#         jobdata =
#             target: tables.target()
#             patron: tables.target()
#             type: tables.type()
#             location: tables.location()
#         console.log "About to create job with data #{JSON.stringify jobdata}"
#         job = new @Job jobdata
#         console.log "Created job: #{job}"
#         jobView = new @JobView model: job
#         jobView.listenTo job, "change", jobView.render
#         console.log "Created view: #{jobView}"
#         @availableJobs.push job
#         console.log "About to render jobView ..."
#         jobView.render()


@disposition =

    # Include other modules
    initialize: ({jobsCount, jobsList, createJob}) ->
        @availableJobs = new JobsList
        @ajlv = new JobsListView
            collection: @availableJobs
            el: $(jobsCount).get()[0]
        @ajlv.listenTo @availableJobs, "all", @ajlv.render
        @ajlv.render()
        @factory = new JobFactory @jobTables, @availableJobs, jobsList
        $(createJob).click @factory.create

    jobTables:
        target: dice.table
            '1-3': [
                'criminal', 'cult', 'guild', 'library', 'temple', 'wizard'
            ]
            '4-5': [
                'diplomat', 'freebooter', 'merchant', 'militarist', 'pilgrim', 'refugee'
            ]
            6: [
                'alien god', 'diabolist', 'immortal', 'outlaw', 'philosopher', 'spirit'
            ]

        type: dice.table [
            'acquisition', 'delivery', 'exploration', 'killing', 'protection', 'raiding'
        ]

        location: dice.table [
            'nearby parish', 'distant parish', 'nearby plane', 'distant plane', 'don\'t know', 'no one knows'
        ]

