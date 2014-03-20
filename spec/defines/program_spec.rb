require 'spec_helper'

describe 'supervisord::program', :type => :define do
  let(:title) {'foo'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat' }}
  let(:default_params) do 
    {
      :command                 => 'bar',
      :process_name            => '%(process_num)s',
      :numprocs                => '1',
      :numprocs_start          => '0',
      :priority                => '999',
      :autostart               => true,
      :autorestart             => 'unexpected',
      :startsecs               => '1',
      :startretries            => '3',
      :exitcodes               => '0,2',
      :stopsignal              => 'TERM',
      :stopwaitsec             => '10',
      :stopasgroup             => false,
      :killasgroup             => false,
      :user                    => 'baz',
      :redirect_stderr         => false,
      :stdout_logfile          => 'program_foo.log',
      :stdout_logfile_maxbytes => '50MB',
      :stdout_logfile_backups  => '10',
      :stdout_capture_maxbytes => '0',
      :stdout_events_enabled   => false,
      :stderr_logfile          => 'program_foo.error',
      :stderr_logfile_maxbytes => '50MB',
      :stderr_logfile_backups  => '10',
      :stderr_capture_maxbytes => '0',
      :stderr_events_enabled   => false,
      :environment             => { 'env1' => 'value1', 'env2' => 'value2' },
      :directory               => '/opt/supervisord/chroot',
      :umask                   => '022',
      :serverurl               => 'AUTO'
    }
  end

  context 'default' do
    let(:params) { default_params }

    it { should contain_supervisord__program('foo') }
    it { should contain_file('/etc/supervisor.d/program_foo.conf').with_content(/\[program:foo\]/) }
    it { should contain_file('/etc/supervisor.d/program_foo.conf').with_content(/command=bar/) }
    it { should contain_file('/etc/supervisor.d/program_foo.conf').with_content(/user=baz/) }
    it { should contain_file('/etc/supervisor.d/program_foo.conf').with_content(/stdout_logfile=\/var\/log\/supervisor\/program_foo.log/) }
    it { should contain_file('/etc/supervisor.d/program_foo.conf').with_content(/stderr_logfile=\/var\/log\/supervisor\/program_foo.error/) }
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
