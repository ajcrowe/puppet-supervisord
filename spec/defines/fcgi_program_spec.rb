require 'spec_helper'

describe 'supervisord::fcgi_program' do
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
        {
          :command => 'bar',
          :socket => 'tcp://localhost:1000',
          :process_name => '%(process_num)s',
          :events => ['PROCESS_STATE', 'PROCESS_STATE_STARTING'],
          :buffer_size => 10,
          :numprocs => 1,
          :numprocs_start => 0,
          :priority => 999,
          :autostart => true,
          :autorestart => 'unexpected',
          :startsecs => 1,
          :startretries => 3,
          :exitcodes => '0,2',
          :stopsignal => 'TERM',
          :stopwaitsecs => 10,
          :stopasgroup => true,
          :killasgroup => true,
          :user => 'baz',
          :redirect_stderr => true,
          :stdout_logfile => 'fcgi-program_foo.log',
          :stdout_logfile_maxbytes => '50MB',
          :stdout_logfile_backups => 10,
          :stdout_capture_maxbytes => '0',
          :stdout_events_enabled => true,
          :stderr_logfile => 'fcgi-program_foo.error',
          :stderr_logfile_maxbytes => '50MB',
          :stderr_logfile_backups => 10,
          :stderr_capture_maxbytes => '0',
          :stderr_events_enabled => true,
          :program_environment => { 'env1' => 'value1', 'env2' => 'value2' },
          :directory => '/opt/supervisord/chroot',
          :umask => '022',
          :serverurl => 'AUTO'
        }
      end

      context 'default' do
        let(:params) { default_params }

        it { is_expected.to contain_supervisord__fcgi_program('foo') }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/\[fcgi-program:foo\]/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/socket=tcp:\/\/localhost:1000/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/command=bar/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/process_name=\%\(process_num\)s/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/numprocs=1/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/numprocs_start=0/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/priority=999/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/autostart=true/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/startsecs=1/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/startretries=3/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/exitcodes=0,2/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stopsignal=TERM/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stopwaitsecs=10/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stopasgroup=true/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/killasgroup=true/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/user=baz/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/redirect_stderr=true/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stdout_logfile=\/var\/log\/supervisor\/fcgi-program_foo.log/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stdout_logfile_maxbytes=50MB/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stdout_logfile_backups=10/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stdout_capture_maxbytes=0/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stdout_events_enabled=true/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stderr_logfile=\/var\/log\/supervisor\/fcgi-program_foo.error/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stderr_logfile_maxbytes=50MB/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stderr_logfile_backups=10/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stderr_capture_maxbytes=0/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stderr_events_enabled=true/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/environment=env1='value1',env2='value2'/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/directory=\/opt\/supervisord\/chroot/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/umask=022/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/serverurl=AUTO/) }
      end

      context 'ensure_process_stopped' do
        let(:params) { default_params.merge({ ensure_process: 'stopped' }) }
        it { is_expected.to contain_supervisord__supervisorctl('stop_foo') }
      end

      context 'ensure_process_removed' do
        let(:params) { default_params.merge({ ensure_process: 'removed' }) }
        it { is_expected.to contain_supervisord__supervisorctl('remove_foo') }
      end

      context 'change_process_name_on_numprocs_gt_1' do
        let(:params) do
          {
            numprocs: 2,
            command: 'bar',
            socket: 'tcp://localhost:1000',
          }
        end
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/numprocs=2/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/process_name=\%\(program_name\)s_\%\(process_num\)02d/) }
      end

      context 'absolute_log_paths' do
        let(:params) do
          default_params.merge(
            stdout_logfile: '/path/to/program_foo.log',
            stderr_logfile: '/path/to/program_foo.error',
          )
        end
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stdout_logfile=\/path\/to\/program_foo.log/) }
        it { is_expected.to contain_file('/etc/supervisor.d/fcgi-program_foo.conf').with_content(/stderr_logfile=\/path\/to\/program_foo.error/) }
      end
    end
  end
end
