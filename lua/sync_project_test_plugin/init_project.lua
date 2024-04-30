-- local lfsExists, lfs = pcall(function()
-- 	require("lfs")
-- end)
-- TODO: вынести куда-нибудь в проверки
-- if lfsExists then
-- 	print("Модуль LFS установлен.")
-- -- Здесь можно использовать функции LFS
-- else
-- 	print("Модуль LFS не установлен.")
-- 	-- Обработка ситуации, когда LFS не установлен
-- end
local lfs = require("lfs")
if not lfs then
	error("Модуль lfs не найден. Убедитесь, что он установлен.")
end

local M = {
	FILENAME = "config.ini",
	DIRNAME = ".nvim_config",
	-- сделаем пока попростому
	FILEPATH = ".nvim_config/config.ini",
	-- TODO: как использовать selg
	-- Определение метода внутри метатаблицы для M
	-- __index = {
	--     getFilePath = function(self)
	--         return self.DIRNAME.. "/".. self.FILENAME
	--     end
	-- }
	GITIGNORE = ".gitignore",

	init = function(self)
		local fileData = self.askQuestion()
		-- vim.pretty_print(self.DIRNAME)
		if not self.dirExists(self.DIRNAME) then
			self.createDirectoryIfNotExists(self.DIRNAME)
			self:writeFile(fileData)
			-- добавим папку конфига в .gitignore усли он существует

			if self.fileExists(self.GITIGNORE) then
				self:addGitIgnore(self.GITIGNORE)
			end
		else
			self:writeFile(fileData)
			if self.fileExists(self.GITIGNORE) then
				self:addGitIgnore(self.GITIGNORE)
			end
		end
	end,

	addGitIgnore = function(self, gitignore)
		local gitignorePath = io.open(gitignore, "a")
		gitignorePath:write(self.DIRNAME .. "\n")
		gitignorePath:close()
	end,

	askQuestion = function()
		-- Задаем вопросы и сохраняем ответы в файлы
		local answersQuestions = {
			project_name = "",
			local_path = "",
			remote_path = "",
			host_user_name = "",
			host = "",
		}

		for key, value in pairs(answersQuestions) do
			print(key .. ":")
			answersQuestions[key] = io.read()
		end

		return answersQuestions
	end,

	writeFile = function(self, answers)
		if self.fileExists(self.FILEPATH) then
			print("Файл существует")
		else
			local config = io.open(self.FILEPATH, "w")
			config:write("[server]\n")
			for key, value in pairs(answers) do
				config:write(key .. "=" .. value .. "\n")
			end
			config:close()
		end
	end,

	fileExists = function(name)
		local f = io.open(name, "r")
		if f ~= nil then
			io.close(f)
			return true
		else
			return false
		end
	end,

	dirExists = function(path)
		-- vim.pretty_print(path)
		print(path)
		local attr = lfs.attributes(path)
		if attr and attr.mode == "directory" then
			return true
		end
		return false
	end,

	createDirectoryIfNotExists = function(directoryPath)
		-- Пытаемся создать директорию
		local success, errorMessage = lfs.mkdir(directoryPath)
		if not success then
			-- Если создание директории не удалось, выбрасываем исключение
			error("Не удалось создать директорию: " .. errorMessage)
		end
		-- Директория успешно создана
		return true
	end,
}
-- Вызов функции с путем к директории
-- self.createDirectoryIfNotExists(".nvim_config")
-- local instanceM = M
-- instanceM:init()
return M
