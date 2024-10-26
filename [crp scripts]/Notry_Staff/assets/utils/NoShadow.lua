local texture = dxCreateTexture(1, 1)
local shader = dxCreateShader("assets/assets/shader/shadow.fx")

engineApplyShaderToWorldTexture(shader, "shad_ped")
dxSetShaderValue(shader, "reTexture", texture)