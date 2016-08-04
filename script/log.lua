local M = {}
--    enum Code {
--        FG_RED      = 31,
--        FG_GREEN    = 32,
--        FG_BLUE     = 34,
--        FG_DEFAULT  = 39,
--        BG_RED      = 41,
--        BG_GREEN    = 42,
--        BG_BLUE     = 44,
--        BG_DEFAULT  = 49
--    };
-- 40 + x is background

function M.n(...)
  io.stdout:write("\27[00m")
  print(...)
end

function M.v(...)
  io.stdout:write("\27[34m")
  print(...)
  io.stdout:write("\27[00m")
end

function M.i(...)
  io.stdout:write("\27[32m[I]")
  print(...)
  io.stdout:write("\27[00m")
end

function M.w(...)
  io.stdout:write("\27[40;33m[W]\27[00m\27[33m")
  print(...)
  io.stdout:write("\27[00m")
end

function M.e(...)
  io.stdout:write("\27[40;31m[E]\27[00m\27[31m")
  print(...)
  io.stdout:write("\27[00m")
end

return M