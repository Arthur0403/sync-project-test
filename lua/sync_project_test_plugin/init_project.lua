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
		-- Открываем терминал
		-- Разделить буфер по горизонтали
		vim.api.nvim_command("split")

		-- Открыть терминал в нижней части
		vim.api.nvim_command("term")

		-- Перейти в терминал
		vim.api.nvim_command("wincmd j")

		-- Задаем вопросы и сохраняем ответы в файлы
		local answersQuestions = {
			project_name = "",
			local_path = "",
			remote_path = "",
			host_user_name = "",
			host = "",
		}

		for key, value in pairs(answersQuestions) do
			-- Вводим вопрос в терминал и ожидаем ответ
			vim.api.nvim_command("echo '" .. key .. "'")
			local answer = vim.fn.input()
			answersQuestions[key] = answer
		end

		-- Вернуться в редактор
		vim.api.nvim_command("wincmd k")

		-- Проверяем существование директории и создаем, если необходимо
		if not self:dirExists(self.DIRNAME) then
			self:createDirectoryIfNotExists(self.DIRNAME)
		end

		-- Записываем ответы в файл
		self:writeFile(answersQuestions)

		-- Добавляем папку конфига в.gitignore, если она существует
		if self.fileExists(self.GITIGNORE) then
			self:addGitIgnore(self.GITIGNORE)
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
			answersQuestions[key] = io.read("*line")
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

	dirExists = function(self, path)
		-- "/" работает как на Unix, так и на Windows
		return self.exists(path .. "/")
	end,

	exists = function(file)
		local ok, err, code = os.rename(file, file)
		if not ok then
			if code == 13 then
				-- Ошибка разрешений, но файл существует
				return true
			end
		end
		return ok, err
	end,

	createDirectoryIfNotExists = function(self, directoryPath)
		if not self:dirExists(directoryPath) then
			os.execute("mkdir " .. directoryPath)
		end
	end,
}
-- Вызов функции с путем к директории
-- self.createDirectoryIfNotExists(".nvim_config")
-- local instanceM = M
-- instanceM:init()
return M
