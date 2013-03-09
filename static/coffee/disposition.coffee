@disposition =

    # Include other modules
    initialize: (msg) ->
        @job = new @Job @jobTables
        @job.display()

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

    Job: class Job

        constructor: (tables) ->
            @target = tables.target()
            @patron = tables.target()
            @type = tables.type()
            @location = tables.location()

        display: ->
            alert @

        toString: ->
            "Type: #{@type}\nTarget: #{@target}\nPatron: #{@patron}\nLocation: #{@location}"

