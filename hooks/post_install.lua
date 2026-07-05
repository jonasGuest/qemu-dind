function PLUGIN:PostInstall(ctx)
    local script_path = ctx.path .. "/bin/qemu-dind-setup"
    print("Executing initialization script (this takes a while)...")
    local status = os.execute(script_path)
    if status ~= 0 then
        error("Initialization script failed!")
    end
end
