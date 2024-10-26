config = {

    group = {
		{'Pizzaria'};
	};

    caixas = {
        {
            position = {2392.062, -1909.684, 14.383 -0.8,-0, 0, 181},
            acl = 'CluckinBell',
            model = 1514,
        }
    };

}

function msg ( player, msg, type, ... )
    return exports.crp_notify:addBox(player, msg, type, ...)
end