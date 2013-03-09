@dice =

    logging: false

    _log: (msg) ->
        console.log msg if @logging

    _die_name: (size) -> "d#{size}"

    die: (size, name) ->
        die = () -> Math.floor(Math.random() * size) + 1
        die.toString = () -> name
        die

    type: (size) ->
        die_name = @_die_name size
        unless die_name of @
            @[die_name] = @die size, die_name
        @[die_name]

    choose: (list) ->
        die = @type list.length
        roll = die()
        @_log "Choosing from #{JSON.stringify list}"
        list[roll - 1]

    table: (data) ->
        data = @_prepare_table_data data
        => @_deep_choose data

    _deep_choose: (data) ->
        if _.isArray data
            @_deep_choose dice.choose data
        else
            data

    _prepare_table_data: (data) ->
        if _.isArray data
            return (@_prepare_table_data(d) for d in data)
        unless _.isObject data
            return data
        ## Past here, it's an object
        out = []
        for own key, datum of data
            boundaries = key.split("-")
            prepared = @_prepare_table_data datum
            if boundaries.length == 1
                out.push prepared
            else
                for i in _.range(Number(boundaries[0]), Number(boundaries[1]))
                    out.push prepared
        out


for size in [4, 6, 8, 10, 12]
    @dice.type size


            



