local function error(content)
	ya.notify({ title = 'Harp', content = tostring(content), timeout = 2.5, level = 'error' })
end

local function notify(content)
	ya.notify({ title = 'Harp', content = tostring(content), timeout = 2.5, level = 'info' })
end

local INPUTBOX_WIDTH = 16

local INPUTBOX_POSITION = {
	'top-center',
	w = INPUTBOX_WIDTH,
}

local function harp_get()
	local input, event = ya.input({
		title = 'Get cwd harp',
		position = INPUTBOX_POSITION,
	})
	if event ~= 1 or not input then return end
	local output, _ = Command('harp'):args({ 'get', 'harp_dirs', input, '--path' }):output()
	if not output or not output.status.success then
		error('register `' .. input .. "` isn't set")
		return
	end
	local path = output.stdout
	ya.manager_emit('cd', { path })
end

local get_cwd = ya.sync(function() return cx.active.current.cwd end)

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
	entry = function(_, args)
		if not args or not args[1] then return end
		if args[1] == 'get' then
			harp_get()
		elseif args[1] == 'set' then
			harp_set()
		end
	end,
}
