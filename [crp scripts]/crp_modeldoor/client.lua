
setCameraMatrix( 1000000, 1000000, 1000000 )
setElementFrozen(localPlayer, true)


setOcclusionsEnabled( false )

setTimer(
  function()
   setCameraTarget(localPlayer)
    setElementFrozen(localPlayer, false)
      end, 1000, 1)
	  
	  
removeWorldModel(4215, 100000, 0, 0, 0)



