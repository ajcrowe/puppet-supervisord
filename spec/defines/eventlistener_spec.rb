require 'spec_helper'

describe 'supervisord::eventlistener', :type => :define do
  let(:title) {'foo'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat' }}
  let(:default_params) do 
    { 
      :command        => 'bar',
      :stdout_logfile => 'eventlistener_foo.log',
      :stderr_logfile => 'eventlistener_foo.error'
    }
  end

  context 'default' do
    let(:params) { default_params }

    it { should contain_supervisord__eventlistener('foo') }
    it { should contain_file('/etc/supervisor.d/eventlistener_foo.conf').with_content(/command=bar/) }
  end

  context 'ensure_process_stopped' do
    let(:params) { default_params.merge({ :ensure_process => 'stopped' }) }
    it { should contain_supervisord__supervisorctl('stop_foo') }
  end

  context 'ensure_process_removed' do
    let(:params) { default_params.merge({ :ensure_process => 'removed' }) }
    it { should contain_supervisord__supervisorctl('remove_foo') }
  end
end
