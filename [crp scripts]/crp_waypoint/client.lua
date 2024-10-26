local screenW, screenH = guiGetScreenSize()

local target = svgCreate(58, 54, [[
    <svg width="58" height="54" viewBox="0 0 58 54" fill="none" xmlns="http://www.w3.org/2000/svg">
    <g filter="url(#filter0_d_30_11)">
    <mask id="mask0_30_11" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="4" y="0" width="50" height="50">
    <rect x="4" width="50" height="50" fill="#D9D9D9"/>
    </mask>
    <g mask="url(#mask0_30_11)">
    <path d="M26.9167 47.8125V43.6458C22.5764 43.1597 18.8524 41.3628 15.7448 38.2552C12.6372 35.1476 10.8403 31.4236 10.3542 27.0833H6.18751V22.9167H10.3542C10.8403 18.5764 12.6372 14.8524 15.7448 11.7448C18.8524 8.63715 22.5764 6.84028 26.9167 6.35417V2.1875H31.0833V6.35417C35.4236 6.84028 39.1476 8.63715 42.2552 11.7448C45.3629 14.8524 47.1597 18.5764 47.6458 22.9167H51.8125V27.0833H47.6458C47.1597 31.4236 45.3629 35.1476 42.2552 38.2552C39.1476 41.3628 35.4236 43.1597 31.0833 43.6458V47.8125H26.9167ZM29 39.5833C33.0278 39.5833 36.4653 38.1597 39.3125 35.3125C42.1597 32.4653 43.5833 29.0278 43.5833 25C43.5833 20.9722 42.1597 17.5347 39.3125 14.6875C36.4653 11.8403 33.0278 10.4167 29 10.4167C24.9722 10.4167 21.5347 11.8403 18.6875 14.6875C15.8403 17.5347 14.4167 20.9722 14.4167 25C14.4167 29.0278 15.8403 32.4653 18.6875 35.3125C21.5347 38.1597 24.9722 39.5833 29 39.5833ZM29 33.3333C26.7083 33.3333 24.7465 32.5174 23.1146 30.8854C21.4826 29.2535 20.6667 27.2917 20.6667 25C20.6667 22.7083 21.4826 20.7465 23.1146 19.1146C24.7465 17.4826 26.7083 16.6667 29 16.6667C31.2917 16.6667 33.2535 17.4826 34.8854 19.1146C36.5174 20.7465 37.3333 22.7083 37.3333 25C37.3333 27.2917 36.5174 29.2535 34.8854 30.8854C33.2535 32.5174 31.2917 33.3333 29 33.3333ZM29 29.1667C30.1458 29.1667 31.1267 28.7587 31.9427 27.9427C32.7587 27.1267 33.1667 26.1458 33.1667 25C33.1667 23.8542 32.7587 22.8733 31.9427 22.0573C31.1267 21.2413 30.1458 20.8333 29 20.8333C27.8542 20.8333 26.8733 21.2413 26.0573 22.0573C25.2413 22.8733 24.8333 23.8542 24.8333 25C24.8333 26.1458 25.2413 27.1267 26.0573 27.9427C26.8733 28.7587 27.8542 29.1667 29 29.1667Z" fill="#92EA74"/>
    </g>
    </g>
    <defs>
    <filter id="filter0_d_30_11" x="0.18751" y="-3.8125" width="57.625" height="57.625" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
    <feFlood flood-opacity="0" result="BackgroundImageFix"/>
    <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
    <feOffset/>
    <feGaussianBlur stdDeviation="3"/>
    <feComposite in2="hardAlpha" operator="out"/>
    <feColorMatrix type="matrix" values="0 0 0 0 0.572549 0 0 0 0 0.917647 0 0 0 0 0.454902 0 0 0 1 0"/>
    <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_30_11"/>
    <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_30_11" result="shape"/>
    </filter>
    </defs>
    </svg>    
]])

local font = {
    dxCreateFont('fonts/regular.ttf', 10, false, 'default')
} 
local isPointing = false
local mX = 0
local mY = 0
local mZ = 0

function renderPointing()
    local pX, pY, pZ = getElementPosition(localPlayer)
    local distance = (getDistanceBetweenPoints3D(pX, pY, pZ, mX, mY, mZ) / 1.5)
    local x, y = getScreenFromWorldPosition(mX, mY, mZ, 1, true)
    local alpha = distance <= 255 and 255 or 255
    local bgColor = tocolor(50, 50, 50, alpha)
    local locColor = tocolor(84, 94, 92, alpha) 
    local textColor = tocolor(255, 255, 255, alpha)
    
    if distance <= 2 then
        removeEventHandler("onClientRender", root, renderPointing)
        isPointing = false
    end
    
    if x and y then

        local x, y = x - 82/2, y - 84/2

        --local textWidth = dxGetTextWidth(text, 1.00, font[1])
        --dxDrawImage(x - 23, y - 38, textWidth + 40, 30, "assets/backgraund.png", 0, 0, 0, bgColor, false)
        ---dxDrawImage(x - 17, y - 33, 20, 20, "assets/back_loc.png", 0, 0, 0, locColor, false)
        --dxDrawImage(x - 13, y - 29, 13, 13, "assets/location.png", 0, 0, 0, textColor, false)
        --dxDrawText("" .. string.format("%d", distance) .. "m", x + 7, y - 17, _, _, locColor, 1.00, font[1], "left", "center", false, false, false, true)
        --dxDrawText(text, x + 7, y - 28, _, _, textColor, 1.00, font[1], "left", "center", false, false, false, true)
    
        dxDrawImage(x+16-8+12, y-4+20, 38, 34, "assets/location.png", 0,0,0, tocolor(255, 255, 255, alpha))
        dxDrawText(text, x+1, y+51, 82+x+1, 19+y+51, tocolor(0, 0, 0, alpha), 1, font[1], 'center', 'top')
        dxDrawText(text, x, y+50, 82+x, 19+y+50, tocolor(255, 255, 255, alpha), 1, font[1], 'center', 'top')
        dxDrawText("" .. string.format("%d", distance) .. "m", x+1, y+68, 82+x+1, 19+y+68, tocolor(0, 0, 0, alpha), 1, font[1], 'center', 'top')
        dxDrawText("" .. string.format("%d", distance) .. "m", x, y+67, 82+x, 19+y+67, tocolor(255, 255, 255, alpha), 1, font[1], 'center', 'top')
        

    end
end

function togglePointing(posX, posY, posZ, desc)
    if (posX) and (posY) and (posZ) then
        if isPointing then
            removeEventHandler("onClientRender", root, renderPointing)
            isPointing = false
            mX = 0
            mY = 0
            mZ = 0
        end
        if desc ~= nil then
            text = desc
        else
            text = 'Local.'
        end
        addEventHandler("onClientRender", root, renderPointing)
        mX = tonumber(posX)
        mY = tonumber(posY)
        mZ = tonumber(posZ)
        text = text
        isPointing = true
    end
end
addEvent("togglePoint", true)
addEventHandler("togglePoint", root, togglePointing)

function togglePointingF()
    removeEventHandler("onClientRender", root, renderPointing)
    isPointing = false
end
addEvent("togglePointF", true)
addEventHandler("togglePointF", root, togglePointingF)