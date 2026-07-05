function PLUGIN:PostInstall(ctx)
    local script_path = ctx.path .. "/bin/qemu-dind-setup"
    
    -- Fallback: if bin/qemu-dind-setup doesn't exist, try to copy it now
    local check_file = io.open(script_path, "r")
    if not check_file then
        local info = debug.getinfo(1, 'S')
        local plugin_path = info.source:match("@?(.*)/hooks/post_install.lua") or "."
        os.execute("mkdir -p " .. ctx.path .. "/bin")
        os.execute("cp -r " .. plugin_path .. "/bin/* " .. ctx.path .. "/bin/")
        os.execute("chmod +x " .. ctx.path .. "/bin/*")
    else
        check_file:close()
    end

    print("Executing initialization script (this takes a while)...")
    local status = os.execute(script_path)
    if status ~= 0 then
        error("Initialization script failed!")
    end
end
