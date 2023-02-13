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
