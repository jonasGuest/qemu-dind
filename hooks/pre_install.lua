function PLUGIN:PreInstall(ctx)
    -- Find the plugin's own path (where this hook is running from)
    local info = debug.getinfo(1, 'S')
    local plugin_path = info.source:match("@?(.*)/hooks/pre_install.lua") or "."

    -- Determine the target installation path
    local install_path = ctx.path or ctx.installPath or ctx.install_path or ctx.rootPath

    if install_path then
        -- Ensure target bin/ directory exists
        os.execute("mkdir -p " .. install_path .. "/bin")
        -- Copy files
        os.execute("cp -r " .. plugin_path .. "/bin/* " .. install_path .. "/bin/")
        -- Make them executable
        os.execute("chmod +x " .. install_path .. "/bin/*")
    end

    return {
        version = ctx.version
    }
end
