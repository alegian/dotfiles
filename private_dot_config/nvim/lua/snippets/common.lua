local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local function copy(args)
  return args[1]
end
local function filename(_, snip)
  return snip.env.TM_FILENAME_BASE
end

ls.add_snippets("typescriptreact", {
  -- react component with file name
  s(
    "comp",
    fmta(
      [[
export default function <>() {
  return <>;
}
]],
      {
        f(filename),
        i(1, "null"),
      }
    )
  ),
  -- react state
  s("state", {
    t("const ["),
    i(1, "state"),
    t(", "),
    f(function(args)
      local name = args[1][1]
      return "set" .. name:gsub("^%l", string.upper)
    end, { 1 }),
    t("] = useState("),
    i(2),
    t(");"),
  }),
})
