require 'spec_helper'

describe 'supervisord::rpcinterface', :type => :define do
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
      let(:default_params) do
        { rpcinterface_factory: 'bar:baz' }
      end

      context 'default' do
        let(:params) { default_params }
        it { is_expected.to contain_supervisord__rpcinterface('foo') }
        it { is_expected.to contain_file('/etc/supervisor.d/rpcinterface_foo.conf').with_content(/\[rpcinterface:foo\]/) }
        it { is_expected.to contain_file('/etc/supervisor.d/rpcinterface_foo.conf').with_content(/supervisor\.rpcinterface_factory = bar:baz/) }
        it { is_expected.to contain_file('/etc/supervisor.d/rpcinterface_foo.conf').without_content(/retries/) }
      end

      context 'retries' do
        let(:params) { { retries: 2 }.merge(default_params) }
        it { is_expected.to contain_supervisord__rpcinterface('foo') }
        it { is_expected.to contain_file('/etc/supervisor.d/rpcinterface_foo.conf').with_content(/\[rpcinterface:foo\]/) }
        it { is_expected.to contain_file('/etc/supervisor.d/rpcinterface_foo.conf').with_content(/supervisor\.rpcinterface_factory = bar:baz/) }
        it { is_expected.to contain_file('/etc/supervisor.d/rpcinterface_foo.conf').with_content(/retries = 2/) }
      end
    end
  end
end
