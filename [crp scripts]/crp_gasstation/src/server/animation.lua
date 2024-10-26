

addEvent('class:setAnim', true)
addEventHandler('class:setAnim', root, function(player, anim, anim2)
    if anim and anim2 then
        setPedAnimation(player, anim, anim2, -1, true, false, false)
    else
        setPedAnimation(player)
    end
end)