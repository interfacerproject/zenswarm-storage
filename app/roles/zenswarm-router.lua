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
