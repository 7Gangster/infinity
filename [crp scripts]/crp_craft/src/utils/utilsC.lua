local img = {}

function manageSVG ( start )
    if start then 
        img = {
            line = svgCreate(234, 2, [[<svg width="234" height="2" viewBox="0 0 234 2" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="234" height="2" rx="1" fill="url(#paint0_linear_97_61)"/>
            <defs>
            <linearGradient id="paint0_linear_97_61" x1="117" y1="-0.000193807" x2="256.5" y2="-10.0002" gradientUnits="userSpaceOnUse">
            <stop stop-color="#D9D9D9"/>
            <stop offset="1" stop-color="#D9D9D9" stop-opacity="0"/>
            </linearGradient>
            </defs>
            </svg>
            ]]),
            clock = svgCreate(31, 31, [[
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <mask id="mask0_109_7" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="0" y="0" width="24" height="24">
                <rect width="24" height="24" fill="#D9D9D9"/>
                </mask>
                <g mask="url(#mask0_109_7)">
                <path d="M12.0001 21.9996C10.7501 21.9996 9.57927 21.7621 8.4876 21.2871C7.39593 20.8121 6.44593 20.1704 5.6376 19.3621C4.82926 18.5538 4.1876 17.6038 3.7126 16.5121C3.2376 15.4204 3.0001 14.2496 3.0001 12.9996C3.0001 11.7496 3.2376 10.5788 3.7126 9.48711C4.1876 8.39544 4.82926 7.44544 5.6376 6.63711C6.44593 5.82878 7.39593 5.18711 8.4876 4.71211C9.57927 4.23711 10.7501 3.99961 12.0001 3.99961C13.2501 3.99961 14.4209 4.23711 15.5126 4.71211C16.6043 5.18711 17.5543 5.82878 18.3626 6.63711C19.1709 7.44544 19.8126 8.39544 20.2876 9.48711C20.7626 10.5788 21.0001 11.7496 21.0001 12.9996C21.0001 14.2496 20.7626 15.4204 20.2876 16.5121C19.8126 17.6038 19.1709 18.5538 18.3626 19.3621C17.5543 20.1704 16.6043 20.8121 15.5126 21.2871C14.4209 21.7621 13.2501 21.9996 12.0001 21.9996ZM14.8001 17.1996L16.2001 15.7996L13.0001 12.5996V7.99961H11.0001V13.3996L14.8001 17.1996ZM5.6001 2.34961L7.0001 3.74961L2.7501 7.99961L1.3501 6.59961L5.6001 2.34961ZM18.4001 2.34961L22.6501 6.59961L21.2501 7.99961L17.0001 3.74961L18.4001 2.34961ZM12.0001 19.9996C13.9501 19.9996 15.6043 19.3204 16.9626 17.9621C18.3209 16.6038 19.0001 14.9496 19.0001 12.9996C19.0001 11.0496 18.3209 9.39544 16.9626 8.03711C15.6043 6.67878 13.9501 5.99961 12.0001 5.99961C10.0501 5.99961 8.39593 6.67878 7.0376 8.03711C5.67926 9.39544 5.0001 11.0496 5.0001 12.9996C5.0001 14.9496 5.67926 16.6038 7.0376 17.9621C8.39593 19.3204 10.0501 19.9996 12.0001 19.9996Z" fill="white"/>
                </g>
                </svg>
            ]]),
        }
    else
        for i,v in pairs(img) do
            destroyElement(img[i])
            img[i] = nil 
        end
    end
    return img
end

font = {}

function getFont( type, size, unRelative )
    if not font[type] then 
        font[type] = {}
    end
    if not font[type][size] then 
        if not unRelative then 
            font[type][size] = dxCreateFont('src/assets/fonts/'..type..'.ttf', size, false)
        else
            font[type][size] = _dxCreateFont('src/assets/fonts/'..type..'.ttf', size, false)
        end
        return font[type][size]
    else
        return font[type][size]
    end
    return 'default'
end
