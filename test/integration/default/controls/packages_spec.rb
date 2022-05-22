# frozen_string_literal: true

# Override by platform family
package_name =
  case system.platform[:family]
  when 'redhat', 'fedora', 'suse', 'arch'
    'wireguard-tools'
  when 'gentoo'
    'net-vpn/wireguard-tools'
  else
    'wireguard'
  end

control 'wireguard package' do
  title 'should be installed'

  describe package(package_name) do
    it { should be_installed }
  end
end
