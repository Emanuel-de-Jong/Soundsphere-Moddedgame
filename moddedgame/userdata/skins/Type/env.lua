function printT(parentTable, path)
    local file
    if path then file = io.open(path, "a+") end
    local tostring, next, rep, type, format, pairs, concat, print = tostring, next, string.rep, type, string.format, pairs, table.concat, print
    if type(parentTable) ~= "table" then
        if path then
            file:write(tostring(parentTable) .. "\n")
            file:close()
            return print("printT done")
        else
            return print(tostring(parentTable))
        end
    end
    local t, tTabs, tablesInTSize
    local tableStack = {{ 1, parentTable, 1 }}
    local tableStackSize = 1
    local toPrint = {}
    local toPrintSize = 0
    local tableHistory = { [tostring(parentTable)] = true }
    local tablesInT = {}
    while next(tableStack) ~= nil do
        t = tableStack[tableStackSize]
        tTabs = rep("  ", t[3] - 1)
        if type(t[1]) == "string" then t[1] = format("\"%s\"", t[1]) end
        toPrintSize = toPrintSize + 1
        toPrint[toPrintSize] = format("%s[%s] -- %s, depth: %d\n", tTabs, tostring(t[1]), tostring(t[2]), t[3])
        tTabs = tTabs .. "  "
        tablesInTSize = 0
        for key, value in pairs(t[2]) do
            if type(value) == "table" and tableHistory[tostring(value)] == nil then
                tablesInTSize = tablesInTSize + 1
                tablesInT[tablesInTSize] = { key, value, t[3] + 1 }
                tableHistory[tostring(value)] = true
            else
                if type(key) == "string" then key = format("\"%s\"", key) end
                if type(value) == "string" then value = format("\"%s\"", value) end
                toPrintSize = toPrintSize + 1
                toPrint[toPrintSize] = format("%s[%s] = %s\n", tTabs, tostring(key), tostring(value))
            end
        end
        tableStack[tableStackSize] = nil
        tableStackSize = tableStackSize - 1
        for i = tablesInTSize, 1, -1 do
            tableStackSize = tableStackSize + 1
            tableStack[tableStackSize] = tablesInT[i]
        end
    end
    if path then
        file:write(concat(toPrint) .. "\n")
        file:close()
        print("printT done")
    else
        print(concat(toPrint))
    end
end
-- printT(timeState, "E:\\Media\\Downloads\\timeState.txt")




color1 = function(timeState, logicalState, data) return {255, 255, 255, 255} end
color2 = function(timeState, logicalState, data) return {255, 000, 000, 255} end
color3 = function(timeState, logicalState, data) return {000, 255, 000, 255} end
color4 = function(timeState, logicalState, data) return {000, 000, 255, 255} end



quadratic = function(timeState, logicalState, data)
    local deltaTime = timeState.scaledVisualDeltaTime
    return ((deltaTime + 1) ^ data[2]) + data[1]
end

exponential = function(timeState, logicalState, data)
    local deltaTime = timeState.scaledVisualDeltaTime
    deltaTime = deltaTime * 10
    return (data[2] ^ (deltaTime + 1)) + data[1]
end

perspective = function(timeState, logicalState, data)
    local deltaTime = timeState.scaledVisualDeltaTime
    return (data[2] * (deltaTime + 1)) + data[1]
end

linear = function(timeState, logicalState, data)
    local deltaTime = timeState.scaledFakeVisualDeltaTime or timeState.scaledVisualDeltaTime
    return (data[2] * deltaTime) + data[1]
end

number = function(timeState, logicalState, n)
    return n
end






local colors = {
	blank = {0, 0, 0, 0},
	white = {255, 255, 255, 255},
	red = {255, 100, 100, 255},
	grey = {120, 120, 120, 255}
}

colorBlank = function(timeState, logicalState, data)
	return colors.blank
end

colorMeasure = function(timeState, logicalState, data)
	return colors.white
end

colorShortNote = function(timeState, logicalState, data)
	if logicalState == "passed" then
		return colors.blank
	end
	return colors.white
end

colorLongNoteTail = function(timeState, logicalState, data)
	return colors.white
end

colorLongNoteBody = function(timeState, logicalState, data)
    if logicalState == "clear" or logicalState == "skipped" then
		return colors.grey
	elseif logicalState == "startMissed" then
		return colors.red
	end
	return colors.white
end

colorLongNoteHead = function(timeState, logicalState, data)
	return colors.white
end