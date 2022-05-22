# frozen_string_literal: true

# Override by platform family
root_group, path_prefix =
  case platform[:family]
  when 'bsd'
    %w[wheel /usr/local/]
  else
    %w[root /]
  end

control 'wireguard configuration' do
  title 'should match desired lines'

  describe file("#{path_prefix}etc/wireguard/wg0.priv") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into root_group }
    its('mode') { should cmp '0600' }
  end

  describe file("#{path_prefix}etc/wireguard/wg0.pub") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into root_group }
    its('mode') { should cmp '0644' }
  end

  describe file("#{path_prefix}etc/wireguard/wg0.conf") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into root_group }
    its('mode') { should cmp '0600' }
    its('content') do
      should eq(
        <<~HEREDOC
          ########################################################################
          # File managed by Salt at <salt://wireguard/files/default/wireguard.conf.jinja>.
          # Your changes will be overwritten.
          ########################################################################

          [Interface]
          ListenPort = 51820
          PostUp = wg set %i private-key #{path_prefix}etc/wireguard/wg0.priv && (true)

          [Peer]
          # minion_id1
          AllowedIPs = 10.0.45.0/24,10.0.47.0/24
          Endpoint = 10.0.34.4:51820
          PublicKey = FSvVqj2s1FZqsSIvPLrE1RRTgbaPLbfG87P36F21M1g=
        HEREDOC
      )
    end
  end
end
