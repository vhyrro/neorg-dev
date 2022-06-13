return {
    new_hook = function(events, hook)
        events = (type(events) == "string" and { events } or events)

        for _, event in ipairs(events or {}) do
            table.insert(hooks[event], hook)
        end
    end,
}
