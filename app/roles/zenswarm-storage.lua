local cartridge = require('cartridge')
local log = require('log')

local function init(opts)
    if opts.is_master then
        local vtable = box.schema.space.create('values', {
            if_not_exists = true,
            engine = 'vinyl',
            format = {
                { 'key', 'string' },
                { 'bucket_id', 'unsigned' },
                { 'value', 'map' },
            }
        })

        vtable:create_index('key', {
            parts = { { field = 'key', is_nullable = false } },
            if_not_exists = true,
        })
        vtable:create_index('bucket_id', {
            parts = { { field = 'bucket_id', is_nullable = false } },
            if_not_exists = true,
        })

        log.info('ZENSWARM TABLE VSHARD INITIALIZED 🎉')
    end

    return true
end

return {
    role_name = 'app.roles.zenswarm-storage',
    init = init,
    dependencies = { 'cartridge.roles.crud-storage' },
}
