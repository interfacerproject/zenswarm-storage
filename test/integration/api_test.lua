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

local t = require('luatest')
local g = t.group('integration_api')

local helper = require('test.helper')
local cluster = helper.cluster

g.before_all = function()
    g.cluster = helper.cluster
    g.cluster:start()
end

g.after_all = function()
    helper.stop_cluster(g.cluster)
end

g.before_each = function()
    -- helper.truncate_space_on_cluster(g.cluster, 'Set your space name here')
end

g.test_sample = function()
    local server = cluster.main_server
    local response = server:http_request('post', '/admin/api', {json = {query = '{ cluster { self { alias } } }'}})
    t.assert_equals(response.json, {data = { cluster = { self = { alias = 'api' } } }})
    t.assert_equals(server.net_box:eval('return box.cfg.memtx_dir'), server.workdir)
end

g.test_metrics = function()
    local server = cluster.main_server
    local response = server:http_request('get', '/metrics')
    t.assert_equals(response.status, 200)
    t.assert_equals(response.reason, "Ok")
end
