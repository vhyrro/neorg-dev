local utilities = {}

--- Returns the item that matches the first item in statements
---@param value any #The value to compare against
---@param compare? function #A custom comparison function
---@return function #A function to invoke with a table of potential matches
utilities.match = function(value, compare)
    -- Returning a function allows for such syntax:
    -- match(something) { ..matches.. }
    return function(statements)
        if value == nil then
            return
        end

        -- Set the comparison function
        -- A comparison function may be required for more complex
        -- data types that need to be compared against another static value.
        -- The default comparison function compares booleans as strings to ensure
        -- that boolean comparisons work as intended.
        compare = compare
            or function(lhs, rhs)
                if type(lhs) == "boolean" then
                    return tostring(lhs) == rhs
                end

                return lhs == rhs
            end

        -- Go through every statement, compare it, and perform the desired action
        -- if the comparison was successful
        for case, action in pairs(statements) do
            if compare(value, case) then
                -- The action can be a function, in which case it is invoked
                -- and the return value of that function is returned instead.
                if type(action) == "function" then
                    return action(value)
                end

                return action
            end
        end

        -- If we've fallen through all statements to check and haven't found
        -- a single match then see if we can fall back to a `_` clause instead.
        if statements._ then
            local action = statements._

            if type(action) == "function" then
                return action(value)
            end

            return action
        end
    end
end

--- Wraps a function in a callback
---@param function_pointer function #The function to wrap   
---@vararg ... #The arguments to pass to the wrapped function
---@return function #The wrapped function in a callback
utilities.wrap = function(function_pointer, ...)
    local params = { ... }
        
    if type(function_pointer) ~= "function" then
        local prev = function_pointer
       
        -- luacheck: push ignore
        function_pointer = function(...)
            return prev
        end
        -- luacheck: pop
    end

    return function()
        return function_pointer(unpack(params))
    end
end

--- Maps a function to every element of a table
--  The function can return a value, in which case that specific element will be assigned
--  the return value of that function.
---@param tbl table #The table to iterate over
---@param callback function #The callback that should be invoked on every iteration
---@return table #A modified version of the original `tbl`.
utilities.map = function(tbl, callback)
    local copy = vim.deepcopy(tbl)

    for k, v in pairs(tbl) do
        local cb = callback(k, v, tbl)

        if cb then
            copy[k] = cb
        end
    end

    return copy
end

return utilities
