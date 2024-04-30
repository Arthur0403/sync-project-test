if vim.fn.has("nvim-0.7.0") == 0 then
	vim.api.nvim_err_writeln("sync_project_test_plugin requires at least nvim-0.7.0.1")
	return
end

-- make sure this file is loaded only once
if vim.g.loaded_sync_project_test_plugin == 1 then
	return
end
vim.g.loaded_sync_project_test_plugin = 1

-- создайте любую глобальную команду, которая не зависит от настроек пользователя
-- обычно большинство команд/сопоставлений лучше определять в функции настройки
-- Будьте осторожны и не злоупотребляйте этим файлом!
local sync_project_test_plugin = require("sync_project_test_plugin")

vim.api.nvim_create_user_command("TestSync", sync_project_test_plugin.generic_greet, {})
vim.api.nvim_create_user_command("InitProject", sync_project_test_plugin.init_project, {})
