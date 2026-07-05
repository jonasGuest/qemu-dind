function PLUGIN:PreInstall(ctx)
    os.execute("mkdir -p " .. ctx.path .. "/bin")
    os.execute("cp -r bin/* " .. ctx.path .. "/bin/")
    os.execute("chmod +x " .. ctx.path .. "/bin/*")
    return {
        version = ctx.version
    }
end
