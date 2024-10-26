local screenW, screenH = guiGetScreenSize()

local backWidth, backHeight = 300, 60
local backX, backY = (screenW / 2 - backWidth / 2) + 200, (screenH / 2 - backHeight / 2) - 100
local quantityWidth, quantityHeight = 350, 150
local quantityX, quantityY = (screenW / 2 - quantityWidth / 2), (screenH / 2 - quantityHeight / 2)
local utils = {
    fonts = {
        p_regular12 = dxCreateFont("src/client/assets/fonts/p_regular.ttf", 12),
        p_regular11 = dxCreateFont("src/client/assets/fonts/p_regular.ttf", 11),
        p_regular10 = dxCreateFont("src/client/assets/fonts/p_regular.ttf", 10),
        p_regular9 = dxCreateFont("src/client/assets/fonts/p_regular.ttf", 9.5),
    }
}

local panelState = "init"
local showing = false
local alpha = {}
local tick

local quantity = 0
local can_quantity = 0
local price = 12
local the_gas = {}
local p_fueling = {}
local anim_time = 500


local svgs = {
    quantity = [[
        <svg width="350" height="150" viewBox="0 0 350 150" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="350" height="150" rx="5" fill="#FFFFFF" fill-opacity="0.9"/>
        </svg>
    ]],
    button = [[
        <svg width="140" height="40" viewBox="0 0 140 40" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="140" height="40" rx="5" fill="#92EA74"/>
            <path d="M20.4941 15.5767L17.4346 24H16.1841L19.707 14.7578H20.5132L20.4941 15.5767ZM23.0586 24L19.9927 15.5767L19.9736 14.7578H20.7798L24.3154 24H23.0586ZM22.8999 20.5786V21.5815H17.7075V20.5786H22.8999ZM25.3691 14.25H26.5498V22.667L26.4482 24H25.3691V14.25ZM31.1899 20.5088V20.6421C31.1899 21.1414 31.1307 21.6048 31.0122 22.0322C30.8937 22.4554 30.7202 22.8236 30.4917 23.1367C30.2632 23.4499 29.9839 23.6932 29.6538 23.8667C29.3237 24.0402 28.945 24.127 28.5176 24.127C28.0817 24.127 27.6987 24.0529 27.3687 23.9048C27.0428 23.7524 26.7677 23.5345 26.5435 23.251C26.3192 22.9674 26.1393 22.6247 26.0039 22.2227C25.8727 21.8206 25.7817 21.3678 25.731 20.8643V20.2803C25.7817 19.7725 25.8727 19.3175 26.0039 18.9155C26.1393 18.5135 26.3192 18.1707 26.5435 17.8872C26.7677 17.5994 27.0428 17.3815 27.3687 17.2334C27.6945 17.0811 28.0732 17.0049 28.5049 17.0049C28.9365 17.0049 29.3195 17.0895 29.6538 17.2588C29.9881 17.4238 30.2674 17.6608 30.4917 17.9697C30.7202 18.2786 30.8937 18.6489 31.0122 19.0806C31.1307 19.508 31.1899 19.984 31.1899 20.5088ZM30.0093 20.6421V20.5088C30.0093 20.166 29.9775 19.8444 29.9141 19.5439C29.8506 19.2393 29.749 18.9727 29.6094 18.7441C29.4697 18.5114 29.2856 18.3294 29.0571 18.1982C28.8286 18.0628 28.5472 17.9951 28.2129 17.9951C27.9167 17.9951 27.6585 18.0459 27.4385 18.1475C27.2227 18.249 27.0386 18.3866 26.8862 18.5601C26.7339 18.7293 26.609 18.924 26.5117 19.144C26.4186 19.3599 26.3488 19.5841 26.3022 19.8169V21.3467C26.37 21.6429 26.48 21.9285 26.6323 22.2036C26.7889 22.4744 26.9963 22.6966 27.2544 22.8701C27.5168 23.0436 27.8405 23.1304 28.2256 23.1304C28.543 23.1304 28.8138 23.0669 29.0381 22.9399C29.2666 22.8088 29.4507 22.6289 29.5903 22.4004C29.7342 22.1719 29.84 21.9074 29.9077 21.6069C29.9754 21.3065 30.0093 20.9849 30.0093 20.6421ZM36.7251 22.8257V19.29C36.7251 19.0192 36.6701 18.7843 36.5601 18.5854C36.4543 18.3823 36.2935 18.2257 36.0776 18.1157C35.8618 18.0057 35.5952 17.9507 35.2778 17.9507C34.9816 17.9507 34.7214 18.0015 34.4971 18.103C34.277 18.2046 34.1035 18.3379 33.9766 18.5029C33.8538 18.668 33.7925 18.8457 33.7925 19.0361H32.6182C32.6182 18.7907 32.6816 18.5474 32.8086 18.3062C32.9355 18.0649 33.1175 17.847 33.3545 17.6523C33.5957 17.4535 33.8835 17.2969 34.2178 17.1826C34.5563 17.0641 34.9329 17.0049 35.3477 17.0049C35.847 17.0049 36.2871 17.0895 36.668 17.2588C37.0531 17.4281 37.3535 17.6841 37.5693 18.0269C37.7894 18.3654 37.8994 18.7907 37.8994 19.3027V22.502C37.8994 22.7305 37.9185 22.9738 37.9565 23.2319C37.9989 23.4901 38.0602 23.7122 38.1406 23.8984V24H36.9155C36.8563 23.8646 36.8097 23.6847 36.7759 23.4604C36.742 23.2319 36.7251 23.0203 36.7251 22.8257ZM36.9282 19.8359L36.9409 20.6611H35.7539C35.4196 20.6611 35.1213 20.6886 34.8589 20.7437C34.5965 20.7944 34.3765 20.8727 34.1987 20.9785C34.021 21.0843 33.8856 21.2176 33.7925 21.3784C33.6994 21.535 33.6528 21.7191 33.6528 21.9307C33.6528 22.1465 33.7015 22.3433 33.7988 22.521C33.8962 22.6987 34.0422 22.8405 34.2368 22.9463C34.4357 23.0479 34.679 23.0986 34.9668 23.0986C35.3265 23.0986 35.6439 23.0225 35.9189 22.8701C36.194 22.7178 36.4119 22.5316 36.5728 22.3115C36.7378 22.0915 36.8267 21.8778 36.8394 21.6704L37.3408 22.2354C37.3112 22.4131 37.2308 22.6099 37.0996 22.8257C36.9684 23.0415 36.7928 23.2489 36.5728 23.4478C36.3569 23.6424 36.0988 23.8053 35.7983 23.9365C35.5021 24.0635 35.1678 24.127 34.7954 24.127C34.3299 24.127 33.9215 24.036 33.5703 23.854C33.2233 23.672 32.9525 23.4287 32.7578 23.124C32.5674 22.8151 32.4722 22.4702 32.4722 22.0894C32.4722 21.7212 32.5441 21.3975 32.688 21.1182C32.8319 20.8346 33.0392 20.5998 33.3101 20.4136C33.5809 20.2231 33.9067 20.0793 34.2876 19.9819C34.6685 19.8846 35.0938 19.8359 35.5635 19.8359H36.9282ZM43.7456 22.1782C43.7456 22.009 43.7075 21.8524 43.6313 21.7085C43.5594 21.5604 43.4092 21.4271 43.1807 21.3086C42.9564 21.1859 42.6178 21.0801 42.165 20.9912C41.7842 20.9108 41.4393 20.8156 41.1304 20.7056C40.8257 20.5955 40.5654 20.4622 40.3496 20.3057C40.138 20.1491 39.9751 19.965 39.8608 19.7534C39.7466 19.5418 39.6895 19.2943 39.6895 19.0107C39.6895 18.7399 39.7487 18.4839 39.8672 18.2427C39.9899 18.0015 40.1613 17.7878 40.3813 17.6016C40.6056 17.4154 40.8743 17.2694 41.1875 17.1636C41.5007 17.0578 41.8498 17.0049 42.2349 17.0049C42.785 17.0049 43.2547 17.1022 43.644 17.2969C44.0334 17.4915 44.3317 17.7518 44.5391 18.0776C44.7464 18.3993 44.8501 18.7568 44.8501 19.1504H43.6758C43.6758 18.96 43.6187 18.7759 43.5044 18.5981C43.3944 18.4162 43.2314 18.266 43.0156 18.1475C42.804 18.029 42.5438 17.9697 42.2349 17.9697C41.909 17.9697 41.6445 18.0205 41.4414 18.1221C41.2425 18.2194 41.0965 18.3442 41.0034 18.4966C40.9146 18.6489 40.8701 18.8097 40.8701 18.979C40.8701 19.106 40.8913 19.2202 40.9336 19.3218C40.9801 19.4191 41.0605 19.5101 41.1748 19.5947C41.2891 19.6751 41.4499 19.7513 41.6572 19.8232C41.8646 19.8952 42.1291 19.9671 42.4507 20.0391C43.0135 20.166 43.4769 20.3184 43.8408 20.4961C44.2048 20.6738 44.4756 20.8918 44.6533 21.1499C44.8311 21.408 44.9199 21.7212 44.9199 22.0894C44.9199 22.3898 44.8564 22.6649 44.7295 22.9146C44.6068 23.1642 44.4269 23.38 44.1899 23.562C43.9572 23.7397 43.6779 23.8794 43.3521 23.981C43.0304 24.0783 42.6686 24.127 42.2666 24.127C41.6615 24.127 41.1494 24.019 40.7305 23.8032C40.3115 23.5874 39.9941 23.3081 39.7783 22.9653C39.5625 22.6226 39.4546 22.2607 39.4546 21.8799H40.6353C40.6522 22.2015 40.7453 22.4575 40.9146 22.6479C41.0838 22.8341 41.2912 22.9674 41.5366 23.0479C41.7821 23.124 42.0254 23.1621 42.2666 23.1621C42.5882 23.1621 42.8569 23.1198 43.0728 23.0352C43.2928 22.9505 43.46 22.8341 43.5742 22.686C43.6885 22.5379 43.7456 22.3687 43.7456 22.1782ZM49.3379 17.1318V18.0332H45.6245V17.1318H49.3379ZM46.8813 15.4624H48.0557V22.2988C48.0557 22.5316 48.0916 22.7072 48.1636 22.8257C48.2355 22.9442 48.3286 23.0225 48.4429 23.0605C48.5571 23.0986 48.6799 23.1177 48.811 23.1177C48.9084 23.1177 49.0099 23.1092 49.1157 23.0923C49.2257 23.0711 49.3083 23.0542 49.3633 23.0415L49.3696 24C49.2765 24.0296 49.1538 24.0571 49.0015 24.0825C48.8534 24.1121 48.6735 24.127 48.4619 24.127C48.1742 24.127 47.9097 24.0698 47.6685 23.9556C47.4272 23.8413 47.2347 23.6509 47.0908 23.3843C46.9512 23.1134 46.8813 22.7495 46.8813 22.2925V15.4624ZM53.5654 24.127C53.0872 24.127 52.6535 24.0465 52.2642 23.8857C51.8791 23.7207 51.5469 23.4901 51.2676 23.1938C50.9925 22.8976 50.7809 22.5464 50.6328 22.1401C50.4847 21.7339 50.4106 21.2896 50.4106 20.8071V20.5405C50.4106 19.9819 50.4932 19.4847 50.6582 19.0488C50.8232 18.6087 51.0475 18.2363 51.3311 17.9316C51.6146 17.627 51.9362 17.3963 52.2959 17.2397C52.6556 17.0832 53.028 17.0049 53.4131 17.0049C53.904 17.0049 54.3271 17.0895 54.6826 17.2588C55.0423 17.4281 55.3364 17.665 55.5649 17.9697C55.7935 18.2702 55.9627 18.6257 56.0728 19.0361C56.1828 19.4424 56.2378 19.8867 56.2378 20.3691V20.896H51.1089V19.9375H55.0635V19.8486C55.0465 19.5439 54.9831 19.2477 54.873 18.96C54.7673 18.6722 54.598 18.4352 54.3652 18.249C54.1325 18.0628 53.8151 17.9697 53.4131 17.9697C53.1465 17.9697 52.901 18.0269 52.6768 18.1411C52.4525 18.2511 52.2599 18.4162 52.0991 18.6362C51.9383 18.8563 51.8135 19.125 51.7246 19.4424C51.6357 19.7598 51.5913 20.1258 51.5913 20.5405V20.8071C51.5913 21.133 51.6357 21.4398 51.7246 21.7275C51.8177 22.0111 51.951 22.2607 52.1245 22.4766C52.3022 22.6924 52.516 22.8617 52.7656 22.9844C53.0195 23.1071 53.3073 23.1685 53.6289 23.1685C54.0436 23.1685 54.3949 23.0838 54.6826 22.9146C54.9704 22.7453 55.2222 22.5189 55.438 22.2354L56.1489 22.8003C56.0008 23.0246 55.8125 23.2383 55.584 23.4414C55.3555 23.6445 55.0741 23.8096 54.7397 23.9365C54.4097 24.0635 54.0182 24.127 53.5654 24.127ZM60.3574 23.1621C60.6367 23.1621 60.8949 23.105 61.1318 22.9907C61.3688 22.8765 61.5635 22.7199 61.7158 22.521C61.8682 22.3179 61.9549 22.0872 61.9761 21.8291H63.0933C63.0721 22.2354 62.9346 22.6141 62.6807 22.9653C62.431 23.3123 62.103 23.5938 61.6968 23.8096C61.2905 24.0212 60.8441 24.127 60.3574 24.127C59.8411 24.127 59.3905 24.036 59.0054 23.854C58.6245 23.672 58.3071 23.4224 58.0532 23.105C57.8035 22.7876 57.6152 22.4237 57.4883 22.0132C57.3656 21.5985 57.3042 21.1605 57.3042 20.6992V20.4326C57.3042 19.9714 57.3656 19.5355 57.4883 19.125C57.6152 18.7103 57.8035 18.3442 58.0532 18.0269C58.3071 17.7095 58.6245 17.4598 59.0054 17.2778C59.3905 17.0959 59.8411 17.0049 60.3574 17.0049C60.8949 17.0049 61.3646 17.1149 61.7666 17.335C62.1686 17.5508 62.4839 17.847 62.7124 18.2236C62.9451 18.596 63.0721 19.0192 63.0933 19.4932H61.9761C61.9549 19.2096 61.8745 18.9536 61.7349 18.7251C61.5994 18.4966 61.4132 18.3146 61.1763 18.1792C60.9435 18.0396 60.6706 17.9697 60.3574 17.9697C59.9977 17.9697 59.6951 18.0417 59.4497 18.1855C59.2085 18.3252 59.016 18.5156 58.8721 18.7568C58.7324 18.9938 58.6309 19.2583 58.5674 19.5503C58.5081 19.8381 58.4785 20.1322 58.4785 20.4326V20.6992C58.4785 20.9997 58.5081 21.2959 58.5674 21.5879C58.6266 21.8799 58.7261 22.1444 58.8657 22.3813C59.0096 22.6183 59.2021 22.8088 59.4434 22.9526C59.6888 23.0923 59.9935 23.1621 60.3574 23.1621ZM67.2637 24.127C66.7855 24.127 66.3517 24.0465 65.9624 23.8857C65.5773 23.7207 65.2451 23.4901 64.9658 23.1938C64.6908 22.8976 64.4792 22.5464 64.3311 22.1401C64.1829 21.7339 64.1089 21.2896 64.1089 20.8071V20.5405C64.1089 19.9819 64.1914 19.4847 64.3564 19.0488C64.5215 18.6087 64.7458 18.2363 65.0293 17.9316C65.3128 17.627 65.6344 17.3963 65.9941 17.2397C66.3538 17.0832 66.7262 17.0049 67.1113 17.0049C67.6022 17.0049 68.0254 17.0895 68.3809 17.2588C68.7406 17.4281 69.0347 17.665 69.2632 17.9697C69.4917 18.2702 69.661 18.6257 69.771 19.0361C69.881 19.4424 69.936 19.8867 69.936 20.3691V20.896H64.8071V19.9375H68.7617V19.8486C68.7448 19.5439 68.6813 19.2477 68.5713 18.96C68.4655 18.6722 68.2962 18.4352 68.0635 18.249C67.8307 18.0628 67.5133 17.9697 67.1113 17.9697C66.8447 17.9697 66.5993 18.0269 66.375 18.1411C66.1507 18.2511 65.9582 18.4162 65.7974 18.6362C65.6366 18.8563 65.5117 19.125 65.4229 19.4424C65.334 19.7598 65.2896 20.1258 65.2896 20.5405V20.8071C65.2896 21.133 65.334 21.4398 65.4229 21.7275C65.516 22.0111 65.6493 22.2607 65.8228 22.4766C66.0005 22.6924 66.2142 22.8617 66.4639 22.9844C66.7178 23.1071 67.0055 23.1685 67.3271 23.1685C67.7419 23.1685 68.0931 23.0838 68.3809 22.9146C68.6686 22.7453 68.9204 22.5189 69.1362 22.2354L69.8472 22.8003C69.6991 23.0246 69.5107 23.2383 69.2822 23.4414C69.0537 23.6445 68.7723 23.8096 68.438 23.9365C68.1079 24.0635 67.7165 24.127 67.2637 24.127ZM72.4814 18.2109V24H71.3071V17.1318H72.4497L72.4814 18.2109ZM74.627 17.0938L74.6206 18.1855C74.5233 18.1644 74.4302 18.1517 74.3413 18.1475C74.2567 18.139 74.1593 18.1348 74.0493 18.1348C73.7785 18.1348 73.5394 18.1771 73.332 18.2617C73.1247 18.3464 72.9491 18.4648 72.8052 18.6172C72.6613 18.7695 72.547 18.9515 72.4624 19.1631C72.382 19.3704 72.3291 19.599 72.3037 19.8486L71.9736 20.0391C71.9736 19.6243 72.0138 19.235 72.0942 18.8711C72.1789 18.5072 72.3079 18.1855 72.4814 17.9062C72.6549 17.6227 72.875 17.4027 73.1416 17.2461C73.4124 17.0853 73.734 17.0049 74.1064 17.0049C74.1911 17.0049 74.2884 17.0155 74.3984 17.0366C74.5085 17.0535 74.5846 17.0726 74.627 17.0938ZM82.0981 22.5972L84.8213 14.7578H86.1479L82.7266 24H81.7808L82.0981 22.5972ZM79.5527 14.7578L82.2505 22.5972L82.5869 24H81.6411L78.2261 14.7578H79.5527ZM89.7852 24.127C89.307 24.127 88.8732 24.0465 88.4839 23.8857C88.0988 23.7207 87.7666 23.4901 87.4873 23.1938C87.2122 22.8976 87.0007 22.5464 86.8525 22.1401C86.7044 21.7339 86.6304 21.2896 86.6304 20.8071V20.5405C86.6304 19.9819 86.7129 19.4847 86.8779 19.0488C87.043 18.6087 87.2673 18.2363 87.5508 17.9316C87.8343 17.627 88.1559 17.3963 88.5156 17.2397C88.8753 17.0832 89.2477 17.0049 89.6328 17.0049C90.1237 17.0049 90.5469 17.0895 90.9023 17.2588C91.262 17.4281 91.5562 17.665 91.7847 17.9697C92.0132 18.2702 92.1825 18.6257 92.2925 19.0361C92.4025 19.4424 92.4575 19.8867 92.4575 20.3691V20.896H87.3286V19.9375H91.2832V19.8486C91.2663 19.5439 91.2028 19.2477 91.0928 18.96C90.987 18.6722 90.8177 18.4352 90.585 18.249C90.3522 18.0628 90.0348 17.9697 89.6328 17.9697C89.3662 17.9697 89.1208 18.0269 88.8965 18.1411C88.6722 18.2511 88.4797 18.4162 88.3188 18.6362C88.158 18.8563 88.0332 19.125 87.9443 19.4424C87.8555 19.7598 87.811 20.1258 87.811 20.5405V20.8071C87.811 21.133 87.8555 21.4398 87.9443 21.7275C88.0374 22.0111 88.1707 22.2607 88.3442 22.4766C88.522 22.6924 88.7357 22.8617 88.9854 22.9844C89.2393 23.1071 89.527 23.1685 89.8486 23.1685C90.2633 23.1685 90.6146 23.0838 90.9023 22.9146C91.1901 22.7453 91.4419 22.5189 91.6577 22.2354L92.3687 22.8003C92.2205 23.0246 92.0322 23.2383 91.8037 23.4414C91.5752 23.6445 91.2938 23.8096 90.9595 23.9365C90.6294 24.0635 90.238 24.127 89.7852 24.127ZM95.0981 17.1318V24H93.9238V17.1318H95.0981ZM93.8857 16.1289L95.1172 14.2627H96.5327L94.8315 16.1289H93.8857ZM99.8018 23.1621C100.081 23.1621 100.339 23.105 100.576 22.9907C100.813 22.8765 101.008 22.7199 101.16 22.521C101.312 22.3179 101.399 22.0872 101.42 21.8291H102.538C102.516 22.2354 102.379 22.6141 102.125 22.9653C101.875 23.3123 101.547 23.5938 101.141 23.8096C100.735 24.0212 100.288 24.127 99.8018 24.127C99.2855 24.127 98.8348 24.036 98.4497 23.854C98.0688 23.672 97.7515 23.4224 97.4976 23.105C97.2479 22.7876 97.0596 22.4237 96.9326 22.0132C96.8099 21.5985 96.7485 21.1605 96.7485 20.6992V20.4326C96.7485 19.9714 96.8099 19.5355 96.9326 19.125C97.0596 18.7103 97.2479 18.3442 97.4976 18.0269C97.7515 17.7095 98.0688 17.4598 98.4497 17.2778C98.8348 17.0959 99.2855 17.0049 99.8018 17.0049C100.339 17.0049 100.809 17.1149 101.211 17.335C101.613 17.5508 101.928 17.847 102.157 18.2236C102.389 18.596 102.516 19.0192 102.538 19.4932H101.42C101.399 19.2096 101.319 18.9536 101.179 18.7251C101.044 18.4966 100.858 18.3146 100.621 18.1792C100.388 18.0396 100.115 17.9697 99.8018 17.9697C99.4421 17.9697 99.1395 18.0417 98.894 18.1855C98.6528 18.3252 98.4603 18.5156 98.3164 18.7568C98.1768 18.9938 98.0752 19.2583 98.0117 19.5503C97.9525 19.8381 97.9229 20.1322 97.9229 20.4326V20.6992C97.9229 20.9997 97.9525 21.2959 98.0117 21.5879C98.071 21.8799 98.1704 22.1444 98.3101 22.3813C98.4539 22.6183 98.6465 22.8088 98.8877 22.9526C99.1331 23.0923 99.4378 23.1621 99.8018 23.1621ZM108.06 22.4131V17.1318H109.241V24H108.117L108.06 22.4131ZM108.282 20.9658L108.771 20.9531C108.771 21.4102 108.722 21.8333 108.625 22.2227C108.532 22.6077 108.38 22.9421 108.168 23.2256C107.956 23.5091 107.679 23.7313 107.336 23.8921C106.994 24.0487 106.577 24.127 106.086 24.127C105.752 24.127 105.445 24.0783 105.166 23.981C104.89 23.8836 104.653 23.7334 104.455 23.5303C104.256 23.3271 104.101 23.0627 103.991 22.7368C103.885 22.411 103.833 22.0195 103.833 21.5625V17.1318H105.007V21.5752C105.007 21.8841 105.041 22.1401 105.108 22.3433C105.18 22.5422 105.276 22.7008 105.394 22.8193C105.517 22.9336 105.652 23.014 105.8 23.0605C105.953 23.1071 106.109 23.1304 106.27 23.1304C106.769 23.1304 107.165 23.0352 107.457 22.8447C107.749 22.6501 107.958 22.3898 108.085 22.064C108.217 21.7339 108.282 21.3678 108.282 20.9658ZM112.307 14.25V24H111.126V14.25H112.307ZM113.881 20.6421V20.4961C113.881 20.001 113.953 19.5418 114.097 19.1187C114.241 18.6912 114.448 18.321 114.719 18.0078C114.99 17.6904 115.318 17.445 115.703 17.2715C116.088 17.0938 116.519 17.0049 116.998 17.0049C117.48 17.0049 117.914 17.0938 118.299 17.2715C118.688 17.445 119.018 17.6904 119.289 18.0078C119.564 18.321 119.774 18.6912 119.917 19.1187C120.061 19.5418 120.133 20.001 120.133 20.4961V20.6421C120.133 21.1372 120.061 21.5964 119.917 22.0195C119.774 22.4427 119.564 22.813 119.289 23.1304C119.018 23.4435 118.69 23.689 118.305 23.8667C117.924 24.0402 117.493 24.127 117.01 24.127C116.528 24.127 116.094 24.0402 115.709 23.8667C115.324 23.689 114.994 23.4435 114.719 23.1304C114.448 22.813 114.241 22.4427 114.097 22.0195C113.953 21.5964 113.881 21.1372 113.881 20.6421ZM115.055 20.4961V20.6421C115.055 20.9849 115.095 21.3086 115.176 21.6133C115.256 21.9137 115.377 22.1803 115.538 22.4131C115.703 22.6458 115.908 22.8299 116.153 22.9653C116.399 23.0965 116.684 23.1621 117.01 23.1621C117.332 23.1621 117.613 23.0965 117.854 22.9653C118.1 22.8299 118.303 22.6458 118.464 22.4131C118.625 22.1803 118.745 21.9137 118.826 21.6133C118.91 21.3086 118.953 20.9849 118.953 20.6421V20.4961C118.953 20.1576 118.91 19.8381 118.826 19.5376C118.745 19.2329 118.623 18.9642 118.458 18.7314C118.297 18.4945 118.094 18.3083 117.848 18.1729C117.607 18.0374 117.323 17.9697 116.998 17.9697C116.676 17.9697 116.392 18.0374 116.147 18.1729C115.906 18.3083 115.703 18.4945 115.538 18.7314C115.377 18.9642 115.256 19.2329 115.176 19.5376C115.095 19.8381 115.055 20.1576 115.055 20.4961Z" fill="#1F150D"/>
        </svg>
    ]],
    theBackground = [[
        <svg width="300" height="60" viewBox="0 0 300 60" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="300" height="60" rx="5" fill="#FFFFFF"/>
        </svg>
    ]],
    backgroundSelect = [[
        <svg width="300" height="40" viewBox="0 0 300 40" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="300" height="40" rx="5" fill="#FFFFFF"/>
        </svg>
    ]]
}

local renderSvgs = {
    quantityBg = svgCreate(350, 150, svgs.quantity),
    button = svgCreate(150, 40, svgs.button),
    backgroundImage = svgCreate(300, 60, svgs.theBackground),
    backgroundSelect = svgCreate(300, 40, svgs.backgroundSelect)
}

function msg(player, msg, type, time)
    return exports.crp_notify:addBox(msg, type, time)
end

local function render()
    local Fonts = utils.fonts
    if panelState == "init" then
        progress = (getTickCount() - tick) / anim_time
        alpha[1] = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, progress, "Linear")
        --// MAIN
        dxDrawImage(backX, backY, backWidth, backHeight, renderSvgs.backgroundImage, 0, 0, 0, tocolor(46, 50, 62, alpha[1]))

        dxDrawImage(backX + (20), backY + (backHeight / 2 - 18 / 2), 18, 18, "src/client/assets/images/info.png", 0, 0, 0, tocolor(255, 255, 255, alpha[1]))
        dxDrawText("Bomba de Combustível", backX + (50), backY + (backHeight / 2 - 18 / 2) - (5), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular12)
        dxDrawText("Selecione o tipo de combustível que você deseja usar", backX + (50), backY + (backHeight / 2 - 18 / 2) + (10), 120, 18, tocolor(186, 186, 186, alpha[1]), 1, Fonts.p_regular9)

        --// SELECT TYPE
        if isCursorOnElement(backX, backY + (backHeight + 5), backWidth, backHeight) and alpha[1] == 255 then
            dxDrawImage(backX, backY + (backHeight + 5), backWidth, backHeight, renderSvgs.backgroundImage, 0, 0, 0, tocolor(46, 50, 62, 200))
        else
            dxDrawImage(backX, backY + (backHeight + 5), backWidth, backHeight, renderSvgs.backgroundImage, 0, 0, 0, tocolor(46, 50, 62, alpha[1]))
        end

        dxDrawImage(backX + (20), backY + (backHeight) + (backHeight / 2 - 18 / 2), 18, 18, "src/client/assets/images/gas.png", 0, 0, 0, tocolor(255, 255, 255, alpha[1]))
        dxDrawText("Normal", backX + (50), backY + (backHeight) + (backHeight / 2 - 18 / 2) - (10), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular12)
        dxDrawText("Capacidade: #BABABA"..math.floor(can_quantity), backX + (50), backY + (backHeight) + (backHeight / 2 - 18 / 2) + (10), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular12, "left", "top", false, false, false, true)
        dxDrawText("|     Preço: #BABABA$"..math.floor(price), backX + (backWidth - 140), backY + (backHeight) + (backHeight / 2 - 18 / 2) + (10), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular12, "left", "top", false, false, false, true)
    elseif panelState == "quantity" then
        progress = (getTickCount() - tick) / anim_time
        alpha[1] = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, progress, "Linear")
        dxDrawImage(quantityX, quantityY, quantityWidth, quantityHeight, renderSvgs.quantityBg, 0, 0, 0, tocolor(46, 50, 62, alpha[1]))

        dxDrawText("O tanque tem capacidade para mais "..math.floor(quantity).."/"..math.floor(can_quantity).." litros", quantityX + (45), quantityY + (quantityHeight / 2 - 18 / 2) - (10), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular10)
        dxDrawImage(quantityX + (quantityWidth - 50), quantityY + (quantityHeight / 2 - 20 / 2) - (15), 15, 20, "src/client/assets/images/button.png", 0, 0, 0, tocolor(255, 255, 255, alpha[1]))

        dxDrawRectangle(quantityX + (25), quantityY + (80), 300, 2, tocolor(255, 255, 255, alpha[1]))
        if isCursorOnElement(quantityX + (quantityWidth / 2 - 150 / 2), quantityY + (quantityHeight - 50), 150, 40) and alpha[1] == 255 then
            dxDrawImage(quantityX + (quantityWidth / 2 - 150 / 2), quantityY + (quantityHeight - 50), 150, 40, renderSvgs.button, 0, 0, 0, tocolor(255, 255, 255, 200))
        else
            dxDrawImage(quantityX + (quantityWidth / 2 - 150 / 2), quantityY + (quantityHeight - 50), 150, 40, renderSvgs.button, 0, 0, 0, tocolor(255, 255, 255, alpha[1]))
        end
    elseif panelState == "payment" then
        progress = (getTickCount() - tick) / anim_time
        alpha[1] = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, progress, "Linear")
        --// MAIN
        dxDrawImage(backX, backY, backWidth, backHeight, renderSvgs.backgroundImage, 0, 0, 0, tocolor(46, 50, 62, alpha[1]))

        dxDrawImage(backX + (20), backY + (backHeight / 2 - 18 / 2), 18, 18, "src/client/assets/images/info.png", 0, 0, 0, tocolor(255, 255, 255, alpha[1]))
        dxDrawText("Reabastecer veículo", backX + (50), backY + (backHeight / 2 - 18 / 2) - (10), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular12)
        dxDrawText("Quantidade: #BABABA"..math.floor(quantity), backX + (50), backY + (backHeight / 2 - 18 / 2) + (10), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular12, "left", "top", false, false, false, true)
        dxDrawText("|     Preço: #BABABA$"..math.floor(quantity * price), backX + (backWidth - 140), backY + (backHeight / 2 - 18 / 2) + (10), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular12, "left", "top", false, false, false, true)

        if isCursorOnElement(backX, backY + (backHeight + 5), backWidth, backHeight - (20)) and alpha[1] == 255 then
            dxDrawImage(backX, backY + (backHeight + 5), backWidth, backHeight - (20), renderSvgs.backgroundSelect, 0, 0, 0, tocolor(46, 50, 62, 200))
        else
            dxDrawImage(backX, backY + (backHeight + 5), backWidth, backHeight - (20), renderSvgs.backgroundSelect, 0, 0, 0, tocolor(46, 50, 62, alpha[1]))
        end
        dxDrawImage(backX + (20), backY + (backHeight + 5) + (40 / 2 - 18 / 2), 18, 18, "src/client/assets/images/cash.png", 0, 0, 0, tocolor(255, 255, 255, alpha[1]))
        dxDrawText("Pagar com dinheiro", backX + (50), backY + (backHeight + 5) + (40 / 2 - 18 / 2), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular11)

        if isCursorOnElement(backX, backY + (backHeight + 5) + (40 + 5), backWidth, backHeight - (20)) and alpha[1] == 255 then
            dxDrawImage(backX, backY + (backHeight + 5) + (40 + 5), backWidth, backHeight - (20), renderSvgs.backgroundSelect, 0, 0, 0, tocolor(46, 50, 62, 200))
        else
            dxDrawImage(backX, backY + (backHeight + 5) + (40 + 5), backWidth, backHeight - (20), renderSvgs.backgroundSelect, 0, 0, 0, tocolor(46, 50, 62, alpha[1]))
        end
        dxDrawImage(backX + (20), backY + (backHeight + 5) + (40 / 2 - 18 / 2) + (40 + 5), 18, 18, "src/client/assets/images/card.png", 0, 0, 0, tocolor(255, 255, 255, alpha[1]))
        dxDrawText("Pagar com cartão", backX + (50), backY + (backHeight + 5) + (40 / 2 - 18 / 2) + (40 + 5), 120, 18, tocolor(255, 255, 255, alpha[1]), 1, Fonts.p_regular11)
    end
end

local function clientClick(btn, state)
    if btn == "left" and state == "down" then
        if showing then
            if panelState == "init" then
                if isCursorOnElement(backX, backY + (backHeight + 5), backWidth, backHeight) then
                    if delayTimer then return end
                    delayTimer = true
                    if isTimer(killDelay) then return end
                    killDelay = setTimer(function() delayTimer = false end, anim_time, 1)
                    progress = 0
                    tick = getTickCount()
                    alpha = {alpha[1], 0}
                    setTimer(function()
                        progress = 0
                        tick = getTickCount()
                        alpha = {0, 255}
                        panelState = "quantity"
                    end, anim_time, 1)
                end
            elseif panelState == "quantity" then
                if isCursorOnElement(quantityX + (quantityWidth - 50), quantityY + (quantityHeight / 2 - 20 / 2) - (15), 15, 10) then
                    if quantity < 100 and quantity < can_quantity then
                        quantity = quantity + 1
                    end
                elseif isCursorOnElement(quantityX + (quantityWidth - 50), quantityY + (quantityHeight / 2 - 20 / 2) - (5), 15, 10) then
                    if quantity > 1 then
                        quantity = quantity - 1
                    end
                end
                if isCursorOnElement(quantityX + (quantityWidth / 2 - 150 / 2), quantityY + (quantityHeight - 50), 150, 40) then
                    if delayTimer then return end
                    delayTimer = true
                    if isTimer(killDelay) then return end
                    killDelay = setTimer(function() delayTimer = false end, anim_time, 1)
                    if quantity > 0 then
                        progress = 0
                        tick = getTickCount()
                        alpha = {alpha[1], 0}
                        setTimer(function()
                            progress = 0
                            tick = getTickCount()
                            alpha = {0, 255}
                            panelState = "payment"
                        end, anim_time, 1)
                    else
                        return msg(player, "Você tem que abastecer ao menos 1 litro", "error")
                    end
                end
            elseif panelState == "payment" then
                if delayTimer then return end
                delayTimer = true
                if isTimer(killDelay) then return end
                killDelay = setTimer(function() delayTimer = false end, anim_time, 1)
                if isCursorOnElement(backX, backY + (backHeight + 5), backWidth, backHeight - (20)) then -- WITH MONEY
                    local thePrice = math.floor((quantity * price))
                    local engine = getVehicleEngineState(p_fueling[localPlayer][1])
                    triggerServerEvent('class:paymentGas', localPlayer, localPlayer, p_fueling[localPlayer][1], thePrice, math.floor(quantity), false, engine)
                    closePanel()
                elseif isCursorOnElement(backX, backY + (backHeight + 5) + (40 + 5), backWidth, backHeight - (20)) then -- WITH CARD
                    local thePrice = math.floor((quantity * price))
                    local engine = getVehicleEngineState(p_fueling[localPlayer][1])
                    triggerServerEvent('class:paymentGas', localPlayer, localPlayer, p_fueling[localPlayer][1], thePrice, math.floor(quantity), true, engine)
                    closePanel()
                end
            end
        end
    end
end

function setFueling(player, vehicle, quantity, card)
    local v_fuel = getElementData(vehicle, "Fuel")
    quantity = tonumber(quantity)
    if v_fuel and v_fuel < 100 then
        setElementFrozen(player, true)
        setElementData(player, "class:fueling", true)

        setElementData(vehicle, "Fuel", v_fuel + quantity)

        triggerEvent("ProgressBar", localPlayer, quantity*1000, "Abastecendo")
        triggerServerEvent('class:setAnim', localPlayer, localPlayer, "ped", "jetpack_idle")
        setTimer(function()
            setElementFrozen(localPlayer, false)
            setElementData(localPlayer, "class:fueling", false)
            triggerServerEvent('class:setAnim', localPlayer, localPlayer)
        end, quantity*1000, 1)
    end
end
addEvent("class:setFueling", true)
addEventHandler("class:setFueling", root, setFueling)

local function hitOnSphere(theElement)
    for index, value in ipairs(the_gas) do
        if source == the_gas[index].colshape then
            if getElementType(theElement) == "vehicle" then
                the_gas[index].vehicle = theElement
            elseif getElementType(theElement) == "player" and theElement == localPlayer then
                if getPedOccupiedVehicle(theElement) then
                    msg(theElement, "Desligue o carro para abastecer!", "warning")
                end
            end  
            if the_gas[index].vehicle then
                if getElementType(theElement) == "player" and theElement == localPlayer then
                    setElementData(theElement, "class:inGasStation", true)
                    p_fueling[theElement] = {the_gas[index].vehicle, source}
                end
            end
        end
    end
end

function closePanel()
    if showing then
        progress = 0
        tick = getTickCount()
        alpha = {alpha[1], 0}
        setTimer(function()
            unbindKey("backspace", "down", backLastPanel)
            showing = false
            showCursor(false)
            removeEventHandler("onClientClick", root, clientClick)
            removeEventHandler("onClientRender", root, render)
        end, anim_time, 1)
    end
end

local function backLastPanel()
    if showing then
        if delayTimer then return end
        delayTimer = true
        if isTimer(killDelay) then return end
        killDelay = setTimer(function() delayTimer = false end, anim_time, 1)
        if panelState == "init" then
            closePanel()
        elseif panelState == "quantity" then
            progress = 0
            tick = getTickCount()
            alpha = {alpha[1], 0}
            setTimer(function()
                progress = 0
                tick = getTickCount()
                alpha = {0, 255}
                panelState = "init"
            end, anim_time, 1)
        elseif panelState == "payment" then
            progress = 0
            tick = getTickCount()
            alpha = {alpha[1], 0}
            setTimer(function()
                progress = 0
                tick = getTickCount()
                alpha = {0, 255}
                panelState = "quantity"
            end, anim_time, 1)
        end
    end
end

function openGasStation()
    if p_fueling[localPlayer] and isElementWithinColShape(localPlayer, p_fueling[localPlayer][2]) and not showing then
        if getElementData(p_fueling[localPlayer][1], "Fuel") >= 100 then return end 
        showing = true
        panelState = "init"
        can_quantity = 100 - getElementData(p_fueling[localPlayer][1], "Fuel")
        quantity = can_quantity

        bindKey("backspace", "down", backLastPanel)
        showCursor(true)

        alpha = {0, 255}
        tick = getTickCount()
        addEventHandler("onClientRender", root, render)
        addEventHandler("onClientClick", root, clientClick)
    end
end
addEvent("class:openGasStation", true)
addEventHandler("class:openGasStation", root, openGasStation)

local function leaveOnSphere(theElement)
    for index, value in ipairs(the_gas) do
        if source == the_gas[index].colshape then
            if getElementType(theElement) == "vehicle" then
                the_gas[index].vehicle = nil
            elseif getElementType(theElement) == "player" and theElement == localPlayer then
                p_fueling[theElement] = {}
                setElementData(theElement, "class:inGasStation", false)
            end
        end
    end
end

local function init()
    for index, value in ipairs(gas_station) do
        if not the_gas[index] then the_gas[index] = {} end
        the_gas[index].colshape = createColSphere(value[1], value[2], value[3], value[4])
    end
    for _, blipsPos in ipairs(blips_gas) do
        createBlip(blipsPos[1], blipsPos[2], blipsPos[3], 46)
    end
    addEventHandler("onClientColShapeHit", root, hitOnSphere)
    addEventHandler("onClientColShapeLeave", root, leaveOnSphere)
end
addEventHandler("onClientResourceStart", resourceRoot, init)