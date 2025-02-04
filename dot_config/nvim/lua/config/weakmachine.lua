return (os.getenv("WEAK_MACHINE") == nil) and (os.execute("test -f $HOME/.weak_machine") ~= 0)
