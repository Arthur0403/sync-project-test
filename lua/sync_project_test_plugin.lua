local sync_project_test_module = require("sync_project_test_plugin.sync_project_test_module")

local sync_project_test_plugin = {}

local function with_defaults(options)
	return {
		name = options.name or "John Doe",
	}
end

-- Предполагается, что эта функция должна вызываться пользователями явно для настройки этого
-- плагина
-- TODO: у моего плагина будет какая-то настройка?
function sync_project_test_plugin.setup(options)
	-- избегайте устанавливать глобальные значения вне этой функции. Глобальное состояние
	-- мутации трудно выполнять отладку и тестирование, поэтому наличие их в один
	-- function/module делает его легче рассуждать о возможных изменениях
	sync_project_test_plugin.options = with_defaults(options)

	-- выполняйте здесь любые действия, необходимые для запуска вашего плагина, например, создавайте команды и
	-- сопоставления, которые зависят от значений, переданных в параметрах
	if sync_project_test_plugin.options.name == "John Doe" then
		vim.api.nvim_create_user_command("MyAwesomePluginGreet", sync_project_test_plugin.greet, {})
	end
end

function sync_project_test_plugin.is_configured()
	return sync_project_test_plugin.options ~= nil
end

-- Это функция, которая будет использоваться вне кода этого плагина.
-- Думайте об этом как о публичном API
-- TODO: не понятно пока, зачем нужно?
function sync_project_test_plugin.greet()
	if not sync_project_test_plugin.is_configured() then
		return
	end

	-- постарайтесь сосредоточить всю тяжелую логику на чистых functions/modules, которые не
	-- зависит от API-интерфейсов Neovim. Это облегчает их тестирование
	local greeting = sync_project_test_module.greeting(sync_project_test_plugin.options.name)
	print(greeting)
end

-- Еще одна функция, относящаяся к общедоступному API. Эта функция не зависит от
-- конфигурации пользователя
function sync_project_test_plugin.generic_greet()
	print("Hello, test-sync!")
end

function sync_project_test_plugin.init_project()
	local init_project = require("sync_project_test_plugin.init_project")
	init_project.init()
end

sync_project_test_plugin.options = nil
return sync_project_test_plugin
