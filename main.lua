local function error(content)
	ya.notify({ title = 'Harp', content = tostring(content), timeout = 2.5, level = 'error' })
end

local function notify(content)
	ya.notify({ title = 'Harp', content = tostring(content), timeout = 2.5, level = 'info' })
end

local INPUTBOX_WIDTH = 32

local INPUTBOX_POSITION = {
	'top-center',
	w = INPUTBOX_WIDTH,
}

local get_cwd = ya.sync(function() return cx.active.current.cwd end)

local function harp_get()
	local input, event = ya.input({
		title = 'Get cwd harp',
		position = INPUTBOX_POSITION,
	})
	if event ~= 1 or not input then return end
	local section_name = 'harp_dirs'
	if input:sub(0, 1) == '.' then
		input = input:sub(2)
		section_name = section_name .. '_' .. tostring(get_cwd())
	end
	local output, _ = Command('harp'):args({ 'get', section_name, input, '--path' }):output()
	if not output or not output.status.success then
		error('register `' .. input .. "` isn't set")
		return
	end
	local path = output.stdout
	ya.manager_emit('cd', { path })
end

local function harp_set()
	local input, event = ya.input({
		title = 'Set cwd harp',
		position = INPUTBOX_POSITION,
	})
	if event ~= 1 or not input then return end
	local cwd = get_cwd()
	local output, _ = Command('harp'):args({ 'update', 'harp_dirs', input, '--path', tostring(cwd) }):output()
	if output and output.status.success then notify('set harp `' .. input .. '`') end
end

return {
	entry = function(_, job)
		if not job.args or not job.args[1] then return end
		if job.args[1] == 'get' then
			harp_get()
		elseif job.args[1] == 'set' then
			harp_set()
		end
	end,
}
