require 'spec_helper'

describe 'supervisord::group' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:title) { 'foo' }
      let(:params) { { programs: ['bar', 'baz'] } }
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

      it { is_expected.to contain_supervisord__group('foo').with_program }
      it { is_expected.to contain_file('/etc/supervisor.d/group_foo.conf').with_content(/programs=bar,baz/) }

      describe '#priority' do
        it 'is_expected.to default to undef' do
          is_expected.not_to contain_file('/etc/supervisor.d/group_foo.conf').with_content(/priority/)
          is_expected.to contain_file('/etc/supervisor.d/group_foo.conf').with_content(/programs=bar,baz/)
        end
        context '100' do
          let(:params) { { priority: 100, programs: ['bar', 'baz'] } }
          it { is_expected.to contain_file('/etc/supervisor.d/group_foo.conf').with_content(/priority=100/) }
          it { is_expected.to contain_file('/etc/supervisor.d/group_foo.conf').with_content(/programs=bar,baz/) }
        end
      end
    end
  end
end
