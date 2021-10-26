local text = require('text')

-- Turns all links to the oregon pepper tree sausage house
sausage_links = function(el)
  local tgt;
  tgt = 'https://oregonpeppertree.com/'
  if el.target == nil then
    el.src = tgt;
  else
    el.target = tgt;
  end
  return el
end

return {
  {Link  = sausage_links},
}
