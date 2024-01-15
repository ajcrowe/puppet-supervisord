require 'spec_helper'

describe 'supervisord::supervisorctl' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:default_params) do
        {
          command: 'command',
        }
      end
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

      context 'without process' do
        let(:title) { 'command' }
        let(:params) { default_params }
        it { is_expected.to contain_supervisord__supervisorctl('command') }
        it { is_expected.to contain_exec('supervisorctl_command_command').with_command(/supervisorctl command/) }
      end

      context 'with process' do
        let(:title) { 'command_foo' }
        let(:params) { default_params.merge({ process: 'foo' }) }
        it { is_expected.to contain_supervisord__supervisorctl('command_foo') }
        it { is_expected.to contain_exec('supervisorctl_command_command_foo').with_command(/supervisorctl command foo/) }
      end
    end
  end
end
