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
local function filename()
  return vim.fn.expand("%:t:r")
end

local function textSnippet()
  return fmt("<T t='{}' />", { i(1) })
end

ls.add_snippets("typescriptreact", {
  -- i18n text
  s("txt", textSnippet()),
  -- icon
  s("ico", fmt("<UIcon className='size-{}' />", { i(1) })),
  -- image
  s("img", fmt("<UImage fill src={{{}}} />", { i(1) })),
  -- button
  s(
    "btn",
    fmt(
      [[
<StyledButton size='{}' variant='{}'>
  {}
</StyledButton>
]],
      {
        i(1),
        i(2),
        d(3, function(_, snip)
          return sn(nil, textSnippet())
        end),
      }
    )
  ),
})
