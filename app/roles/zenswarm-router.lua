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

local cartridge = require('cartridge')
local crud = require('crud')
local log = require('log')

local function init(opts) -- luacheck: no unused args
    if opts.is_master then
        local httpd = assert(cartridge.service_get('httpd'), 'Failed to get httpd service')

        httpd:route({
            method = 'GET',
            path = '/values',
            public = true,
        },
            function(req)
                local result, err = crud.select('values', nil, { first = 10000 })
                if err then
                    return { status = 500, body = err }
                end
                return req:render({ json = crud.unflatten_rows(result.rows, result.metadata) })
            end
        )

        httpd:route({ 
            method = 'GET',
            path = '/retrieve/:key',
        },
            function(req)
                if not req.tstash.key then
                    return { status = 400, body = 'Missing key' }
                end
                local result, err = crud.get('values', req.tstash.key)
                if err then
                    return { status = 500, body = err }
                end
                return req:render({ json = crud.unflatten_rows(result.rows, result.metadata) })
            end
        )

        httpd:route({
            method = 'POST',
            path = '/retrieve',
        },
            function(req)
                local body = req:json()
                log.error(body)
                if not body.key then
                    return { status = 400, body = 'Missing key' }
                end
                local result, err = crud.get('values', body.key)
                if err then
                    return { status = 500, body = err }
                end
                return req:render({ json = crud.unflatten_rows(result.rows, result.metadata) })
            end
        )

        httpd:route({
            method = 'POST',
            path = '/store',
            public = true,
        },
            function(req)
                local body = req:json()
                log.info('body: ', body)
                local result, err = crud.insert_object('values', body)
                if err then
                    return { status = 500, body = err }
                end
                return { status = 200, body = result }
            end
        )
    end
end

return {
    role_name = 'app.roles.zenswarm-router',
    init = init,
    dependencies = { 'cartridge.roles.crud-router' },
}
