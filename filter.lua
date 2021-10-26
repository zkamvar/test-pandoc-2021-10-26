local text = require('text')

-- Flatten relative links for HTML output
--
-- 1. removes any leading ../[folder]/ from the links to prepare them for the
--    way the resources appear in the HTML site
-- 2. renames all local Rmd and md files to .html 
--
-- NOTE: it _IS_ possible to use variable expansion with this so that we can
--       configure this to do specific things (e.g. decide how we want the
--       architecture of the final site to be)
-- function expand (s)
--   s = s:gsub("$(%w+)", function(n)
--      return _G[n] -- substitute with global variable
--   end)
--   return s
-- end
flatten_links = function(el)
  local pat = "^%.%./"
  local tgt;
  if el.target == nil then
    tgt = el.src
  else
    tgt = el.target
  end
  -- Flatten local redirects, e.ge. ../episodes/link.md goes to link.md
  tgt,_ = tgt:gsub(pat.."episodes/", "")
  tgt,_ = tgt:gsub(pat.."learners/", "")
  tgt,_ = tgt:gsub(pat.."instructors/", "")
  tgt,_ = tgt:gsub(pat.."profiles/", "")
  tgt,_ = tgt:gsub(pat, "")
  -- rename local markdown/Rmarkdown
  -- link.md goes to link.html
  -- link.md#section1 goes to link.html#section1
  local proto = text.sub(tgt, 1, 4)
  if proto ~= "http" and proto ~= "ftp:" then
    tgt,_ = tgt:gsub("%.R?md(#[%S]+)$", ".html%1")
    tgt,_ = tgt:gsub("%.R?md$", ".html")
  end
  if el.target == nil then
    el.src = tgt;
  else
    el.target = tgt;
  end
  return el
end

return {
  {Link  = flatten_links},
  {Image = flatten_links},
}
