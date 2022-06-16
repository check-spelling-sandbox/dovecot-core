AC_DEFUN([DOVECOT_WANT_LUA],[
  have_lua=no

  AC_ARG_WITH([lua],
    [AS_HELP_STRING([--with-lua=yes|plugin], [build Lua Bindings])],
    [with_lua=$withval],
    [with_lua=no]
  )

  AS_IF([test "$with_lua" != "no"], [
    for LUAPC in lua5.3 lua-5.3 lua53 lua5.1 lua-5.1 lua51 lua; do
      PKG_CHECK_MODULES([LUA], [$LUAPC >= 5.1 $LUAPC != 5.2], [
        have_lua=yes
        AC_MSG_NOTICE([using library $LUAPC])
        break
      ], [
        :
      ])
    done

    AS_IF([test "$with_lua" = "yes" && test "$have_lua" = "no"], [
      AC_MSG_ERROR([cannot build with Lua support: lua not found])
    ])
  ])

  AS_IF([test "$have_lua" != "no"], [
    AC_DEFINE([HAVE_LUA], [1], [Define to 1 if you have Lua])

    AS_IF([test "$have_lua" = "yes"],
     AC_DEFINE([BUILTIN_LUA],, [Lua support is builtin])
   )

   dnl Check if various lua functions are present
   old_CFLAGS="$CFLAGS"
   CFLAGS="$CFLAGS $LUA_CFLAGS"
   old_LIBS="$LIBS"
   LIBS="$LIBS $LUA_LIBS"

   AC_CHECK_FUNCS([luaL_setfuncs])
   AC_CHECK_FUNCS([luaL_setmetatable])
   AC_CHECK_FUNCS([lua_isinteger])
   AC_CHECK_FUNCS([lua_resume])
   AC_CHECK_FUNCS([lua_seti])
   AC_CHECK_FUNCS([lua_tointegerx])
   AC_CHECK_FUNCS([lua_yieldk])

   AS_IF([test "$ac_cv_func_lua_resume" = "yes" -a \
               "$ac_cv_func_lua_yieldk" = "yes"],
     AC_DEFINE([DLUA_WITH_YIELDS],,
       [Lua scripts will be able to yield])
     dlua_with_yields=yes
   )

   CFLAGS="$old_CFLAGS"
   LIBS="$old_LIBS"
  )
])
