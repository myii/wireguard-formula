# frozen_string_literal: true

# Override by platform family
service_name =
  case platform[:family]
  when 'bsd'
    'wireguard'
  else
    'wg-quick@wg0'
  end

control 'wireguard service' do
  title 'should be installed, enabled & running'

  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
