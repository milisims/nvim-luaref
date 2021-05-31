This 'plugin' simply adds a reference for builtin lua functions, extracting both text and formatting from [the Lua 5.1 Reference Manual](https://www.lua.org/manual/5.1/manual.html). There are still formatting issues (particularly around equals), please search through and then submit an issue if you find one that is unreported!

Text referring to implementing lua into a host C program has largely been removed.

For example,
``` vim
    :help lua_reference_toc
    :help math.pi
    :help coroutine.yield
```

Script generated documentation for lua 5.1 in languages: `en`, `de`, `es`, and `pt`.
