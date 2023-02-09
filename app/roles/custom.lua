-- SPDX-License-Identifier: AGPL-3.0-or-later
-- Copyright (C) 2022-2023 Dyne.org foundation <foundation@dyne.org>.
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

-- local cartridge = require('cartridge')

-- local function init(opts) -- luacheck: no unused args
--     -- if opts.is_master then
--     -- end

--     local httpd = assert(cartridge.service_get('httpd'), "Failed to get httpd service")
--     httpd:route({method = 'GET', path = '/hello'}, function()
--         return {body = 'Hello world!'}
--     end)

--     return true
-- end

-- local function stop()
--     return true
-- end

-- local function validate_config(conf_new, conf_old) -- luacheck: no unused args
--     return true
-- end

-- local function apply_config(conf, opts) -- luacheck: no unused args
--     -- if opts.is_master then
--     -- end

--     return true
-- end

-- return {
--     role_name = 'app.roles.custom',
--     init = init,
--     stop = stop,
--     validate_config = validate_config,
--     apply_config = apply_config,
--     -- dependencies = {'cartridge.roles.vshard-router'},
-- }
