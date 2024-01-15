require 'spec_helper'

describe 'supervisord' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:concatdir) { '/var/lib/puppet/concat' }
      let(:facts) do
        os_facts.merge(
          concat_basedir: concatdir
        )
      end
      let(:params) do
        {
          unix_username: 'foo',
          unix_password: 'bar',
          inet_username: 'foo',
          inet_password: 'bar',
        }
      end

      it { is_expected.to contain_class('supervisord') }
      it { is_expected.to contain_class('supervisord::install') }
      it { is_expected.to contain_class('supervisord::config') }
      it { is_expected.to contain_class('supervisord::service') }
      it { is_expected.to contain_class('supervisord::params') }
      it { is_expected.to contain_class('supervisord::reload') }
      it { is_expected.to contain_package('supervisor') }

      describe '#service_name' do
        context 'default' do
          it { is_expected.to contain_service('supervisord') }
        end

        context 'specified' do
          let(:params) do
            super().merge(
              service_name: 'myservicename',
            )
          end
          it { is_expected.to contain_service('myservicename') }
        end
      end

      describe '#install_pip' do
        context 'default' do
          it { is_expected.not_to contain_class('supervisord::pip') }
        end

        context 'true' do
          let(:params) do
            super().merge(
             install_pip: true,
            )
          end
          it { is_expected.to contain_class('supervisord::pip') }
          it { is_expected.to contain_exec('install_setuptools') }
          it { is_expected.to contain_exec('install_pip') }
        end

        context 'true and RedHat' do
          let(:params) do
            super().merge(
              install_pip: true,
            )
          end
          case os_facts[:os][:family]
          when 'RedHat'
            it { is_expected.to contain_exec('pip_provider_name_fix') }
          end
        end

        context 'true and package_install_options not specified' do
          let(:params) do
            super().merge(
              install_pip: true,
              package_install_options: false,
            )
          end
          it { is_expected.to contain_package('supervisor').with_install_options(false) }
        end
      end

      describe '#env_var' do
        context 'default' do
          it { is_expected.to contain_class('supervisord').without_env_hash }
          it { is_expected.to contain_class('supervisord').without_env_string }
        end
      end

      describe '#global_environment' do
        context 'default' do
          it { is_expected.to contain_class('supervisord').without_env_string }
        end
        context 'is specified' do
          let(:params) do
            super().merge(
              global_environment: { 'key1' => 'value1', 'key2' => 'value2' },
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/environment=key1='value1',key2='value2'/) }
        end
      end

      describe '#install_init' do
        context 'with custom init script' do
          let(:params) do
            super().merge(
              init_script: '/etc/init/supervisord',
              init_script_template: 'supervisord/init/Debian/systemd.erb',
              init_defaults: false,
              install_init: true,
            )
          end
          it { is_expected.to contain_file('/etc/init/supervisord') }
        end

        context 'on supported OS' do
          case os_facts[:os][:family]
          when 'RedHat'
            context 'with RedHat' do
              it { is_expected.to contain_file('/etc/systemd/system/supervisord.service') }
              it { is_expected.to contain_file('/etc/sysconfig/supervisord') }
              it { is_expected.to contain_file('/etc/systemd/system/supervisord.service').with_content(/LimitNOFILE=1024$/) }
            end
          when 'Debian'
            context 'with Debian' do
              it { is_expected.to contain_file('/etc/systemd/system/supervisord.service') }
              it { is_expected.not_to contain_file('/etc/default/supervisor') }
              it { is_expected.to contain_file('/etc/systemd/system/supervisord.service').with_content(/LimitNOFILE=1024$/) }
            end
          end
        end
      end

      describe '#unix_socket' do
        context 'default' do
          it { is_expected.to contain_concat__fragment('supervisord_unix') }
        end
        context 'false' do
          let(:params) do
            super().merge(
              unix_socket: false,
            )
          end
          it { is_expected.not_to contain_concat__fragment('supervisord_unix') }
        end
      end

      describe '#inet_server' do
        context 'default' do
          it { is_expected.not_to contain_concat__fragment('supervisord_inet') }
        end
        context 'true' do
          let(:params) do
            super().merge(
              inet_server: true,
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_inet') }
        end
      end

      describe '#ctl_socket' do
        context 'default' do
          it { is_expected.to contain_concat__fragment('supervisord_ctl')
                        .with_content(/serverurl=unix:\/\/\/var\/run\/supervisor\.sock$/) }
        end
        context 'http' do
          let(:params) do
            super().merge(
              inet_server: true,
              ctl_socket: 'inet'
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_ctl')
                        .with_content(/serverurl=http:\/\/127\.0\.0\.1:9001$/) }
        end
      end

      describe '#run_path' do
        context 'default' do
          it { is_expected.not_to contain_file('/var/run') }
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/pidfile=\/var\/run\/supervisord.pid$/) }
        end
        context 'is specified' do
          let(:params) do
            super().merge(
              run_path: '/opt/supervisord/run',
            )
          end
          it { is_expected.to contain_file('/opt/supervisord/run') }
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/pidfile=\/opt\/supervisord\/run\/supervisord.pid$/) }
        end
      end

      describe '#log_path' do
        context 'default' do
          it { is_expected.to contain_file('/var/log/supervisor') }
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/logfile=\/var\/log\/supervisor\/supervisord.log$/) }
        end
        context 'is specified' do
          let(:params) do
            super().merge(
              log_path: '/opt/supervisord/logs',
            )
          end
          it { is_expected.to contain_file('/opt/supervisord/logs') }
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/logfile=\/opt\/supervisord\/logs\/supervisord.log$/) }
        end
      end

      describe '#config_include' do
        context 'default' do
          it { is_expected.to contain_file('/etc/supervisor.d') }
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/files=\/etc\/supervisor.d\/\*.conf$/) }
        end
        context 'is specified' do
          let(:params) do
            super().merge(
              config_include: '/opt/supervisord/conf.d',
            )
          end
          it { is_expected.to contain_file('/opt/supervisord/conf.d') }
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/files=\/opt\/supervisord\/conf.d\/\*.conf$/) }
        end
      end

      describe '#config_dirs' do
        context 'is specified' do
          let(:params) do
            super().merge(
              config_dirs: [
                '/etc/supervisor.d/*.conf',
                '/opt/supervisor.d/*',
                '/usr/share/supervisor.d/*.config'
              ],
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/files=\/etc\/supervisor.d\/\*.conf \/opt\/supervisor.d\/\* \/usr\/share\/supervisor.d\/\*.config$/) }
        end
      end

      describe '#config_file' do
        context 'default' do
          it { is_expected.to contain_concat('/etc/supervisord.conf') }
        end
        context 'is specified' do
          let(:params) do
            super().merge(
              config_file: '/opt/supervisord/supervisor.conf',
            )
          end
          it { is_expected.to contain_concat('/opt/supervisord/supervisor.conf') }
        end
      end

      describe '#nodaemon' do
        context 'default' do
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/nodaemon=false$/) }
        end
        context 'true' do
          let(:params) do
            super().merge(
              nodaemon: true,
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/nodaemon=true$/) }
        end
        context 'invalid' do
          let(:params) do
            super().merge(
              nodaemon: 'invalid',
            )
          end
          it { expect { raise_error(Puppet::Error, /is not a boolean/) } }
        end
      end

      describe '#minfds' do
        context 'default' do
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/minfds=1024$/) }
        end
        context 'specified' do
          let(:params) do
            super().merge(
              minfds: 2048,
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/minfds=2048$/) }
        end
        context 'invalid' do
          let(:params) do
            super().merge(
              minfds: 'string',
            )
          end
          it { expect { raise_error(Puppet::Error, /invalid minfds/) } }
        end
      end

      describe '#minprocs' do
        context 'default' do
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/minprocs=200$/) }
        end
        context 'specified' do
          let(:params) do
            super().merge(
              minprocs: 300,
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/minprocs=300$/) }
        end
        context 'invalid' do
          let(:params) do
            super().merge(
              minprocs: 'string',
            )
          end
          it { expect { raise_error(Puppet::Error, /invalid minprocs/) } }
        end
      end

      describe '#strip_ansi' do
        context 'default' do
          it { is_expected.not_to contain_concat__fragment('supervisord_main')
                            .with_content(/strip_ansi$/) }
        end
        context 'true' do
          let(:params) do
            super().merge(
              strip_ansi: true,
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/strip_ansi=true$/) }
        end
        context 'invalid' do
          let(:params) do
            super().merge(
              strip_ansi: 'string',
            )
          end
          it { expect { raise_error(Puppet::Error, /is not a boolean/) } }
        end
      end

      describe '#user' do
        context 'default' do
          it { is_expected.not_to contain_concat__fragment('supervisord_main')
                            .with_content(/user$/) }
        end
        context 'specified' do
          let(:params) do
            super().merge(
              user: 'myuser',
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/user=myuser$/) }
        end
      end

      describe '#identifier' do
        context 'default' do
          it { is_expected.not_to contain_concat__fragment('supervisord_main')
                            .with_content(/identifier$/) }
        end
        context 'specified' do
          let(:params) do
            super().merge(
              identifier: 'myidentifier',
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/identifier=myidentifier$/) }
        end
      end

      describe '#directory' do
        context 'default' do
          it { is_expected.not_to contain_concat__fragment('supervisord_main')
                            .with_content(/directory$/) }
        end
        context 'specified' do
          let(:params) do
            super().merge(
              directory: '/opt/supervisord',
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/directory=\/opt\/supervisord$/) }
        end
      end

      describe '#nocleanup' do
        context 'default' do
          it { is_expected.not_to contain_concat__fragment('supervisord_main')
                            .with_content(/nocleanup$/) }
        end
        context 'true' do
          let(:params) do
            super().merge(
              nocleanup: true,
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/nocleanup=true$/) }
        end
        context 'invalid' do
          let(:params) do
            super().merge(
              nocleanup: 'string',
            )
          end
          it { expect { raise_error(Puppet::Error, /is not a boolean/) } }
        end
      end

      describe '#childlogdir' do
        context 'default' do
          it { is_expected.not_to contain_concat__fragment('supervisord_main')
                            .with_content(/childlogdir$/) }
        end
        context 'specified' do
          let(:params) do
            super().merge(
              childlogdir: '/opt/supervisord/logdir',
            )
          end
          it { is_expected.to contain_concat__fragment('supervisord_main')
                        .with_content(/childlogdir=\/opt\/supervisord\/logdir$/) }
        end
        context 'invalid' do
          let(:params) do
            super().merge(
              childlogdir: 'not_a_path',
            )
          end
          it { expect { raise_error(Puppet::Error, /is not an absolute path/) } }
        end
      end
    end
  end
end
