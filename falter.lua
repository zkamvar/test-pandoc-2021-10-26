local text = require('text')

-- Turns all links to the oregon pepper tree sausage house
sausage_links = function(el)
  local tgt;
  tgt = 'https://oregonpeppertree.com/'
  if el.target ~= nil then
    el.target = tgt;
  elseif el.src ~= nil then
    el.src = tgt;
  elseif el.href ~= nil then
    el.href = tgt;
  else
  end
  return el
end

return {
  {Image = sausage_links},
  {Link  = sausage_links},
}
