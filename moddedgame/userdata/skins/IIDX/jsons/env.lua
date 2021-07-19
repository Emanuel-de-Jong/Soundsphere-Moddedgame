number = function(timeState, logicalState, n)
    return n
end

linear = function(timeState, logicalState, data)
    return data[1] + data[2] * (timeState.scaledFakeVisualDeltaTime or timeState.scaledVisualDeltaTime)
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