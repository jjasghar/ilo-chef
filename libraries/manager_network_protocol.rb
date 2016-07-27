# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
module IloCookbook
  # Class for Network Protocol actions
  class ManagerNetworkProtocol < ChefCompat::Resource
    require_relative 'ilo_helper'
    include IloCookbook::IloHelper

    resource_name :ilo_manager_network_protocol

    property :ilos, Array, required: true
    property :timeout, Fixnum, equal_to: [15, 30, 60, 120, 0]

    action_class do
      include IloHelper
    end

    action :set do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_timeout
        next if cur_val == timeout
        converge_by "Set ilo #{client.host} session timeout from '#{cur_val}' to '#{timeout}'" do
          client.set_timeout(timeout)
        end
      end
    end

  end
end
