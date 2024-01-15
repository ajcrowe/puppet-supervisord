require 'spec_helper'

describe 'supervisord::ctlplugin' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:title) { 'foo' }
      let(:facts) do
        os_facts.merge(
          concat_basedir: '/var/lib/puppet/concat'
        )
      end
      let(:pre_condition) do
        [
          "class { 'supervisord': unix_username => 'foo', unix_password => 'bar', inet_username => 'foo', inet_password => 'bar' }",
        ]
      end

      context 'default' do
        let(:params) do
          { :ctl_factory => 'bar.baz:make_bat' }
        end
        it { is_expected.to contain_supervisord__ctlplugin('foo') }
        it do
          is_expected.to contain_concat__fragment('ctlplugin:foo')
                           .with_content(/supervisor\.ctl_factory = bar\.baz:make_bat/)
        end
      end
    end
  end
end
