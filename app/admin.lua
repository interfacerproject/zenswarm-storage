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

local cli_admin = require('cartridge-cli-extensions.admin')

-- register admin function probe to use it with "cartridge admin"
local function init()
    cli_admin.init()

    local probe = {
        usage = 'Probe instance',
        args = {
            uri = {
                type = 'string',
                usage = 'Instance URI',
            },
        },
        call = function(opts)
            opts = opts or {}

            if opts.uri == nil then
                return nil, "Please, pass instance URI via --uri flag"
            end

            local cartridge_admin = require('cartridge.admin')
            local ok, err = cartridge_admin.probe_server(opts.uri)

            if not ok then
                return nil, err.err
            end

            return {
                string.format('Probe %q: OK', opts.uri),
            }
        end,
    }

    local ok, err = cli_admin.register('probe', probe.usage, probe.args, probe.call)
    assert(ok, err)
end

return {init = init}
