-- Java-specific settings and configurations

-- Set Java-specific indentation (4 spaces is standard for Java)
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

-- Set textwidth for Java (often 100 or 120 for modern Java projects)
vim.opt_local.textwidth = 120

-- Enable code folding based on syntax
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldenable = false -- Don't fold by default

-- Helper function to detect Maven project
local function is_maven_project()
	local pom_xml = vim.fn.findfile("pom.xml", ".;")
	return pom_xml ~= ""
end

-- Helper function to detect Gradle project
local function is_gradle_project()
	local build_gradle = vim.fn.findfile("build.gradle", ".;")
	local build_gradle_kts = vim.fn.findfile("build.gradle.kts", ".;")
	return build_gradle ~= "" or build_gradle_kts ~= ""
end

-- Helper function to detect Quarkus project
local function is_quarkus_project()
	if not is_maven_project() then
		return false
	end

	-- Check if pom.xml contains quarkus dependencies
	local pom_xml = vim.fn.findfile("pom.xml", ".;")
	if pom_xml == "" then
		return false
	end

	local pom_content = vim.fn.readfile(pom_xml)
	for _, line in ipairs(pom_content) do
		if line:match("quarkus") then
			return true
		end
	end

	return false
end

-- Create user commands for common Maven operations
if is_maven_project() then
	-- Maven compile
	vim.api.nvim_buf_create_user_command(0, "MavenCompile", function()
		vim.cmd("!mvn compile")
	end, { desc = "Compile Maven project" })

	-- Maven clean
	vim.api.nvim_buf_create_user_command(0, "MavenClean", function()
		vim.cmd("!mvn clean")
	end, { desc = "Clean Maven project" })

	-- Maven package
	vim.api.nvim_buf_create_user_command(0, "MavenPackage", function()
		vim.cmd("!mvn package")
	end, { desc = "Package Maven project" })

	-- Maven test
	vim.api.nvim_buf_create_user_command(0, "MavenTest", function()
		vim.cmd("!mvn test")
	end, { desc = "Run Maven tests" })

	-- Maven install
	vim.api.nvim_buf_create_user_command(0, "MavenInstall", function()
		vim.cmd("!mvn install")
	end, { desc = "Install Maven project to local repository" })
end

-- Create Quarkus-specific commands
if is_quarkus_project() then
	-- Quarkus dev mode (hot reload)
	vim.api.nvim_buf_create_user_command(0, "QuarkusDev", function()
		-- Open in a terminal window
		vim.cmd("split | terminal mvn quarkus:dev")
	end, { desc = "Start Quarkus in dev mode (hot reload)" })

	-- Quarkus build
	vim.api.nvim_buf_create_user_command(0, "QuarkusBuild", function()
		vim.cmd("!mvn clean package")
	end, { desc = "Build Quarkus application" })

	-- Quarkus native build
	vim.api.nvim_buf_create_user_command(0, "QuarkusNativeBuild", function()
		vim.cmd("!mvn package -Pnative")
	end, { desc = "Build Quarkus native executable" })

	-- Quarkus add extension
	vim.api.nvim_buf_create_user_command(0, "QuarkusAddExtension", function(opts)
		local extension = opts.args
		if extension == "" then
			vim.notify("Please provide an extension name", vim.log.levels.ERROR)
			return
		end
		vim.cmd("!mvn quarkus:add-extension -Dextensions=" .. extension)
	end, { nargs = 1, desc = "Add Quarkus extension" })

	-- Quarkus list extensions
	vim.api.nvim_buf_create_user_command(0, "QuarkusListExtensions", function()
		vim.cmd("!mvn quarkus:list-extensions")
	end, { desc = "List available Quarkus extensions" })
end

-- Create Gradle commands if it's a Gradle project
if is_gradle_project() then
	vim.api.nvim_buf_create_user_command(0, "GradleBuild", function()
		vim.cmd("!./gradlew build")
	end, { desc = "Build Gradle project" })

	vim.api.nvim_buf_create_user_command(0, "GradleTest", function()
		vim.cmd("!./gradlew test")
	end, { desc = "Run Gradle tests" })

	vim.api.nvim_buf_create_user_command(0, "GradleClean", function()
		vim.cmd("!./gradlew clean")
	end, { desc = "Clean Gradle project" })
end

-- Set up keybindings for quick access to build/test commands
local function set_java_keymaps()
	local opts = { buffer = 0, silent = true }

	if is_quarkus_project() then
		vim.keymap.set("n", "<leader>qd", "<cmd>QuarkusDev<cr>", vim.tbl_extend("force", opts, { desc = "[Quarkus] Start dev mode" }))
		vim.keymap.set("n", "<leader>qb", "<cmd>QuarkusBuild<cr>", vim.tbl_extend("force", opts, { desc = "[Quarkus] Build application" }))
	elseif is_maven_project() then
		vim.keymap.set("n", "<leader>mc", "<cmd>MavenCompile<cr>", vim.tbl_extend("force", opts, { desc = "[Maven] Compile" }))
		vim.keymap.set("n", "<leader>mp", "<cmd>MavenPackage<cr>", vim.tbl_extend("force", opts, { desc = "[Maven] Package" }))
		vim.keymap.set("n", "<leader>mt", "<cmd>MavenTest<cr>", vim.tbl_extend("force", opts, { desc = "[Maven] Test" }))
	elseif is_gradle_project() then
		vim.keymap.set("n", "<leader>gb", "<cmd>GradleBuild<cr>", vim.tbl_extend("force", opts, { desc = "[Gradle] Build" }))
		vim.keymap.set("n", "<leader>gt", "<cmd>GradleTest<cr>", vim.tbl_extend("force", opts, { desc = "[Gradle] Test" }))
	end
end

set_java_keymaps()
