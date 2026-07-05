function PLUGIN:PostInstall(ctx)
    -- Create the destination bin directory
    os.execute("mkdir -p " .. ctx.path .. "/bin")
    -- Copy the scripts from the plugin repository directory to the install path
    os.execute("cp -r bin/* " .. ctx.path .. "/bin/")
    os.execute("chmod +x " .. ctx.path .. "/bin/*")

    local script_path = ctx.path .. "/bin/qemu-dind-setup"
    print("Executing initialization script (this takes a while)...")
    local status = os.execute(script_path)
    if status ~= 0 then
        error("Initialization script failed!")
    end
end
